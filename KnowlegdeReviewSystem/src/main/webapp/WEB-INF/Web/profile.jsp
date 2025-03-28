<%@ page import="models.User" %>
<%@ page import="controllers.WebManager" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Profile</title>

  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>

  <style>
    html {
      height: 100%;
    }
    body {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      margin: 0;
      min-height: 100%;
      display: flex;
      flex-direction: column;
    }

    .main-content {
      flex: 1 0 auto; /* Grows to push footer down */
    }

    .profile-container {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 20px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
      overflow: hidden;
      margin: 5rem auto;
      max-width: 900px;
    }

    .avatar-container {
      position: relative;
      width: 180px;
      margin: 2rem auto;
      transition: all 0.3s ease;
    }

    .avatar-container:hover {
      transform: scale(1.05);
    }

    .avatar {
      width: 180px;
      height: 180px;
      border-radius: 50%;
      border: 5px solid #fff;
      object-fit: cover;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    }

    .upload-icon {
      position: absolute;
      bottom: 15px;
      right: 15px;
      background: #667eea;
      color: white;
      border-radius: 50%;
      padding: 10px;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .upload-icon:hover {
      background: #764ba2;
      transform: scale(1.1);
    }

    .file-input {
      display: none;
    }

    .profile-info {
      padding: 2rem;
    }

    .labels {
      font-weight: 600;
      color: #333;
      margin-bottom: 0.5rem;
    }

    .form-control {
      border-radius: 10px;
      border: 1px solid #ddd;
      padding: 0.75rem;
      transition: all 0.3s ease;
    }

    .form-control:focus {
      border-color: #667eea;
      box-shadow: 0 0 10px rgba(102, 126, 234, 0.2);
    }

    .btn-primary {
      background: #667eea;
      border: none;
      border-radius: 10px;
      padding: 0.75rem 1.5rem;
      transition: all 0.3s ease;
    }

    .btn-primary:hover {
      background: #764ba2;
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    }

    h4 {
      color: #333;
      font-weight: 700;
      margin-bottom: 1.5rem;
    }

    .username {
      color: #333;
      font-size: 1.5rem;
      font-weight: 700;
      margin: 0.5rem 0;
    }

    .email {
      color: #666;
      font-size: 1rem;
    }
  </style>
</head>

<body>
<jsp:include page="header.jsp"></jsp:include>


<%
  User user = (User) session.getAttribute("user");
%>
<div class="main-content">
<div class="container profile-container mt-5 mb-5">
  <div class="row">
    <!-- Profile Picture Upload -->
    <div class="col-md-4 text-center">
      <div class="avatar-container">
        <img id="avatarPreview" class="avatar"
             src="<%= session.getAttribute("user") != null
                        ? ((User) session.getAttribute("user")).getAvatar()
                        : "Images/default-avatar.png" %>">

        <form action="UploadAvatarServlet" method="post" enctype="multipart/form-data">
          <label for="avatarUpload" class="upload-icon">
            <i class="fas fa-camera"></i>
          </label>
          <input type="file" id="avatarUpload" class="file-input" name="avatar" accept="image/*">
          <button type="submit" class="btn btn-primary mt-3">Upload Avatar</button>
        </form>
      </div>
      <div class="username"><%= user.getFullName() %></div>
      <div class="email"><%= user.getEmail() %></div>
    </div>

    <!-- Previous HTML remains the same until the profile-info section -->
    <div class="col-md-8 profile-info">
      <h4>Profile Settings</h4>
      <div class="row" id="profileForm">
        <div class="col-md-6 mb-3">
          <label class="labels">Username</label>
          <input type="text" class="form-control" placeholder="UserName" value="<%=user.getUsername()%>" disabled>
        </div>
        <div class="col-md-6 mb-3">
          <label class="labels">Email</label>
          <input type="text" class="form-control" placeholder="Email" value="<%=user.getEmail()%>" disabled>
        </div>
        <div class="col-md-6 mb-3">
          <label class="labels">Full Name</label>
          <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Full Name" value="<%=user.getFullName()%>">
        </div>
        <div class="col-md-6 mb-3">
          <label class="labels">Role</label>
          <input type="text" class="form-control" placeholder="Role" value="<%=WebManager.getInstance().getSettingDAO().getRoleById(user.getRoleId())%>" disabled>
        </div>
      </div>

      <h4 class="mt-4">Change Password</h4>
      <form id="changePasswordForm">
        <div class="row">
          <div class="col-md-12 mb-3">
            <label class="labels">Current Password</label>
            <input type="password" class="form-control" name="currentPassword" id="currentPassword"
                   placeholder="Enter current password" required>
            <div id="currentPasswordMessage" class="mt-2"></div>
          </div>
          <div class="col-md-12 mb-3">
            <label class="labels">New Password</label>
            <input type="password" class="form-control" name="newPassword" id="newPassword"
                   placeholder="Enter new password" required>
            <div id="newPasswordMessage" class="mt-2"></div>
          </div>
          <div class="col-md-12 mb-3">
            <label class="labels">Confirm New Password</label>
            <input type="password" class="form-control" name="confirmPassword" id="confirmPassword"
                   placeholder="Confirm new password" required>
            <div id="confirmPasswordMessage" class="mt-2"></div>
          </div>
        </div>
        <button class="btn btn-primary mt-3" type="submit" id="changePasswordBtn" disabled>Change Password</button>
        <button class="btn btn-primary mt-3 ms-3" type="button" id="saveProfileBtn">Save Profile</button>
      </form>
    </div>
    <!-- Rest of the HTML remains the same -->
  </div>
</div>
</div>

<jsp:include page="footer.jsp"></jsp:include>

<!-- JavaScript for Image Preview -->
<script>
  // Image Preview (remains the same)
  document.getElementById("avatarUpload").addEventListener("change", function(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = function(e) {
        document.getElementById("avatarPreview").src = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  });

  // Save Profile AJAX (remains the same)
  $("#saveProfileBtn").click(function(e) {
    e.preventDefault();
    const fullName = $("#fullName").val();

    $.ajax({
      url: '/save-profile',
      type: 'POST',
      data: { fullName: fullName },
      success: function(response) {
        $("#message").html('<div class="alert alert-success">Profile updated successfully!</div>');
        setTimeout(() => $("#message").html(''), 3000);
        window.href.reload();
      },
      error: function(xhr, status, error) {
        $("#message").html('<div class="alert alert-danger">Error updating profile: ' + xhr.responseText + '</div>');
        setTimeout(() => $("#message").html(''), 3000);
        window.href.reload();
      }
    });

    window.href.reload();
  });

  // Current Password Verification
  let isCurrentPasswordValid = false;

  $("#currentPassword").on('input', function() {
    const currentPassword = $(this).val();

    if (currentPassword.length > 0) {
      $.ajax({
        url: '/get-password',
        type: 'GET',
        data: { currentPassword: currentPassword },
        success: function(response) {
          if (response.valid) {
            isCurrentPasswordValid = true;
            $("#changePasswordBtn").prop('disabled', false);
            $("#currentPasswordMessage").html('<div class="alert alert-success">Current password verified</div>');
            setTimeout(() => $("#currentPasswordMessage").html(''), 2000);
          } else {
            isCurrentPasswordValid = false;
            $("#changePasswordBtn").prop('disabled', true);
            $("#currentPasswordMessage").html('<div class="alert alert-warning">Incorrect current password</div>');
          }
        },
        error: function(xhr, status, error) {
          isCurrentPasswordValid = false;
          $("#changePasswordBtn").prop('disabled', true);
          $("#currentPasswordMessage").html('<div class="alert alert-danger">Error verifying password</div>');
        }
      });
    } else {
      isCurrentPasswordValid = false;
      $("#changePasswordBtn").prop('disabled', true);
      $("#currentPasswordMessage").html('');
    }
  });

  // Password validation function
  function isPasswordValid(password) {
    const minLength = 8;
    const maxLength = 32;
    const hasUpperCase = /[A-Z]/.test(password);
    const hasNumber = /\d/.test(password);
    const lengthValid = password.length >= minLength && password.length <= maxLength;

    return lengthValid && hasUpperCase && hasNumber;
  }

  // Change Password AJAX
  $("#changePasswordForm").submit(function(e) {
    e.preventDefault();

    if (!isCurrentPasswordValid) {
      $("#currentPasswordMessage").html('<div class="alert alert-danger">Please enter correct current password first</div>');
      return;
    }

    const currentPassword = $("#currentPassword").val();
    const newPassword = $("#newPassword").val();
    const confirmPassword = $("#confirmPassword").val();

    // Check password requirements
    if (!isPasswordValid(newPassword)) {
      $("#newPasswordMessage").html('<div class="alert alert-danger">Password must be 8-32 characters long and contain at least one uppercase letter and one number</div>');
      setTimeout(() => $("#newPasswordMessage").html(''), 3000);
      return;
    }

    if (newPassword !== confirmPassword) {
      $("#confirmPasswordMessage").html('<div class="alert alert-danger">New passwords do not match!</div>');
      setTimeout(() => $("#confirmPasswordMessage").html(''), 3000);
      return;
    }

    $.ajax({
      url: '/change-password',
      type: 'POST',
      data: {
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword
      },
      success: function(response) {
        $("#newPasswordMessage").html('<div class="alert alert-success">Password changed successfully!</div>');
        $("#changePasswordForm")[0].reset();
        $("#changePasswordBtn").prop('disabled', true);
        isCurrentPasswordValid = false;
        setTimeout(() => $("#newPasswordMessage").html(''), 3000);
      },
      error: function(xhr, status, error) {
        $("#newPasswordMessage").html('<div class="alert alert-danger">Error changing password: ' + xhr.responseText + '</div>');
        setTimeout(() => $("#newPasswordMessage").html(''), 3000);
      }
    });
  });

  // Real-time password validation feedback
  $("#newPassword").on('input', function() {
    const password = $(this).val();
    if (password.length > 0 && !isPasswordValid(password)) {
      $("#newPasswordMessage").html('<div class="alert alert-warning">Password must be 8-32 characters long and contain at least one uppercase letter and one number</div>');
    } else {
      $("#newPasswordMessage").html('');
    }
  });

  // Real-time confirm password matching
  $("#confirmPassword").on('input', function() {
    const newPassword = $("#newPassword").val();
    const confirmPassword = $(this).val();
    if (confirmPassword.length > 0 && newPassword !== confirmPassword) {
      $("#confirmPasswordMessage").html('<div class="alert alert-warning">Passwords do not match</div>');
    } else {
      $("#confirmPasswordMessage").html('');
    }
  });
</script>
</body>
</html>