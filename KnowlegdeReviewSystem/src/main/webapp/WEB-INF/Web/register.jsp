<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Register Page</title>
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
                <small id="email-feedback" class="text-danger"></small>
              </div>
              <div class="col-12">
                <label for="fullname" class="form-label">FullName <span class="text-danger">*</span></label>
                <input type="text" class="form-control" name="fullname" id="fullname" placeholder="Your Fullname" required>
              </div>
              <div class="col-12">
                <label for="username" class="form-label">Username <span class="text-danger">*</span></label>
                <input type="text" class="form-control" name="username" id="username" placeholder="Your Username" required>
                <small id="username-feedback" class="text-danger"></small>
              </div>
              <div class="col-12">
                <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                <input type="password" class="form-control" name="password" id="password" required>
                <small id="password-feedback" class="text-danger"></small>
              </div>
              <div class="col-12">
                <label for="confirm_password" class="form-label">Confirm Password <span class="text-danger">*</span></label>
                <input type="password" class="form-control" name="confirm_password" id="confirm_password" required>
                <small id="confirm_password-feedback" class="text-danger"></small>
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
                <div id="error-message" class="text-danger mb-3" style="display: none;"></div>
                <div class="d-grid">
                  <button class="btn btn-lg btn-primary" type="submit">Register</button>
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
  function isPasswordValid(password) {
    const minLength = 8;
    const hasUpperCase = /[A-Z]/.test(password);
    const hasLowerCase = /[a-z]/.test(password);
    const hasNumbers = /\d/.test(password);

    // Check if password meets the requirements
    return password.length >= minLength && hasUpperCase && hasLowerCase && hasNumbers;
  }

  // Function to check if the email is already taken
  function checkEmailAvailability(email) {
    return fetch('/check-email', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email: email })
    }).then(response => response.json());
  }

  // Function to check if the username is already taken
  function checkUsernameAvailability(username) {
    return fetch('/check-username', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ username: username })
    }).then(response => response.json());
  }

  document.addEventListener("DOMContentLoaded", function () {
    let usernameInput = document.getElementById("username");
    let feedback = document.getElementById("username-feedback");
    let typingTimer;
    let doneTypingInterval = 500; // 500ms after user stops typing

    usernameInput.addEventListener("keyup", function () {
      clearTimeout(typingTimer);
      typingTimer = setTimeout(checkUsername, doneTypingInterval);
    });

    usernameInput.addEventListener("keydown", function () {
      clearTimeout(typingTimer);
    });

    function checkUsername() {
      let username = usernameInput.value.trim();
      if (username.length < 8) {
        feedback.textContent = "Username must be at least 8 characters.";
        return;
      }

      // Send the AJAX request using fetch
      fetch('/check-username', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({username: username})
      })
              .then(response => response.json())
              .then(data => {
                if (data.exists) {
                  feedback.textContent = "Username is already taken.";
                  feedback.classList.add("text-danger");
                  feedback.classList.remove("text-success");
                } else {
                  feedback.textContent = "Username is available.";
                  feedback.classList.remove("text-danger");
                  feedback.classList.add("text-success");
                }
              })
              .catch(error => {
                console.error("Error:", error);
                feedback.textContent = "Error checking username.";
              });
    }
  });

  document.addEventListener("DOMContentLoaded", function () {
    let emailInput = document.getElementById("email");
    let feedback = document.getElementById("email-feedback");
    let typingTimer;
    let doneTypingInterval = 500; // 500ms after user stops typing

    emailInput.addEventListener("keyup", function () {
      clearTimeout(typingTimer);
      typingTimer = setTimeout(checkEmail, doneTypingInterval);
    });

    emailInput.addEventListener("keydown", function () {
      clearTimeout(typingTimer);
    });

    function checkEmail() {
      let email = emailInput.value.trim();

      // Email format validation using regex
      const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
      if (!emailPattern.test(email)) {
        feedback.textContent = "Please enter a valid email address.";
        feedback.style.color = "red";
        feedback.style.display = "block";
        return;
      }

      // Send the AJAX request using fetch
      fetch('/check-email', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({email: email})
      })
              .then(response => response.json())
              .then(data => {
                if (data.exists) {
                  feedback.textContent = "This email is already exsited in the system.";
                  feedback.classList.remove("text-success");
                  feedback.classList.add("text-danger");
                } else {
                  feedback.textContent = "This email is available.";
                  feedback.classList.remove("text-danger");
                  feedback.classList.add("text-success");
                }
              })
              .catch(error => {
                console.error("Error:", error);
                feedback.textContent = "Error checking email.";
              });
    }
  });

  document.addEventListener("DOMContentLoaded", function () {
    let passwordInput = document.getElementById("password");
    let feedback = document.getElementById("password-feedback");
    let typingTimer;
    let doneTypingInterval = 500; // 500ms after user stops typing

    passwordInput.addEventListener("keyup", function () {
      clearTimeout(typingTimer);
      typingTimer = setTimeout(checkEmail, doneTypingInterval);
    });

    passwordInput.addEventListener("keydown", function () {
      clearTimeout(typingTimer);
    });

    function checkEmail() {
      let password = passwordInput.value.trim();

      // Validate password
      if (!isPasswordValid(password)) {
        feedback.textContent = 'Password must be at least 8 characters long and contain at least one number, one uppercase letter.';
      }
      else feedback.textContent = '';
    }
  });

  document.getElementById('registerForm').addEventListener('submit', function (e) {
    e.preventDefault();

    const email = document.getElementById('email').value;
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirm_password').value;
    const agreeTerms = document.getElementById('agree_terms').checked;
    const fullname = document.getElementById('fullname').value;

    // Validate password
    if (!isPasswordValid(password)) {
      document.getElementById('error-message').innerText = 'Password must be at least 8 characters long and contain at least one number, one uppercase letter.';
      document.getElementById('error-message').style.display = 'block';
      return;
    }

    // Validate password match
    if (password !== confirmPassword) {
      document.getElementById('error-message').innerText = 'Passwords do not match.';
      document.getElementById('error-message').style.display = 'block';
      return;
    }

    // Validate terms agreement
    if (!agreeTerms) {
      document.getElementById('error-message').innerText = 'You must agree to the terms and conditions.';
      document.getElementById('error-message').style.display = 'block';
      return;
    }

    // Check email availability
    checkEmailAvailability(email).then(emailData => {
      if (!emailData.available) {
        document.getElementById('error-message').innerText = 'Email is already in use.';
        document.getElementById('error-message').style.display = 'block';
        return;
      }
    })

      // Check username availability
      checkUsernameAvailability(username).then(usernameData => {
        if (!usernameData.available) {
          document.getElementById('error-message').innerText = 'Username is already in use.';
          document.getElementById('error-message').style.display = 'block';
          return;
        }
      })


        // Create the request payload
    const requestData = {
      email: email,
      fullname: fullname,
      username: username,
      password: password
    };

    console.log(JSON.stringify(requestData))

    // Send the AJAX request using fetch
    fetch('/register', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(requestData),
      action: "register"
    })
            .then(response => response.json())
            .then(data => {
              if (data.success) {
                window.location.href = '/login'; // Redirect to login page after successful registration
              } else {
                document.getElementById('error-message').innerText = data.error || 'Registration failed.';
                document.getElementById('error-message').style.display = 'block';
              }
            })
            .catch(error => {
              console.error('Error during registration:', error);
              document.getElementById('error-message').innerText = 'There was an error with the registration process.';
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