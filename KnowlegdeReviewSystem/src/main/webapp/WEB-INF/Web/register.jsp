<%--<%@ page language="java" contentType="text/html; charset=UTF-8"--%>
<%--         pageEncoding="UTF-8"%>--%>
<%--<!DOCTYPE html>--%>
<%--<html>--%>
<%--<head>--%>
<%--  <meta charset="UTF-8">--%>
<%--  <title>Register Page</title>--%>
<%--  <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.3/dist/css/bootstrap.min.css">--%>
<%--  <script src="https://accounts.google.com/gsi/client" async defer></script>--%>
<%--  <style>--%>
<%--    body {--%>
<%--      background-color: #CDC1FF; /* Light Purple */--%>
<%--    }--%>
<%--    .login-container {--%>
<%--      background-color: white;--%>
<%--      max-width: 500px;--%>
<%--      margin: 0 auto;--%>
<%--      padding: 2rem;--%>
<%--      border-radius: 8px;--%>
<%--      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);--%>
<%--    }--%>
<%--  </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="py-3 py-md-5">--%>
<%--  <div class="container">--%>
<%--    <div class="row justify-content-md-center">--%>
<%--      <div class="col-12 col-md-11 col-lg-8 col-xl-7 col-xxl-6">--%>
<%--        <div class="login-container p-4 p-md-5 rounded shadow-sm">--%>
<%--          <div class="row">--%>
<%--            <div class="col-12">--%>
<%--              <div class="mb-5 text-center">--%>
<%--                <h3>Register</h3>--%>
<%--              </div>--%>
<%--            </div>--%>
<%--          </div>--%>
<%--          <form action="#!" id="registerForm">--%>
<%--            <div class="row gy-3 gy-md-4 overflow-hidden">--%>
<%--              <div class="col-12">--%>
<%--                <label for="email" class="form-label">Email <span class="text-danger">*</span></label>--%>
<%--                <input type="email" class="form-control" name="email" id="email" placeholder="name@example.com" required>--%>
<%--                <small id="email-feedback" class="text-danger"></small>--%>
<%--              </div>--%>
<%--              <div class="col-12">--%>
<%--                <label for="fullname" class="form-label">FullName <span class="text-danger">*</span></label>--%>
<%--                <input type="text" class="form-control" name="fullname" id="fullname" placeholder="Your Fullname" required>--%>
<%--              </div>--%>
<%--              <div class="col-12">--%>
<%--                <label for="username" class="form-label">Username <span class="text-danger">*</span></label>--%>
<%--                <input type="text" class="form-control" name="username" id="username" placeholder="Your Username" required>--%>
<%--                <small id="username-feedback" class="text-danger"></small>--%>
<%--              </div>--%>
<%--              <div class="col-12">--%>
<%--                <label for="password" class="form-label">Password <span class="text-danger">*</span></label>--%>
<%--                <input type="password" class="form-control" name="password" id="password" required>--%>
<%--                <small id="password-feedback" class="text-danger"></small>--%>
<%--              </div>--%>
<%--              <div class="col-12">--%>
<%--                <label for="confirm_password" class="form-label">Confirm Password <span class="text-danger">*</span></label>--%>
<%--                <input type="password" class="form-control" name="confirm_password" id="confirm_password" required>--%>
<%--                <small id="confirm_password-feedback" class="text-danger"></small>--%>
<%--              </div>--%>
<%--              <div class="col-12">--%>
<%--                <div class="form-check">--%>
<%--                  <input class="form-check-input" type="checkbox" name="agree_terms" id="agree_terms" required>--%>
<%--                  <label class="form-check-label text-secondary" for="agree_terms">--%>
<%--                    I agree to the terms and conditions--%>
<%--                  </label>--%>
<%--                </div>--%>
<%--              </div>--%>
<%--              <div class="col-12">--%>
<%--                <div id="error-message" class="text-danger mb-3" style="display: none;"></div>--%>
<%--                <div class="d-grid">--%>
<%--                  <button class="btn btn-lg btn-primary" type="submit">Register</button>--%>
<%--                </div>--%>
<%--              </div>--%>
<%--            </div>--%>
<%--          </form>--%>
<%--          <div class="row">--%>
<%--            <div class="col-12">--%>
<%--              <hr class="mt-5 mb-4 border-secondary-subtle">--%>
<%--              <div class="d-flex gap-2 gap-md-4 flex-column flex-md-row justify-content-md-end">--%>
<%--                <a href="login" class="link-custom text-decoration-none">Already have an account? Log in</a>--%>
<%--              </div>--%>
<%--            </div>--%>
<%--          </div>--%>
<%--          <div class="row text-center">--%>
<%--            <p class="mt-5 mb-4">Or register with</p>--%>
<%--            <div id="g_id_onload"--%>
<%--                 data-client_id="591728534302-lga4hkuna8o9bmmeranainb9ireimp68.apps.googleusercontent.com"--%>
<%--                 data-callback="onSignIn">--%>
<%--            </div>--%>
<%--            <div class="g_id_signin"--%>
<%--                 data-type="standard"--%>
<%--                 data-size="large"--%>
<%--                 data-theme="outline"--%>
<%--                 data-text="sign_in_with"--%>
<%--                 data-shape="rectangular"--%>
<%--                 data-logo_alignment="left">--%>
<%--            </div>--%>
<%--          </div>--%>
<%--        </div>--%>
<%--      </div>--%>
<%--    </div>--%>
<%--  </div>--%>
<%--</div>--%>

<%--<script>--%>
<%--  function isPasswordValid(password) {--%>
<%--    const minLength = 8;--%>
<%--    const hasUpperCase = /[A-Z]/.test(password);--%>
<%--    const hasLowerCase = /[a-z]/.test(password);--%>
<%--    const hasNumbers = /\d/.test(password);--%>

<%--    // Check if password meets the requirements--%>
<%--    return password.length >= minLength && hasUpperCase && hasLowerCase && hasNumbers;--%>
<%--  }--%>

<%--  // Function to check if the email is already taken--%>
<%--  function checkEmailAvailability(email) {--%>
<%--    return fetch('/check-email', {--%>
<%--      method: 'POST',--%>
<%--      headers: {--%>
<%--        'Content-Type': 'application/json'--%>
<%--      },--%>
<%--      body: JSON.stringify({ email: email })--%>
<%--    }).then(response => response.json());--%>
<%--  }--%>

<%--  // Function to check if the username is already taken--%>
<%--  function checkUsernameAvailability(username) {--%>
<%--    return fetch('/check-username', {--%>
<%--      method: 'POST',--%>
<%--      headers: {--%>
<%--        'Content-Type': 'application/json'--%>
<%--      },--%>
<%--      body: JSON.stringify({ username: username })--%>
<%--    }).then(response => response.json());--%>
<%--  }--%>

<%--  document.addEventListener("DOMContentLoaded", function () {--%>
<%--    let usernameInput = document.getElementById("username");--%>
<%--    let feedback = document.getElementById("username-feedback");--%>
<%--    let typingTimer;--%>
<%--    let doneTypingInterval = 500; // 500ms after user stops typing--%>

<%--    usernameInput.addEventListener("keyup", function () {--%>
<%--      clearTimeout(typingTimer);--%>
<%--      typingTimer = setTimeout(checkUsername, doneTypingInterval);--%>
<%--    });--%>

<%--    usernameInput.addEventListener("keydown", function () {--%>
<%--      clearTimeout(typingTimer);--%>
<%--    });--%>

<%--    function checkUsername() {--%>
<%--      let username = usernameInput.value.trim();--%>
<%--      if (username.length < 8) {--%>
<%--        feedback.textContent = "Username must be at least 8 characters.";--%>
<%--        return;--%>
<%--      }--%>

<%--      // Send the AJAX request using fetch--%>
<%--      fetch('/check-username', {--%>
<%--        method: 'POST',--%>
<%--        headers: {--%>
<%--          'Content-Type': 'application/json'--%>
<%--        },--%>
<%--        body: JSON.stringify({username: username})--%>
<%--      })--%>
<%--              .then(response => response.json())--%>
<%--              .then(data => {--%>
<%--                if (data.exists) {--%>
<%--                  feedback.textContent = "Username is already taken.";--%>
<%--                  feedback.classList.add("text-danger");--%>
<%--                  feedback.classList.remove("text-success");--%>
<%--                } else {--%>
<%--                  feedback.textContent = "Username is available.";--%>
<%--                  feedback.classList.remove("text-danger");--%>
<%--                  feedback.classList.add("text-success");--%>
<%--                }--%>
<%--              })--%>
<%--              .catch(error => {--%>
<%--                console.error("Error:", error);--%>
<%--                feedback.textContent = "Error checking username.";--%>
<%--              });--%>
<%--    }--%>
<%--  });--%>

<%--  document.addEventListener("DOMContentLoaded", function () {--%>
<%--    let emailInput = document.getElementById("email");--%>
<%--    let feedback = document.getElementById("email-feedback");--%>
<%--    let typingTimer;--%>
<%--    let doneTypingInterval = 500; // 500ms after user stops typing--%>

<%--    emailInput.addEventListener("keyup", function () {--%>
<%--      clearTimeout(typingTimer);--%>
<%--      typingTimer = setTimeout(checkEmail, doneTypingInterval);--%>
<%--    });--%>

<%--    emailInput.addEventListener("keydown", function () {--%>
<%--      clearTimeout(typingTimer);--%>
<%--    });--%>

<%--    function checkEmail() {--%>
<%--      let email = emailInput.value.trim();--%>

<%--      // Email format validation using regex--%>
<%--      const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;--%>
<%--      if (!emailPattern.test(email)) {--%>
<%--        feedback.textContent = "Please enter a valid email address.";--%>
<%--        feedback.style.color = "red";--%>
<%--        feedback.style.display = "block";--%>
<%--        return;--%>
<%--      }--%>

<%--      // Send the AJAX request using fetch--%>
<%--      fetch('/check-email', {--%>
<%--        method: 'POST',--%>
<%--        headers: {--%>
<%--          'Content-Type': 'application/json'--%>
<%--        },--%>
<%--        body: JSON.stringify({email: email})--%>
<%--      })--%>
<%--              .then(response => response.json())--%>
<%--              .then(data => {--%>
<%--                if (data.exists) {--%>
<%--                  feedback.textContent = "This email is already exsited in the system.";--%>
<%--                  feedback.classList.remove("text-success");--%>
<%--                  feedback.classList.add("text-danger");--%>
<%--                } else {--%>
<%--                  feedback.textContent = "This email is available.";--%>
<%--                  feedback.classList.remove("text-danger");--%>
<%--                  feedback.classList.add("text-success");--%>
<%--                }--%>
<%--              })--%>
<%--              .catch(error => {--%>
<%--                console.error("Error:", error);--%>
<%--                feedback.textContent = "Error checking email.";--%>
<%--              });--%>
<%--    }--%>
<%--  });--%>

<%--  document.addEventListener("DOMContentLoaded", function () {--%>
<%--    let passwordInput = document.getElementById("password");--%>
<%--    let feedback = document.getElementById("password-feedback");--%>
<%--    let typingTimer;--%>
<%--    let doneTypingInterval = 500; // 500ms after user stops typing--%>

<%--    passwordInput.addEventListener("keyup", function () {--%>
<%--      clearTimeout(typingTimer);--%>
<%--      typingTimer = setTimeout(checkEmail, doneTypingInterval);--%>
<%--    });--%>

<%--    passwordInput.addEventListener("keydown", function () {--%>
<%--      clearTimeout(typingTimer);--%>
<%--    });--%>

<%--    function checkEmail() {--%>
<%--      let password = passwordInput.value.trim();--%>

<%--      // Validate password--%>
<%--      if (!isPasswordValid(password)) {--%>
<%--        feedback.textContent = 'Password must be at least 8 characters long and contain at least one number, one uppercase letter.';--%>
<%--      }--%>
<%--      else feedback.textContent = '';--%>
<%--    }--%>
<%--  });--%>

<%--  document.getElementById('registerForm').addEventListener('submit', function (e) {--%>
<%--    e.preventDefault();--%>

<%--    const email = document.getElementById('email').value;--%>
<%--    const username = document.getElementById('username').value;--%>
<%--    const password = document.getElementById('password').value;--%>
<%--    const confirmPassword = document.getElementById('confirm_password').value;--%>
<%--    const agreeTerms = document.getElementById('agree_terms').checked;--%>
<%--    const fullname = document.getElementById('fullname').value;--%>

<%--    // Validate password--%>
<%--    if (!isPasswordValid(password)) {--%>
<%--      document.getElementById('error-message').innerText = 'Password must be at least 8 characters long and contain at least one number, one uppercase letter.';--%>
<%--      document.getElementById('error-message').style.display = 'block';--%>
<%--      return;--%>
<%--    }--%>

<%--    // Validate password match--%>
<%--    if (password !== confirmPassword) {--%>
<%--      document.getElementById('error-message').innerText = 'Passwords do not match.';--%>
<%--      document.getElementById('error-message').style.display = 'block';--%>
<%--      return;--%>
<%--    }--%>

<%--    // Validate terms agreement--%>
<%--    if (!agreeTerms) {--%>
<%--      document.getElementById('error-message').innerText = 'You must agree to the terms and conditions.';--%>
<%--      document.getElementById('error-message').style.display = 'block';--%>
<%--      return;--%>
<%--    }--%>

<%--    // Check email availability--%>
<%--    checkEmailAvailability(email).then(emailData => {--%>
<%--      if (!emailData.available) {--%>
<%--        document.getElementById('error-message').innerText = 'Email is already in use.';--%>
<%--        document.getElementById('error-message').style.display = 'block';--%>
<%--        return;--%>
<%--      }--%>
<%--    })--%>

<%--      // Check username availability--%>
<%--      checkUsernameAvailability(username).then(usernameData => {--%>
<%--        if (!usernameData.available) {--%>
<%--          document.getElementById('error-message').innerText = 'Username is already in use.';--%>
<%--          document.getElementById('error-message').style.display = 'block';--%>
<%--          return;--%>
<%--        }--%>
<%--      })--%>


<%--        // Create the request payload--%>
<%--    const requestData = {--%>
<%--      email: email,--%>
<%--      fullname: fullname,--%>
<%--      username: username,--%>
<%--      password: password--%>
<%--    };--%>

<%--    console.log(JSON.stringify(requestData))--%>

<%--    // Send the AJAX request using fetch--%>
<%--    fetch('/register', {--%>
<%--      method: 'POST',--%>
<%--      headers: {--%>
<%--        'Content-Type': 'application/json'--%>
<%--      },--%>
<%--      body: JSON.stringify(requestData),--%>
<%--      action: "register"--%>
<%--    })--%>
<%--            .then(response => response.json())--%>
<%--            .then(data => {--%>
<%--              if (data.success) {--%>
<%--                window.location.href = '/login'; // Redirect to login page after successful registration--%>
<%--              } else {--%>
<%--                document.getElementById('error-message').innerText = data.error || 'Registration failed.';--%>
<%--                document.getElementById('error-message').style.display = 'block';--%>
<%--              }--%>
<%--            })--%>
<%--            .catch(error => {--%>
<%--              console.error('Error during registration:', error);--%>
<%--              document.getElementById('error-message').innerText = 'There was an error with the registration process.';--%>
<%--              document.getElementById('error-message').style.display = 'block';--%>
<%--            });--%>
<%--  });--%>

<%--  function onSignIn(googleUser) {--%>
<%--    // Get the ID token from the Google user object--%>
<%--    var id_token = googleUser.credential;--%>

<%--    // Send the ID token to your backend for verification--%>
<%--    fetch('/login', {--%>
<%--      method: 'POST',--%>
<%--      headers: {--%>
<%--        'Content-Type': 'application/json'--%>
<%--      },--%>
<%--      body: JSON.stringify({--%>
<%--        id_token: id_token,--%>
<%--        action: "google-login"--%>
<%--      }),--%>
<%--    })--%>

<%--            .then(response => response.json())--%>
<%--            .then(data => {--%>
<%--              if (data.success) {--%>
<%--                window.location.href = data.redirectUrl; // Redirect to dashboard--%>
<%--              } else {--%>
<%--                alert('Google login failed');--%>
<%--              }--%>
<%--            })--%>
<%--            .catch(error => {--%>
<%--              console.error('Google login error:', error);--%>
<%--              alert('There was an error with Google login');--%>
<%--            });--%>
<%--  }--%>
<%--</script>--%>

<%--</body>--%>
<%--</html>--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Register Page</title>
  <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://accounts.google.com/gsi/client" async defer></script>
  <style>
    body {
      background-color: #CDC1FF;
    }
    .login-container {
      background-color: white;
      max-width: 500px;
      margin: 0 auto;
      padding: 2rem;
      border-radius: 8px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
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
    .message {
      margin-top: 10px;
    }
  </style>
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
                <h3>Register</h3>
              </div>
            </div>
          </div>
          <form action="#!" id="registerForm">
            <div class="row gy-3 gy-md-4 overflow-hidden">
              <div class="col-12">
                <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                <input type="email" class="form-control" name="email" id="email" placeholder="name@example.com" required>
                <div id="emailMessage" class="message"></div>
              </div>
              <div class="col-12">
                <label for="fullname" class="form-label">Full Name <span class="text-danger">*</span></label>
                <input type="text" class="form-control" name="fullname" id="fullname" placeholder="Your Fullname" required>
                <div id="fullnameMessage" class="message"></div>
              </div>
              <div class="col-12">
                <label for="username" class="form-label">Username <span class="text-danger">*</span></label>
                <input type="text" class="form-control" name="username" id="username" placeholder="Your Username" required>
                <div id="usernameMessage" class="message"></div>
              </div>
              <div class="col-12">
                <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                <input type="password" class="form-control" name="password" id="password" required>
                <div id="passwordMessage" class="message"></div>
              </div>
              <div class="col-12">
                <label for="confirm_password" class="form-label">Confirm Password <span class="text-danger">*</span></label>
                <input type="password" class="form-control" name="confirm_password" id="confirm_password" required>
                <div id="confirmPasswordMessage" class="message"></div>
              </div>
              <div class="col-12">
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" name="agree_terms" id="agree_terms" required>
                  <label class="form-check-label text-secondary" for="agree_terms">
                    I agree to the terms and conditions
                  </label>
                </div>
              </div>
              <div class="col-12">
                <div class="d-grid">
                  <button class="btn btn-lg btn-primary" type="submit" id="registerBtn" disabled>Register</button>
                </div>
              </div>
            </div>
          </form>
          <div class="row">
            <div class="col-12">
              <hr class="mt-5 mb-4 border-secondary-subtle">
              <div class="d-flex gap-2 gap-md-4 flex-column flex-md-row justify-content-md-end">
                <a href="login" class="link-custom text-decoration-none">Already have an account? Log in</a>
              </div>
            </div>
          </div>
          <div class="row text-center">
            <p class="mt-5 mb-4">Or register with</p>
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
  let isEmailValid = false;
  let isUsernameValid = false;
  let isPasswordValidFlag = false;
  let isFullnameValid = false;

  function isPasswordValid(password) {
    const minLength = 8;
    const maxLength = 32;
    const hasUpperCase = /[A-Z]/.test(password);
    const hasNumber = /\d/.test(password);
    return password.length >= minLength && password.length <= maxLength && hasUpperCase && hasNumber;
  }

  function isFullnameValidFunc(fullname) {
    const minLength = 2;
    const maxLength = 255;
    return fullname.trim().length >= minLength && fullname.trim().length <= maxLength;
  }

  function isUsernameValidFunc(username) {
    const minLength = 8;
    const maxLength = 32;
    return username.trim().length >= minLength && username.trim().length <= maxLength;
  }

  $("#email").on('input', function() {
    const email = $(this).val();
    const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

    if (!emailPattern.test(email)) {
      $("#emailMessage").html('<div class="alert alert-warning">Please enter a valid email address</div>');
      isEmailValid = false;
    } else {
      $.ajax({
        url: '/check-email',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ email: email }),
        success: function(response) {
          if (response.exists) {
            $("#emailMessage").html('<div class="alert alert-warning">This email is already in use</div>');
            isEmailValid = false;
          } else {
            $("#emailMessage").html('');
            isEmailValid = true;
          }
          checkFormValidity();
        },
        error: function(xhr) {
          $("#emailMessage").html('<div class="alert alert-danger">Error checking email: ' + xhr.responseText + '</div>');
          isEmailValid = false;
          checkFormValidity();
        }
      });
    }
    checkFormValidity();
  });

  $("#fullname").on('input', function() {
    const fullname = $(this).val();
    if (!isFullnameValidFunc(fullname)) {
      $("#fullnameMessage").html('<div class="alert alert-warning">Full name must be 2-255 characters</div>');
      isFullnameValid = false;
    } else {
      $("#fullnameMessage").html('');
      isFullnameValid = true;
    }
    checkFormValidity();
  });

  $("#username").on('input', function() {
    const username = $(this).val();
    if (!isUsernameValidFunc(username)) {
      $("#usernameMessage").html('<div class="alert alert-warning">Username must be 8-32 characters</div>');
      isUsernameValid = false;
    } else {
      $.ajax({
        url: '/check-username',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ username: username }),
        success: function(response) {
          if (response.exists) {
            $("#usernameMessage").html('<div class="alert alert-warning">Username is already taken</div>');
            isUsernameValid = false;
          } else {
            $("#usernameMessage").html('');
            isUsernameValid = true;
          }
          checkFormValidity();
        },
        error: function(xhr) {
          $("#usernameMessage").html('<div class="alert alert-danger">Error checking username: ' + xhr.responseText + '</div>');
          isUsernameValid = false;
          checkFormValidity();
        }
      });
    }
    checkFormValidity();
  });

  $("#password").on('input', function() {
    const password = $(this).val();
    if (password.length > 0 && !isPasswordValid(password)) {
      $("#passwordMessage").html('<div class="alert alert-warning">Password must be 8-32 characters long and contain at least one uppercase letter and one number</div>');
      isPasswordValidFlag = false;
    } else {
      $("#passwordMessage").html('');
      isPasswordValidFlag = true;
    }
    checkFormValidity();
  });

  $("#confirm_password").on('input', function() {
    const password = $("#password").val();
    const confirmPassword = $(this).val();
    if (confirmPassword.length > 0 && password !== confirmPassword) {
      $("#confirmPasswordMessage").html('<div class="alert alert-warning">Passwords do not match</div>');
    } else {
      $("#confirmPasswordMessage").html('');
    }
    checkFormValidity();
  });

  function checkFormValidity() {
    const email = $("#email").val();
    const fullname = $("#fullname").val();
    const username = $("#username").val();
    const password = $("#password").val();
    const confirmPassword = $("#confirm_password").val();
    const agreeTerms = $("#agree_terms").is(':checked');

    if (isEmailValid && isFullnameValid && isUsernameValid && isPasswordValidFlag &&
            password === confirmPassword && agreeTerms && email && fullname && username) {
      $("#registerBtn").prop('disabled', false);
    } else {
      $("#registerBtn").prop('disabled', true);
    }
  }

  $("#agree_terms").on('change', checkFormValidity);

  $("#registerForm").submit(function(e) {
    e.preventDefault();

    const email = $("#email").val();
    const fullname = $("#fullname").val();
    const username = $("#username").val();
    const password = $("#password").val();
    const confirmPassword = $("#confirm_password").val();

    if (!isPasswordValid(password)) {
      $("#passwordMessage").html('<div class="alert alert-danger">Password must be 8-32 characters long and contain at least one uppercase letter and one number</div>');
      return;
    }

    if (password !== confirmPassword) {
      $("#confirmPasswordMessage").html('<div class="alert alert-danger">Passwords do not match!</div>');
      return;
    }

    $.ajax({
      url: '/register',
      type: 'POST',
      contentType: 'application/json', // Updated to match backend expectation
      data: JSON.stringify({
        email: email,
        fullname: fullname,
        username: username,
        password: password
      }),
      success: function(response) {
        if (response.success) {
          $("#registerForm").before('<div class="alert alert-success">Registration successful! Redirecting to login...</div>');
          setTimeout(() => window.location.href = '/login', 2000);
        } else {
          $("#registerForm").before('<div class="alert alert-danger">Registration failed: ' + (response.error || 'Unknown error') + '</div>');
          setTimeout(() => $(".alert").remove(), 3000);
        }
      },
      error: function(xhr) {
        $("#registerForm").before('<div class="alert alert-danger">Error during registration: ' + xhr.responseText + '</div>');
        setTimeout(() => $(".alert").remove(), 3000);
      }
    });
  });

  function onSignIn(googleUser) {
    var id_token = googleUser.credential;
    $.ajax({
      url: '/login',
      type: 'POST',
      contentType: 'application/json', // Updated to match backend expectation
      data: JSON.stringify({ id_token: id_token, action: "google-login" }),
      success: function(data) {
        if (data.success) {
          window.location.href = data.redirectUrl;
        } else {
          alert('Google login failed');
        }
      },
      error: function(error) {
        console.error('Google login error:', error);
        alert('There was an error with Google login');
      }
    });
  }
</script>
</body>
</html>