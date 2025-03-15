<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Email Verification</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #CDC1FF;
        }
        .verification-container {
            background-color: white;
            max-width: 400px;
            margin: 50px auto;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .message {
            margin-top: 20px;
            display: none;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="verification-container">
        <h2 class="text-center mb-4">Verify Your Account</h2>
        <p class="text-center">A 6-digit verification code has been sent to your email. Please enter it below.</p>

        <form id="verificationForm">
            <!-- Input for the verification code -->
            <div class="mb-3">
                <label for="verificationCode" class="form-label">Enter 6-Digit Code</label>
                <input type="text" class="form-control" id="verificationCode" name="verificationCode" required maxlength="6" pattern="\d{6}" title="Please enter a 6-digit code">
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary w-100">Verify Code</button>
        </form>

        <!-- Resend Button -->
        <button id="resendCodeBtn" class="btn btn-secondary w-100 mt-3">Resend Code</button>

        <!-- Message area -->
        <div id="message" class="message text-center text-danger"></div>
    </div>
</div>

<!-- JavaScript for AJAX handling -->
<script>
    document.getElementById('verificationForm').addEventListener('submit', function (e) {
        e.preventDefault();

        const verificationCode = document.getElementById('verificationCode').value;
        const messageDiv = document.getElementById('message');

        fetch('/verifyCode', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ verificationCode: verificationCode })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    messageDiv.classList.remove('text-danger');
                    messageDiv.classList.add('text-success');
                    messageDiv.innerText = 'Verification successful! Redirecting...';
                    messageDiv.style.display = 'block';
                    setTimeout(() => { window.location.href = data.redirectUrl;}, 2000);
                } else {
                    messageDiv.classList.remove('text-success');
                    messageDiv.classList.add('text-danger');
                    messageDiv.innerText = 'Invalid code. Please try again.';
                    messageDiv.style.display = 'block';
                }
            })
            .catch(error => {
                console.error('Error during verification:', error);
                messageDiv.classList.add('text-danger');
                messageDiv.innerText = 'There was an error processing your request.';
                messageDiv.style.display = 'block';
            });
    });

    // Resend Verification Code
    document.getElementById('resendCodeBtn').addEventListener('click', function () {
        const messageDiv = document.getElementById('message');

        fetch('/resendCode', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    messageDiv.classList.remove('text-danger');
                    messageDiv.classList.add('text-success');
                    messageDiv.innerText = 'A new code has been sent to your email.';
                    messageDiv.style.display = 'block';
                } else {
                    messageDiv.classList.remove('text-success');
                    messageDiv.classList.add('text-danger');
                    messageDiv.innerText = 'Error sending code. Please try again later.';
                    messageDiv.style.display = 'block';
                }
            })
            .catch(error => {
                console.error('Error resending code:', error);
                messageDiv.classList.add('text-danger');
                messageDiv.innerText = 'There was an error processing your request.';
                messageDiv.style.display = 'block';
            });
    });
</script>

<!-- Bootstrap JS (Optional) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
