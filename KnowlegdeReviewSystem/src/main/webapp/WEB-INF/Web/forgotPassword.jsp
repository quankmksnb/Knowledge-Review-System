<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
            display: none;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2 class="text-center">Forgot Password</h2>
    <p class="text-center">Enter your email to receive a reset code.</p>
    <form id="forgotPasswordForm">
        <div class="mb-3">
            <label for="email" class="form-label">Email Address</label>
            <input type="email" class="form-control" id="email" name="email" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">Send Reset Code</button>
    </form>
    <div id="message" class="message text-center"></div>
</div>

<script>
    document.getElementById('forgotPasswordForm').addEventListener('submit', function (e) {
        e.preventDefault();
        const email = document.getElementById('email').value;
        const messageDiv = document.getElementById('message');

        fetch('/sendResetCode', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({ email: email })
        })
            .then(response => response.json())
            .then(data => {
                messageDiv.style.display = 'block';
                if (data.success) {
                    messageDiv.classList.add('text-success');
                    messageDiv.innerText = 'Reset code sent. Check your email!';
                    window.location.href = '/forgot-password-verify-code';
                } else {
                    messageDiv.classList.add('text-danger');
                    messageDiv.innerText = 'Email not found. Please try again.';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                messageDiv.style.display = 'block';
                messageDiv.classList.add('text-danger');
                messageDiv.innerText = 'An error occurred. Please try again later.';
            });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>