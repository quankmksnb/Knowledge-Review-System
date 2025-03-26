<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="en">--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1.0">--%>
<%--    <title>Reset Password</title>--%>
<%--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">--%>
<%--    <style>--%>
<%--        body {--%>
<%--            background-color: #CDC1FF;--%>
<%--        }--%>
<%--        .container {--%>
<%--            max-width: 400px;--%>
<%--            margin: 50px auto;--%>
<%--            padding: 2rem;--%>
<%--            background-color: white;--%>
<%--            border-radius: 8px;--%>
<%--            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);--%>
<%--        }--%>
<%--        .message {--%>
<%--            display: none;--%>
<%--            margin-top: 10px;--%>
<%--        }--%>
<%--        input:invalid {--%>
<%--            border: 2px solid red;--%>
<%--        }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="container">--%>
<%--    <h2 class="text-center">Reset Password</h2>--%>
<%--    <p class="text-center">Enter your new password.</p>--%>
<%--    <form id="resetPasswordForm">--%>
<%--        <div class="mb-3">--%>
<%--            <label for="password" class="form-label">New Password</label>--%>
<%--            <input type="password" class="form-control" id="password" name="password" onchange="isValidPassword()" required>--%>
<%--        </div>--%>
<%--        <div class="mb-3">--%>
<%--            <label for="confirmPassword" class="form-label">Confirm Password</label>--%>
<%--            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>--%>
<%--        </div>--%>
<%--        <button type="submit" class="btn btn-primary w-100">Reset Password</button>--%>
<%--    </form>--%>
<%--    <div id="message" class="message text-center"></div>--%>
<%--</div>--%>

<%--<script>--%>
<%--    document.getElementById('resetPasswordForm').addEventListener('submit', function (e) {--%>
<%--        e.preventDefault();--%>

<%--        const password = document.getElementById('password').value;--%>
<%--        const confirmPassword = document.getElementById('confirmPassword').value;--%>
<%--        const messageDiv = document.getElementById('message');--%>
<%--        const passwordInput = document.getElementById('password');--%>
<%--        const confirmPasswordInput = document.getElementById('confirmPassword');--%>

<%--        // Reset any previous styling--%>
<%--        passwordInput.style.borderColor = '';--%>
<%--        confirmPasswordInput.style.borderColor = '';--%>
<%--        messageDiv.style.display = 'none'; // Hide the message initially--%>

<%--        // Password validation--%>
<%--        if (!isValidPassword(password)) {--%>
<%--            messageDiv.style.display = 'block';--%>
<%--            messageDiv.classList.add('text-danger');--%>
<%--            messageDiv.innerText = 'Password must be at least 8 characters long and contain at least one number, one uppercase letter.';--%>

<%--            // Add red border to password input--%>
<%--            passwordInput.style.borderColor = 'red';--%>
<%--            return;--%>
<%--        }--%>

<%--        if (password !== confirmPassword) {--%>
<%--            messageDiv.style.display = 'block';--%>
<%--            messageDiv.classList.add('text-danger');--%>
<%--            messageDiv.innerText = 'Passwords do not match.';--%>

<%--            // Add red border to both inputs--%>
<%--            passwordInput.style.borderColor = 'red';--%>
<%--            confirmPasswordInput.style.borderColor = 'red';--%>
<%--            return;--%>
<%--        }--%>

<%--        fetch('/reset-password', {--%>
<%--            method: 'POST',--%>
<%--            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },--%>
<%--            body: new URLSearchParams({ password: password })--%>
<%--        })--%>
<%--            .then(response => response.json())--%>
<%--            .then(data => {--%>
<%--                messageDiv.style.display = 'block';--%>
<%--                if (data.success) {--%>
<%--                    messageDiv.classList.remove('text-danger');--%>
<%--                    messageDiv.classList.add('text-success');--%>
<%--                    messageDiv.innerText = 'Password reset successful! Redirecting to login...';--%>
<%--                    setTimeout(() => {--%>
<%--                        window.location.href = '/login';--%>
<%--                    }, 2000);--%>
<%--                } else {--%>
<%--                    messageDiv.classList.remove('text-success');--%>
<%--                    messageDiv.classList.add('text-danger');--%>
<%--                    messageDiv.innerText = 'Error resetting password. Please try again.';--%>
<%--                }--%>
<%--            })--%>
<%--            .catch(error => {--%>
<%--                console.error('Error:', error);--%>
<%--                messageDiv.style.display = 'block';--%>
<%--                messageDiv.classList.add('text-danger');--%>
<%--                messageDiv.innerText = 'An error occurred. Please try again later.';--%>
<%--            });--%>
<%--    });--%>

<%--    function isValidPassword(password) {--%>
<%--        const minLength = 8;--%>
<%--        const hasUpperCase = /[A-Z]/.test(password);--%>
<%--        const hasLowerCase = /[a-z]/.test(password);--%>
<%--        const hasNumbers = /\d/.test(password);--%>

<%--        // Check if password meets the requirements--%>
<%--        return password.length >= minLength && hasUpperCase && hasLowerCase && hasNumbers;--%>
<%--    }--%>

<%--</script>--%>

<%--<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>--%>
<%--</body>--%>
<%--</html>--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            background-color: #CDC1FF;
        }
        .container {
            max-width: 400px;
            margin: 50px auto;
            padding: 2rem;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .message {
            margin-top: 10px;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 10px rgba(102, 126, 234, 0.2);
        }
        .btn-primary {
            background: #667eea;
            border: none;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background: #764ba2;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
<div class="container">
    <h2 class="text-center">Reset Password</h2>
    <p class="text-center">Enter your new password.</p>
    <form id="resetPasswordForm">
        <div class="mb-3">
            <label for="password" class="form-label">New Password</label>
            <input type="password" class="form-control" id="password" name="password" required>
            <div id="newPasswordMessage" class="message"></div>
        </div>
        <div class="mb-3">
            <label for="confirmPassword" class="form-label">Confirm Password</label>
            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
            <div id="confirmPasswordMessage" class="message"></div>
        </div>
        <button type="submit" class="btn btn-primary w-100" id="resetPasswordBtn" disabled>Reset Password</button>
    </form>
    <div id="successMessage" class="message text-center"></div>
</div>

<script>
    let isPasswordValidFlag = false;

    function isPasswordValid(password) {
        const minLength = 8;
        const maxLength = 32;
        const hasUpperCase = /[A-Z]/.test(password);
        const hasNumber = /\d/.test(password);
        const lengthValid = password.length >= minLength && password.length <= maxLength;
        return lengthValid && hasUpperCase && hasNumber;
    }

    // Real-time password validation feedback
    $("#password").on('input', function() {
        const password = $(this).val();
        if (password.length > 0 && !isPasswordValid(password)) {
            $("#newPasswordMessage").html('<div class="alert alert-warning">Password must be 8-32 characters long and contain at least one uppercase letter and one number</div>');
            isPasswordValidFlag = false;
            $("#resetPasswordBtn").prop('disabled', true);
        } else {
            $("#newPasswordMessage").html('');
            isPasswordValidFlag = true;
            checkFormValidity();
        }
    });

    // Real-time confirm password matching
    $("#confirmPassword").on('input', function() {
        const password = $("#password").val();
        const confirmPassword = $(this).val();
        if (confirmPassword.length > 0 && password !== confirmPassword) {
            $("#confirmPasswordMessage").html('<div class="alert alert-warning">Passwords do not match</div>');
            $("#resetPasswordBtn").prop('disabled', true);
        } else {
            $("#confirmPasswordMessage").html('');
            checkFormValidity();
        }
    });

    // Enable/disable submit button based on form validity
    function checkFormValidity() {
        const password = $("#password").val();
        const confirmPassword = $("#confirmPassword").val();
        if (isPasswordValidFlag && password === confirmPassword && password.length > 0) {
            $("#resetPasswordBtn").prop('disabled', false);
        } else {
            $("#resetPasswordBtn").prop('disabled', true);
        }
    }

    $("#resetPasswordForm").submit(function(e) {
        e.preventDefault();

        const password = $("#password").val();
        const confirmPassword = $("#confirmPassword").val();
        const successMessageDiv = $("#successMessage");

        // Clear previous messages
        successMessageDiv.html('');

        if (!isPasswordValid(password)) {
            $("#newPasswordMessage").html('<div class="alert alert-danger">Password must be 8-32 characters long and contain at least one uppercase letter and one number</div>');
            return;
        }

        if (password !== confirmPassword) {
            $("#confirmPasswordMessage").html('<div class="alert alert-danger">Passwords do not match!</div>');
            return;
        }

        $.ajax({
            url: '/reset-password',
            type: 'POST',
            data: { password: password },
            success: function(response) {
                successMessageDiv.html('<div class="alert alert-success">Password reset successful! Redirecting to login...</div>');
                $("#resetPasswordForm")[0].reset();
                $("#resetPasswordBtn").prop('disabled', true);
                setTimeout(() => {
                    window.location.href = '/login';
                }, 2000);
            },
            error: function(xhr, status, error) {
                successMessageDiv.html('<div class="alert alert-danger">Error resetting password: ' + xhr.responseText + '</div>');
                setTimeout(() => successMessageDiv.html(''), 3000);
            }
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>