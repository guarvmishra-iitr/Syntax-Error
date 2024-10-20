# TenderAuction

## Overview

The TenderAuction smart contract is designed to tackle corruption issues in government tenders by providing a transparent and fair bidding process. This contract allows multiple bidders to participate in an auction, where the bidding amount is progressively reduced until a final winner is determined. The process ensures that all participating bidders have a fair chance and that the tender is awarded transparently.

## Tech Stack

- Blockchain Technology:  Smart Contracts (Solidity)
- Ethereum testnet Sapolia *OR* 
- Polygon testnet Polygon Amoy

## Features

- **Transparent Bidding Process**: Ensures all bidders can see the progress of the auction.
- **Automated Bid Rounds**: Each bidding round has a fixed duration and a fixed reduction amount.
- **Fair Participation**: Only active bidders can vote in each round, ensuring fairness.
- **Government Control**: Only the government can start the auction and has certain administrative controls.
- **Event Logging**: Important actions such as bid initiation, voting, elimination, and tender award are logged.

## Getting Started

### Prerequisites
- Solidity for smart contract deployment
- MetaMask for interacting with the blockchain

## System Workflow

### 1. System Initialization
- **Step 1:** Deploy the `TenderAuction` smart contract on the Ethereum blockchain.
  - **Action:** The deployer (government) deploys the contract.
  - **Result:** The deployer’s address is set as the `government`.

### 2. Bidders Setup
- **Step 2:** Initialize bidders within the constructor.
  - **Action:** Hardcoded bidder addresses (`Alice`, `Bob`, `Charlie`) are added with their names.
  - **Result:** Bidders are stored in the `bidders` mapping and their addresses in the `bidderList` array.

### 3. Auction Start
- **Step 3:** Government starts the auction.
  - **Action:** Government calls the `startAuction()` function.
  - **Result:** 
    - `currentRound` is set to 1.
    - `_initializeBidRound()` is called internally to set up the first bidding round.
    - `bidEndTime` is set to the current timestamp plus 60 seconds.
    - `BidRoundInitialized` event is emitted.

### 4. Bidding Rounds
- **Step 4:** Active bidders place their bids.
  - **Action:** Bidders call the `placeBid(bool _accept)` function.
    - If `_accept` is `true`, the bidder accepts the current bid.
    - If `_accept` is `false`, the bidder rejects the bid and is marked as inactive.
  - **Result:** 
    - `hasVoted` is set to `true` for the bidder.
    - If a bidder votes `no`, the `BidderEliminated` event is emitted.
    - `BidderVoted` event is emitted.

- **Step 5:** Check if all active bidders have voted.
  - **Action:** `_haveAllVoted()` is called internally after each bid.
  - **Result:** 
    - If all active bidders have voted, `_endBidRound()` is called.
    - If not all have voted, wait for remaining votes.

### 5. Ending Bid Round
- **Step 6:** End the current bidding round.
  - **Action:** `_endBidRound()` is called.
  - **Result:**
    - `BidRoundInitialized` event is emitted with end time.
    - `_initializeNextRound()` is called internally.

### 6. Initializing Next Round
- **Step 7:** Initialize the next bidding round.
  - **Action:** `_initializeNextRound()` is called.
  - **Result:**
    - Check if only one active bidder remains using `_countActiveBidders()`.
    - If only one active bidder remains, `_finalizeAuction()` is called.
    - If more than one active bidder remains:
      - `currentBid` is reduced by `reductionAmount`.
      - `currentRound` is incremented.
      - `_initializeBidRound()` is called to set up the next round.

### 7. Finalizing Auction
- **Step 8:** Finalize the auction when only one bidder remains.
  - **Action:** `_finalizeAuction()` is called.
  - **Result:**
    - The remaining active bidder is set as the `winner`.
    - `TenderWon` event is emitted with the winner’s address and final bid amount.

### 8. Viewing Results
- **Step 9:** View the auction results.
  - **Action:** Call the `getWinner()` function.
  - **Result:** Returns the winner’s address and the final bid amount.

- **Step 10:** View bidder details.
  - **Action:** Call the `getBidderDetails(address _bidder)` function.
  - **Result:** Returns the name, active status, and voting status of the specified bidder.

- **Step 11:** View remaining time for the current round.
  - **Action:** Call the `getTimeLeft()` function.
  - **Result:** Returns the remaining time in seconds for the current bidding round.




## Usage

1. *Deployment*: Deploy the contract on the Ethereum blockchain. The deployer becomes the government.
2. *Start Auction*: The government starts the auction using `startAuction()`.
3. *Bidding Rounds*: Active bidders place their bids using `placeBid(bool _accept)`. Each round lasts for 60 seconds.
4. *End of Auction*: The auction continues until only one active bidder remains. The contract finalizes the auction and awards the tender to the last active bidder.

## Conclusion

The TenderAuction smart contract provides a robust and transparent solution for managing government tenders, ensuring fairness and reducing corruption. By automating the bidding process and enforcing strict rules, this contract helps maintain the integrity of the tendering process.
