<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
    <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <style>
        body {
            background-color: #CDC1FF; /* Light Purple */
        }
        .login-container {
            background-color: white;
            max-width: 500px;
            margin: 0 auto;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
    </style>

<%--    <script>--%>
<%--        fetch("/config")--%>
<%--            .then(response => response.json())--%>
<%--            .then(data => {--%>
<%--                document.getElementById("g_id_onload").setAttribute("data-client_id", data.googleClientId);--%>
<%--                console.log(data.googleClientId);--%>
<%--            })--%>
<%--            .catch(error => console.error("Error loading Google Client ID:", error));--%>
<%--    </script>--%>
</head>
<body>
<div class="py-3 py-md-5">
    <div class="container">
        <div class="row justify-content-md-center">
            <div class="col-12 col-md-11 col-lg-8 col-xl-7 col-xxl-6">
                <div class="login-container p-4 p-md-5 rounded shadow-sm">
                    <div class="row">
                        <div class="col-12">
                            <div class="mb-5 text-center">
                                <h3>Log in</h3>
                            </div>
                        </div>
                    </div>
                    <form action="#!" id="loginForm">
                        <div class="row gy-3 gy-md-4 overflow-hidden">
                            <div class="col-12">
                                <label for="usernameOrEmail" class="form-label">Username or Email <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="usernameOrEmail" id="usernameOrEmail" placeholder="Enter your username or email" required>
                            </div>
                            <div class="col-12">
                                <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" name="password" id="password" required>
                            </div>
                            <div class="col-12">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="remember_me" id="remember_me">
                                    <label class="form-check-label text-secondary" for="remember_me">
                                        Keep me logged in
                                    </label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div id="error-message" class="text-danger mb-3" style="display: none;"></div>
                                <div class="d-grid">
                                    <button class="btn btn-lg btn-primary" type="submit">Log in now</button>
                                </div>
                            </div>
                        </div>
                    </form>
                    <div class="row">
                        <div class="col-12">
                            <hr class="mt-5 mb-4 border-secondary-subtle">
                            <div class="d-flex gap-2 gap-md-4 flex-column flex-md-row justify-content-md-end">
                                <a href="register" class="link-custom text-decoration-none">Create new account</a>
                                <a href="forgot-password" class="link-custom text-decoration-none">Forgot password</a>
                            </div>
                        </div>
                    </div>
                    <div class="row text-center">
                        <p class="mt-5 mb-4">Or sign in with</p>
                        <div id="g_id_onload"
                             data-client_id="591728534302-lga4hkuna8o9bmmeranainb9ireimp68.apps.googleusercontent.com"
                             data-callback="onSignIn">
                        </div>
                        <div class="g_id_signin"
                             data-type="standard"
                             data-size="large"
                             data-theme="outline"
                             data-text="sign_in_with"
                             data-shape="rectangular"
                             data-logo_alignment="left">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('loginForm').addEventListener('submit', function (e) {
        e.preventDefault();

        const usernameOrEmail = document.getElementById('usernameOrEmail').value;
        const password = document.getElementById('password').value;
        const rememberMe = document.getElementById('remember_me').checked;

        const requestData = {
            usernameOrEmail: usernameOrEmail,
            password: password,
            remember_me: rememberMe,
            action: "login"
        };

        fetch('/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(requestData)
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                        window.location.href = data.redirectUrl;
                } else {
                    document.getElementById('error-message').innerText = 'Invalid login credentials';
                    document.getElementById('error-message').style.display = 'block';
                }
            })
            .catch(error => {
                console.error('Error during login:', error);
                document.getElementById('error-message').innerText = 'There was an error with the login process';
                document.getElementById('error-message').style.display = 'block';
            });
    });

    function onSignIn(googleUser) {
        // Get the ID token from the Google user object
        var id_token = googleUser.credential;

        // Send the ID token to your backend for verification
        fetch('/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                id_token: id_token,
                action: "google-login"
            }),
        })

            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    window.location.href = data.redirectUrl; // Redirect to dashboard
                } else {
                    alert('Google login failed');
                }
            })
            .catch(error => {
                console.error('Google login error:', error);
                alert('There was an error with Google login');
            });
    }
</script>

</body>
</html>