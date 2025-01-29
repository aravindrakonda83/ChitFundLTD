// Validate Login Form
function validateLogin() {
    var username = document.getElementById("loginUsername").value;
    var password = document.getElementById("loginPassword").value;

    if (username.trim() === "") {
        alert("Username is required.");
        return false;
    }

    if (password.trim() === "") {
        alert("Password is required.");
        return false;
    }

    return true;  // Allow form submission if no issues
}

// Validate Signup Form
function validateSignup() {
    var username = document.getElementById("signupUsername").value;
    var password = document.getElementById("signupPassword").value;
    var confirmPassword = document.getElementById("confirmPassword").value;

    if (username.trim() === "") {
        alert("Username is required.");
        return false;
    }

    if (password.trim() === "") {
        alert("Password is required.");
        return false;
    }

    if (confirmPassword.trim() === "") {
        alert("Please confirm your password.");
        return false;
    }

    if (password !== confirmPassword) {
        alert("Passwords do not match.");
        return false;
    }

    return true;  // Allow form submission if no issues
}

function validateGroup() {
    var groupName = document.getElementById("groupName").value;
    var groupAmount = document.getElementById("groupAmount").value;

    if (groupName.trim() === "") {
        alert("Group Name is required.");
        return false;
    }

    if (groupAmount.trim() === "") {
        alert("Amount is required.");
        return false;
    }

    // Optionally, validate the amount to ensure it's a positive number
    if (parseFloat(groupAmount) <= 0) {
        alert("Amount should be greater than zero.");
        return false;
    }

    return true;  // Proceed with form submission
}
