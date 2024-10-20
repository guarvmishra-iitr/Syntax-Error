// SPDX-License-Identifier: MIT

//Assumption: All bidders will vote within the time limit
//Not all will vote 'no' simultaneously.

pragma solidity ^0.8.0;

contract TenderAuction {
    // Struct to represent a bidder
    struct Bidder {
        string name;       // Name of the bidder
        bool active;       // Is currently participating in bidding
        bool hasVoted;     // Whether bidder has voted in the current round
    }

    address public government;            // Address of the government managing the tender
    uint public tenderAmount = 12000;     // Initial tender amount
    uint public reductionAmount = 1000;   // Amount to reduce in each bidding round
    uint public currentBid = 12000;       // Current lowest bid
    uint public currentRound;             // Index of the current bidding round
    uint public bidEndTime;               // End time of the current bid round
    address public winner;                // Address of the winning bidder
    
    mapping(address => Bidder) public biddersMap; // Mapping of address to bidder information

    address[] public bidderList;  // List of all bidders for iteration
    
    // Events to emit for various actions
    event BidRoundInitialized(uint roundIndex, uint bidAmount, uint endTime);
    event BidderVoted(address indexed bidder, bool vote);
    event BidderEliminated(address indexed bidder);
    event TenderWon(address indexed winner, uint finalPrice);

    // Modifier to restrict access to government-only functions
    modifier onlyGovernment() {
        require(msg.sender == government, "Only the government can perform this action.");
        _;
    }

    // Modifier to restrict access to active bidders who haven't voted in the current round
    modifier onlyActiveBidder() {
        require(biddersMap[msg.sender].active, "You are not an active bidder.");
        require(!biddersMap[msg.sender].hasVoted, "You have already voted this round.");
        _;
    }

    // Constructor to initialize the contract with hardcoded government address and bidders
    constructor() {
        // The deployer of the contract is set as the government
        government = msg.sender;

        // Hardcoded bidders with their blockchain addresses and names
        address[3] memory _bidders = [
            0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,  // Alice
            0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,  // Bob
            0x5B38Da6a701c568545dCfcB03FcB875f56beddC4   // Charlie
        ];

        string[3] memory _names = ["Alice", "Bob", "Charlie"];

        // Initialize all bidders and mark them as active
        for (uint i = 0; i < _bidders.length; i++) {
            biddersMap[_bidders[i]] = Bidder(_names[i], true, false);
            bidderList.push(_bidders[i]);
        }
    }

    // Function to start the tender auction (only callable by the government)
    function startAuction() public onlyGovernment {
        currentRound = 1;
        _initializeBidRound();
    }

    // Function for bidders to place their bids (accept or reject the current bid)
    function placeBid(bool _accept) public onlyActiveBidder {
        require(block.timestamp <= bidEndTime, "Bidding time has ended.");

        // Record the vote
        biddersMap[msg.sender].hasVoted = true;
        
        if (_accept) {
            // If the bidder accepts the current bid, they remain active
        } else {
            // If the bidder votes 'no', they are removed from the auction
            biddersMap[msg.sender].active = false;
            emit BidderEliminated(msg.sender);
        }
        
        emit BidderVoted(msg.sender, _accept);

        // Check if all active bidders have voted
        if (_haveAllVoted()) {
            _endBidRound();
        }
    }

    // Internal function to initialize a bidding round
    function _initializeBidRound() internal {
        bidEndTime = block.timestamp + 300 seconds; // Set the bid end time to 5 minutes from now

        // Reset voting status for all active bidders
        for (uint i = 0; i < bidderList.length; i++) {
            if (biddersMap[bidderList[i]].active) {
                biddersMap[bidderList[i]].hasVoted = false;
            }
        }

        emit BidRoundInitialized(currentRound, currentBid, bidEndTime);
    }

    // Internal function to check if all active bidders have voted
    function _haveAllVoted() internal view returns (bool) {
        for (uint i = 0; i < bidderList.length; i++) {
            if (biddersMap[bidderList[i]].active && !biddersMap[bidderList[i]].hasVoted) {
                return false;
            }
        }
        return true;
    }

    // Internal function to end the current bidding round
    function _endBidRound() internal {
        emit BidRoundInitialized(currentRound, currentBid, block.timestamp);  // Emit event with end time
        _initializeNextRound();  // Automatically start the next round
    }

    // Internal function to initialize the next round of bidding
    function _initializeNextRound() internal {
        // If only one active bidder remains, auction ends
        if (_countActiveBidders() == 1) {
            _finalizeAuction();
            return;
        }

        // Prepare for the next round
        currentBid -= reductionAmount; // Reduce the current bid
        currentRound++;
        _initializeBidRound();
    }

    // Internal function to count active bidders
    function _countActiveBidders() internal view returns (uint) {
        uint activeCount = 0;
        for (uint i = 0; i < bidderList.length; i++) {
            if (biddersMap[bidderList[i]].active) {
                activeCount++;
            }
        }
        return activeCount;
    }

    // Function to view the remaining time for the current round
    function getTimeLeft() public view returns (uint) {
        if (block.timestamp >= bidEndTime) {
            return 0;
        } else {
            return bidEndTime - block.timestamp;
        }
    }

    // Function to get the details of a specific bidder
    function getBidderDetails(address _bidder) public view returns (string memory, bool, bool) {
        Bidder memory bidder = biddersMap[_bidder];
        return (bidder.name, bidder.active, bidder.hasVoted);
    }

    // Function to get the winner of the auction
    function getWinner() public view returns (address, uint) {
        require(winner != address(0), "Auction has not ended yet.");
        return (winner, currentBid);
    }

    // Internal function to finalize the auction
    function _finalizeAuction() internal {
        for (uint i = 0; i < bidderList.length; i++) {
            if (biddersMap[bidderList[i]].active) {
                winner = bidderList[i];  // Assign the winner
                break;
            }
        }

        emit TenderWon(winner, currentBid);
    }
}
