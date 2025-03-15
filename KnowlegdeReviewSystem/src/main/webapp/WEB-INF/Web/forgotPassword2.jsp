<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Code</title>
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
    <h2 class="text-center">Verify Code</h2>
    <p class="text-center">Enter the verification code sent to your email.</p>
    <form id="verifyCodeForm">
        <div class="mb-3">
            <label for="code" class="form-label">Verification Code</label>
            <input type="text" class="form-control" id="code" name="code" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">Verify Code</button>
    </form>
    <div id="message" class="message text-center"></div>
</div>

<script>
    document.getElementById('verifyCodeForm').addEventListener('submit', function (e) {
        e.preventDefault();
        const code = document.getElementById('code').value;
        const messageDiv = document.getElementById('message');

        fetch('/verifyResetCode', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ code: code })
        })
            .then(response => response.json())
            .then(data => {
                messageDiv.style.display = 'block';
                if (data.success) {
                    messageDiv.classList.remove('text-danger');
                    messageDiv.classList.add('text-success');
                    messageDiv.innerText = 'Verification successful! Redirecting to reset password...';
                    setTimeout(() => {
                        window.location.href = '/reset-password';
                    }, 2000);
                } else {
                    messageDiv.classList.remove('text-success');
                    messageDiv.classList.add('text-danger');
                    messageDiv.innerText = 'Invalid or expired code. Please try again.';
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
