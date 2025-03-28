<%@ page import="models.User" %><%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/3/2025
  Time: 4:13 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page isELIgnored="false" %>
<html>

<head>
    <title>Class Detail</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="CSS/ClassStudent/classStudentDetail.css">
</head>

<body>

<div class="container-fluid">
    <%
        String message = (String) session.getAttribute("message");
        session.removeAttribute("message");
    %>
    <%--    Dòng hiện thị thông báo--%>
    <div id="toastMessage" class="toast align-items-center text-white bg-success border-0 position-fixed top-0 end-0"
         role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body text-center">
                <%= message != null ? message : "" %>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                    aria-label="Close"></button>
        </div>
    </div>

    <div class="row">
        <!-- Sidebar -->
        <%
            User user = (User) session.getAttribute("user");
        %>
        <div class="col-auto px-0 sidebar d-none d-md-block">
            <div class="d-flex flex-column p-3">
                <h5 class="text-white mb-4">AdminKit</h5>
                <nav class="nav flex-column">
                    <!-- Home: Accessible to all roles -->
                    <a class="nav-link" href="/admin"><i class="bi bi-house"></i> Home</a>

                    <!-- User: Admin only -->
                    <% if (user != null && user.getRoleId() == 1) { %>
                    <a class="nav-link" href="/user"><i class="bi bi-person-circle"></i> User</a>
                    <% } %>

                    <!-- Subject: Admin and Subject Manager -->
                    <% if (user != null && (user.getRoleId() == 1 || user.getRoleId() == 5)) { %>
                    <a class="nav-link" href="/subject"><i class="bi bi-book"></i> Subject</a>
                    <% } %>


                    <!-- Class: Admin, Teacher, Training Manager, Subject Manager -->
                    <% if (user != null && (user.getRoleId() == 2)) { %>
                    <a class="nav-link" href="/class_teacher"><i class="bi bi-people"></i> Class</a>
                    <% } %>

                    <!-- Class: Admin, Training Manager, Subject Manager -->
                    <% if (user != null && (user.getRoleId() == 1 || user.getRoleId() == 4 || user.getRoleId() == 5)) { %>
                    <a class="nav-link" href="/class_management"><i class="bi bi-people"></i> Class</a>
                    <% } %>

                    <!-- Setting: Admin only -->
                    <% if (user != null && user.getRoleId() == 1) { %>
                    <a class="nav-link" href="/setting"><i class="bi bi-gear"></i> Setting</a>
                    <% } %>

                    <!-- Question: Admin and Subject Manager -->
                    <% if (user != null && (user.getRoleId() == 1 || user.getRoleId() == 5)) { %>
                    <a class="nav-link" href="question?action=choose"><i class="bi bi-question-octagon"></i> Question</a>
                    <% } %>

                    <!-- Term: Admin and Subject Manager -->
                    <% if (user != null && (user.getRoleId() == 1 || user.getRoleId() == 5)) { %>
                    <a class="nav-link" href="term?action=choose"><i class="bi bi-journal-text"></i> Term</a>
                    <% } %>

                    <a class="nav-link" href="/logout"><i class="bi bi-arrow-return-left"></i> Logout</a>
                </nav>
            </div>
        </div>

        <div class="col p-0">
            <div class="header-bar d-flex justify-content-between align-items-center px-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="header-title">Class ${clazz.className}</div>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-warning shadow-sm" data-bs-toggle="modal"
                            data-bs-target="#approveStudentModal">
                        <i class="bi bi-check-circle"></i> Approve
                    </button>
                    <a href="exportStudents?classId=${oldClassId}" id="exportBtn" class="btn btn-success">
                        <i class="bi bi-download"></i> Export
                    </a>
                    <button type="button" class="btn btn-secondary shadow-sm" data-bs-toggle="modal"
                            data-bs-target="#importStudentModal">
                        <i class="bi bi-upload"></i> Import
                    </button>
                    <button type="button" class="btn btn-primary shadow-sm" data-bs-toggle="modal"
                            data-bs-target="#newStudentModal">
                        <i class="bi bi-plus-circle"></i> Add Student
                    </button>

                </div>
            </div>
            <div class="card border-0 m-4">
                <div class="card-body">
                    <h5 class="card-title">Student List</h5>
                    <table class="table class-table">
                        <thead>
                        <tr>
                            <th>STT</th> <!-- Cột STT -->
                            <th>ID</th>
                            <th>Avatar</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Action</th>
                            <th style="display: none;">ID</th> <!-- Cột ẩn cho ID -->
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="student" items="${approvedStudents}" varStatus="status">
                            <tr id="studentRow-${student.id}">
                                <td>${status.index + 1}</td> <!-- Hiển thị số thứ tự (STT) -->
                                <td>${student.id}</td>
                                <td>
                                    <img src="${student.avatar != null ? student.avatar : 'https://chiemtaimobile.vn/images/companies/1/%E1%BA%A2nh%20Blog/avatar-facebook-dep/Anh-avatar-hoat-hinh-de-thuong-xinh-xan.jpg?1704788263223'}"
                                         alt="Avatar" class="student-img">
                                </td>
                                <td>${student.fullName}</td>
                                <td>${student.email}</td>
                                <td>
                                    <button class="btn btn-danger btn-sm" onclick="kickOutStudent(${student.id}, ${oldClassId})" title="Kick Out">
                                        <i class="bi-box-arrow-right fs-5"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Approve Student Modal -->
<div class="modal fade" id="approveStudentModal" tabindex="-1"
     aria-labelledby="approveStudentModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Approve Student Registrations</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <table class="table text-center">
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="student" items="${pendingStudents}">
                        <tr id="studentRow-${student.id}">
                            <td>${student.fullName}</td>
                            <td>${student.email}</td>
                            <td class="d-flex justify-content-center">
                                <button class="btn btn-success me-2"
                                        onclick="updateStudentStatus(${student.id}, ${oldClassId}, 'approve')">
                                    Approve
                                </button>
                                <button class="btn btn-danger"
                                        onclick="updateStudentStatus(${student.id}, ${oldClassId}, 'reject')">
                                    Reject
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Add Student Modal -->
<div class="modal fade" id="newStudentModal" tabindex="-1" aria-labelledby="newStudentModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="newStudentModalLabel">Add Student</h3>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="class_student_detail" method="post">
                    <input type="hidden" name="classId" value="${oldClassId}">
                    <input type="hidden" name="action" value="addStudent">
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control popup" id="email" name="email" required oninput="validateEmail()">
                        <small id="emailError" class="text-danger" style="display: none;"></small>
                    </div>

                    <!-- Display username and fullname fields based on email validation -->
                    <div class="mb-3" id="fullnameField" style="display: none;">
                        <label for="fullname" class="form-label">Fullname</label>
                        <input type="text" class="form-control popup" id="fullname" name="fullname" required readonly>
                    </div>
                    <div class="mb-3" id="usernameField" style="display: none;">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" class="form-control popup" id="username" name="username" required readonly oninput="validateUsername()">
                        <small id="usernameError" class="text-danger" style="display: none;"></small>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 rounded-3 shadow-sm mt-3" id="addStudentBtn" disabled>
                        Add
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Import Student Modal -->
<div class="modal fade" id="importStudentModal" tabindex="-1" aria-labelledby="importStudentModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="importStudentModalLabel">Import Students</h3>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="importForm" action="class_student_detail" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="classId" value="${oldClassId}">
                    <input type="hidden" name="action" value="importStudents">

                    <div class="mb-3">
                        <label for="excelFile" class="form-label">Upload Excel File</label>
                        <input type="file" class="form-control" id="excelFile" name="file" accept=".xls,.xlsx" required>
                    </div>

                    <div class="mb-3">
                        <p class="text-muted">Please use the template below to import students. <a target="_blank" href="https://docs.google.com/spreadsheets/d/1sD61oWWqsYpGnaP59oaFf5wj7KtNyipkmj8YBW82Mco/edit?usp=sharing"class="btn btn-link">View Excel Template</a></p>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 py-2 rounded-3 shadow-sm mt-3"
                            onclick="document.getElementById('importForm').action = 'class_student_detail?action=importStudents&classId=${oldClassId}';">
                        Import
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>


<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>
</body>
<script>
    function updateStudentStatus(studentId, classId, action) {
        $.ajax({
            url: "/approve_reject_student",
            type: "POST",
            data: { studentId: studentId, classId: classId, action: action },
            success: function (response) {
                if (response.success) {
                    let message = action === 'approve' ? "Student approved successfully!" : "Student rejected successfully!";
                    showToast(message); // Gọi hàm hiển thị Toast
                    $("#studentRow-" + studentId).fadeOut(); // Ẩn dòng sinh viên đã xử lý
                } else {
                    alert("Failed to process request.");
                }
            },
            error: function () {
                alert("Error processing request.");
            }
        });
    }

    function kickOutStudent(studentId, classId) {
        if (confirm("Are you sure you want to remove this student from the class?")) {
            $.ajax({
                url: "/approve_reject_student",
                type: "POST",
                data: { studentId: studentId, classId: classId, action: "reject" },
                success: function (response) {
                    if (response.success) {
                        showToast("Student has been removed successfully!");
                        $("#studentRow-" + studentId).fadeOut(); // Ẩn dòng sinh viên ngay lập tức
                    } else {
                        alert("Failed to remove student.");
                    }
                },
                error: function () {
                    alert("Error processing request.");
                }
            });
        }
    }

    // Hàm hiển thị Toast
    function showToast(message) {
        let toastElement = document.getElementById("toastMessage");
        toastElement.querySelector(".toast-body").innerText = message;
        let toast = new bootstrap.Toast(toastElement, { delay: 2000 });
        toast.show();
    }

    document.addEventListener("DOMContentLoaded", function () {
        let toastMessage = sessionStorage.getItem("toastMessage");
        if (toastMessage) {
            showToast(toastMessage);
            sessionStorage.removeItem("toastMessage");
        }
    });

    function validateEmail() {
        let email = document.getElementById("email").value;
        let errorSpan = document.getElementById("emailError");
        let addButton = document.getElementById("addStudentBtn");
        let usernameField = document.getElementById("usernameField");
        let fullnameField = document.getElementById("fullnameField");

        if (!email.trim()) {
            errorSpan.style.display = "none";
            addButton.disabled = true;
            return;
        }

        $.ajax({
            url: "/user/checkUserExists",
            type: "GET",
            data: { email: email },
            success: function (response) {
                if (response.includes("Email already exists!")) {
                    // Email found, check class status
                    $.ajax({
                        url: "/class_student_check",
                        type: "GET",
                        data: { email: email, classId: "${oldClassId}" },
                        success: function (response) {
                            if (response.exists) {
                                if (response.approved) {
                                    errorSpan.innerText = "Student is already Approved in this class!";
                                    errorSpan.style.display = "block";
                                    errorSpan.classList.remove("text-success");
                                    errorSpan.classList.add("text-danger");
                                    addButton.disabled = true;
                                } else {
                                    errorSpan.innerText = "Student is in class but not Approved yet!";
                                    errorSpan.style.display = "block";
                                    errorSpan.classList.remove("text-success");
                                    errorSpan.classList.add("text-danger");
                                    addButton.disabled = false;
                                }
                            } else {
                                // Set username and fullname from DB and make fields readonly
                                document.getElementById("username").value = response.username1;  // Set username from DB
                                document.getElementById("fullname").value = response.fullname;  // Set fullname from DB
                                document.getElementById("username").readOnly = true;  // Make username readonly
                                document.getElementById("fullname").readOnly = true;  // Make fullname readonly

                                usernameField.style.display = "block";
                                fullnameField.style.display = "block";

                                errorSpan.style.display = "none";
                                addButton.disabled = false;
                            }
                        }
                    });
                } else {
                    errorSpan.innerText = "Email will be created in the system";
                    errorSpan.style.display = "block";
                    errorSpan.classList.remove("text-danger"); // Xóa lớp màu đỏ cũ nếu có
                    errorSpan.classList.add("text-success");   // Thêm lớp màu xanh
                    addButton.disabled = false;

                    usernameField.style.display = "block";
                    fullnameField.style.display = "block";
                    document.getElementById("username").value = "";
                    document.getElementById("fullname").value = "";
                    document.getElementById("username").readOnly = false;
                    document.getElementById("fullname").readOnly = false;
                }
            }
        });
    }

    function validateUsername() {
        let username = document.getElementById("username").value;
        let errorSpan = document.getElementById("usernameError");
        let addButton = document.getElementById("addStudentBtn");

        if (!username.trim()) {
            errorSpan.style.display = "none";
            addButton.disabled = true;
            return;
        }

        // Gửi AJAX request để kiểm tra username có tồn tại không
        $.ajax({
            url: "/user/checkUserExists",
            type: "GET",
            data: { username: username },
            success: function(response) {
                if (response.includes("Username already exists!")) {
                    // Nếu username đã tồn tại, hiển thị lỗi
                    errorSpan.innerText = "Username already exists!";
                    errorSpan.style.display = "block";
                    addButton.disabled = true; // Disable add button
                } else {
                    // Nếu username chưa tồn tại, ẩn lỗi và enable button
                    errorSpan.style.display = "none";
                    addButton.disabled = false;
                }
            }
        });
    }




</script>
</html>