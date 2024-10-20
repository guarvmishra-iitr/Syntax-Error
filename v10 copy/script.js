// Simple script to handle form submissions and button actions

// Function to handle login
// const Web3 = require('web3');
// const web3 = new Web3(windows.ethereum);

// const contractABI = [/* ABI array from the compiled contract */];
// const contractAddress = '0xYourContractAddressHere';

// // Create a contract instance
// const myContract = new web3.eth.Contract(contractABI, contractAddress);

// async function getValue() {
//     const result = await myContract.methods.getBidders().call();
//     document.getElementById("bidders.html").innerHTML = result;
//   }
//   getValue();
  
let contract_address="0x50c46Ca1fd3A065E638B0878b02BCcc4B533b62d"


function handleLogin(event) {
    event.preventDefault();
    const username = document.querySelector('.login-container input[type="text"]').value;
    const password = document.querySelector('.login-container input[type="password"]').value;

    // Simple validation (you can expand this with actual authentication logic)
    if (username && password) {
        alert(`Welcome, ${username}!`);
        // Here you can redirect to a dashboard or another page if needed
        window.location.href = 'index.html'; // Change this to your dashboard
    } else {
        alert('Please fill in both fields.');
    }
}
document.getElementById("loginForm").addEventListener("submit", function(event) {
    event.preventDefault(); // Prevent the default form submission

    // Get the username and password values from the form
    const username = document.querySelector("input[type='text']").value;
    const password = document.querySelector("input[type='password']").value;

    // Check if the username is "government" and the password is "12345"
    if (username === "government" && password === "12345") {
        // Redirect to the government's portal page
        window.location.href = "government.html";

    }
    else if (username === "bidder1" || username === "bidder2" || username === "bidder3" || username === "bidder4" || username === "bidder5" && password === "12345") {
        // Redirect to the government's portal page
        window.location.href = "bidders.html";
    } else {
        // Show an error message or handle invalid credentials
        alert("Invalid username or password. Please try again.");
    }
});



function startBidding(event) {
    // Prevent the default form submission if inside a form
    if (event) {
        event.preventDefault();
    }
    // Open the "Bidding in Progress" page in a new tab
    window.open('biddinginprogress.html');
}


// Function to handle registration
function handleRegister(event) {
    event.preventDefault();
    const username = document.querySelector('.form-container input[type="text"]').value;
    const email = document.querySelector('.form-container input[type="email"]').value;
    const password = document.querySelector('.form-container input[type="password"]').value;

    // Simple validation
    if (username && email && password) {
        alert(`Registered successfully! Welcome, ${username}!`);
        // Here you can redirect to the login page or another page
        window.location.href = 'index.html'; // Change this to your preferred page
    } else {
        alert('Please fill in all fields.');
    }
}
function startTender() {
    // Get the values from the form fields
    const tenderAmount = parseFloat(document.getElementById("tenderAmount").value);
    const tenderReduction = parseFloat(document.getElementById("tenderReduction").value);
    const tenderMessage = document.getElementById("tenderMessage");
    const progressContainer = document.getElementById("progressContainer");


    // Validate input values
    if (isNaN(tenderAmount) || isNaN(tenderReduction) || tenderAmount <= 0 || tenderReduction < 0) {
        tenderMessage.textContent = "Please enter valid amounts for both fields.";
        tenderMessage.style.color = "red";
        return;
    }

    // Calculate the final tender amount after reduction
    const finalAmount = tenderAmount - tenderReduction;

    // Display a message with the final tender amount
    if(finalAmount>0){
    tenderMessage.textContent = `The tender has been started. Final Tender Amount: ₹${tenderAmount}`;
    tenderMessage.style.color = "green";}
    else{
        tenderMessage.textContent = "Reduction amount cannot be greater than tender amount.";
        tenderMessage.style.color = "red";
    }

    // Show the progress container with the progress circle
    progressContainer.style.display = "block";

    // Simulate the bidding progress for a few seconds
    setTimeout(() => {
        tenderMessage.textContent = "Bidding has completed successfully!";
        tenderMessage.style.color = "green";
        progressContainer.style.display = "none"; // Hide the progress container after completion
    }, 50000); // Simulates a 5-second bidding process
}

// Function to handle feedback submission
function handleFeedback(event) {
    event.preventDefault();
    const feedback = document.querySelector('.feedback-container textarea').value;

    if (feedback) {
        alert('Thank you for your feedback!');
        // Here you can handle feedback submission to a server or database
    } else {
        alert('Please enter your feedback before submitting.');
    }
}

// Function to go back on notifications
function goBack() {
    window.history.back();
}

// Add event listeners to buttons in relevant pages
document.addEventListener('DOMContentLoaded', function() {
    const loginButton = document.querySelector('.login-container button');
    const registerButton = document.querySelector('.form-container button');
    const feedbackButton = document.querySelector('.feedback-container button');

    if (loginButton) {
        loginButton.addEventListener('click', handleLogin);
    }

    if (registerButton) {
        registerButton.addEventListener('click', handleRegister);
    }

    if (feedbackButton) {
        feedbackButton.addEventListener('click', handleFeedback);
    }

});
