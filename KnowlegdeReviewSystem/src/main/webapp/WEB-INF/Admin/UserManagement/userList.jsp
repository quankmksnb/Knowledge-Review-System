<%@ page import="models.User" %><%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 1/27/2025
  Time: 12:34 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page isELIgnored="false" %>

<html>
<head>
    <title>User Management</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="CSS/UserManagement/userList.css">
</head>
<body>

<div class="container-fluid">
    <%
        String message = (String) session.getAttribute("message");
        session.removeAttribute("message");
    %>
    <div class="toast-container">
        <div id="statusToast" class="toast custom-toast hide" role="alert" aria-live="assertive" aria-atomic="true"
             data-bs-delay="2000">
            <div class="toast-header">
                <i class="bi me-2" id="toastIcon"></i>
                <strong class="me-auto" id="toastTitle"></strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"
                        aria-label="Close"></button>
            </div>
            <div class="toast-body" id="toastMessage">
                <%= message != null ? message : "" %>
            </div>
        </div>
    </div>


    <div class="row">
        <!-- Sidebar -->
        <%
            User user = (User) session.getAttribute("user");
        %>
        <jsp:include page="../../Admin/homeAdmin.jsp"></jsp:include>

        <!-- Main Content -->
        <div class="col p-0">
            <!-- Header Bar -->
            <div class="header-bar d-flex justify-content-between align-items-center px-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="header-title">User Management</div>
                    <div class="position-relative">
                        <input oninput="searchUsers()" name="search_fullname" type="text"
                               class="form-control search-input" placeholder="Search users...">
                    </div>
                    <div>
                        <select onchange="searchUsers()" class="form-select" id="roleFilter" name="roleFilter">
                            <option value="">All Role</option>
                            <c:forEach var="role" items="${settings}">
                                <option value="${role.id}">${role.title}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <select onchange="searchUsers()" class="form-select" id="statusFilter" name="statusFilter">
                            <option value="">All Status</option>
                            <option value="Active">Active</option>
                            <option value="Deactivated">Deactivated</option>
                            <option value="NotVerified">NotVerified</option>
                        </select>
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <a href="user/export" id="exportBtn" class="btn btn-success">
                        <i class="bi bi-download"></i> Export File
                    </a>
                    <button type="button" class="btn btn-primary shadow-sm" data-bs-toggle="modal"
                            data-bs-target="#newUserModal">
                        <i class="bi bi-plus-circle"></i> New User
                    </button>
                </div>
                <div class="modal fade" id="newUserModal" tabindex="-1" aria-labelledby="newUserModalLabel"
                     aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3 class="modal-title" id="newUserModalLabel">Create New User</h3>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form id="userForm" action="user" method="post">

                                    <div class="mb-3">
                                        <label for="fullname" class="form-label">Fullname</label>
                                        <input type="text" class="form-control popup" id="fullname" name="fullname"
                                               required>
                                    </div>

                                    <div class="d-flex align-items-center gap-2">
                                        <label for="email" class="form-label me-auto">Email</label>
                                        <small id="emailError" class="text-danger ms-2" style="display:none;"></small>
                                    </div>
                                    <div class="mb-3">
                                        <input type="email" class="form-control popup" id="email" name="email" required>
                                    </div>
                                    <div class="d-flex align-items-center gap-2">
                                        <label for="email" class="form-label me-auto">Username</label>
                                        <small id="usernameError" class="text-danger ms-2"
                                               style="display:none;"></small>
                                    </div>
                                    <div class="mb-3">
                                        <input type="text" class="form-control popup" id="username" name="username"
                                               required>
                                    </div>


                                    <div class="mb-3">
                                        <label for="role" class="form-label">Role</label>
                                        <select class="form-select popup" id="role" name="role">
                                            <c:forEach var="role" items="${settings}">
                                                <option value="${role.id}">${role.title}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <button type="submit" class="btn btn-primary w-100 py-2 rounded-3 shadow-sm mt-3">
                                        Create
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <!-- User Table -->
            <div class="table-responsive user-table">
                <table class="table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Full Name</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="content">
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>${user.id}</td>
                            <td>${user.fullName}</td>
                            <td>${user.username}</td>
                            <td>${user.email}</td>
                            <td>${roleMap[user.roleId]}</td> <!-- Lấy title từ roleMap -->
                            <td>
                                <span id="status-${user.id}" class="badge
                                    <c:choose>
                                        <c:when test="${user.status == 'Active'}">bg-success</c:when>
                                        <c:when test="${user.status == 'Deactivated'}">bg-danger</c:when>
                                        <c:when test="${user.status == 'NotVerified'}">bg-warning</c:when>
                                        <c:otherwise>bg-secondary</c:otherwise>
                                    </c:choose>
                                ">
                                        ${user.status}
                                </span>
                            </td>
                            <td class="text-center">
                                <!-- Icon chỉnh sửa -->
                                <a href="user_update?id=<c:out value='${user.id}'/>" class="btn btn-sm action-btn"
                                   title="Edit">
                                    <i class="bi bi-pencil-square fs-5"></i>
                                </a>

                                <!-- Icon khóa/mở khóa -->
                                <a href="javascript:void(0);" class="btn btn-sm action-btn" title="Toggle Status"
                                   onclick="toggleStatus(${user.id})">
                                    <i id="lock-icon-${user.id}" class="bi
                                        <c:choose>
                                            <c:when test="${user.status == 'Deactivated'}">bi-lock-fill text-danger</c:when>
                                            <c:otherwise>bi-unlock-fill text-success</c:otherwise>
                                        </c:choose>
                                    fs-5"></i>
                                </a>
                            </td>

                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div class="pagination mt-4">
                <%
                    int currentPage = (int) request.getAttribute("currentPage");
                    int totalPages = (int) request.getAttribute("totalPages");
                    if (totalPages > 1) {
                %>
                <a href="?page=<%= Math.max(1, currentPage - 1) %>"
                   class="pagination-item <%= currentPage == 1 ? "disabled" : "" %>">
                    <i class="bi bi-chevron-left"></i>
                </a>

                <%
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(totalPages, startPage + 4);
                    if (startPage > 1) {
                %>
                <a href="?page=1" class="pagination-item">1</a>
                <% if (startPage > 2) { %>
                <span class="pagination-item disabled">...</span>
                <% } %>
                <% } %>

                <% for (int i = startPage; i <= endPage; i++) { %>
                <a href="?page=<%= i %>" class="pagination-item <%= i == currentPage ? "active" : "" %>"><%= i %>
                </a>
                <% } %>

                <% if (endPage < totalPages) { %>
                <% if (endPage < totalPages - 1) { %>
                <span class="pagination-item disabled">...</span>
                <% } %>
                <a href="?page=<%= totalPages %>" class="pagination-item"><%= totalPages %>
                </a>
                <% } %>

                <a href="?page=<%= Math.min(totalPages, currentPage + 1) %>"
                   class="pagination-item <%= currentPage == totalPages ? "disabled" : "" %>">
                    <i class="bi bi-chevron-right"></i>
                </a>
                <% } %>
            </div>

        </div>
    </div>
</div>


</body>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>

<script>
    function toggleStatus(userId) {
        if (!confirm("Bạn có chắc chắn muốn thay đổi trạng thái người dùng này?")) return;

        $.ajax({
            url: "/user/toggleStatus",
            type: "POST",
            data: {userId: userId},
            dataType: "json",
            success: function (response) {
                let statusSpan = $("#status-" + userId);
                let icon = $("#lock-icon-" + userId);

                // Cập nhật trạng thái text trong bảng
                statusSpan.text(response.newStatus);
                statusSpan.removeClass("bg-success bg-danger bg-warning")
                    .addClass("bg-" + response.statusClass);

                // Cập nhật icon khóa/mở khóa
                if (response.newStatus === "Deactivated") {
                    icon.removeClass("bi-unlock-fill text-success")
                        .addClass("bi-lock-fill text-danger");
                } else {
                    icon.removeClass("bi-lock-fill text-danger")
                        .addClass("bi-unlock-fill text-success");
                }

                console.log("User ID: " + userId + " -> Updated to: " + response.newStatus);
            },
            error: function () {
                alert("Có lỗi xảy ra, vui lòng thử lại!");
            }
        });
    }


    // hiện thị thông báo và set time tồn tại 3 giây
    document.addEventListener("DOMContentLoaded", function () {
        let toastElement = document.getElementById("toastMessage");
        if (toastElement.innerText.trim() !== "") {
            let toast = new bootstrap.Toast(toastElement, {delay: 2000});
            toast.show();
        }
    });

    document.addEventListener("DOMContentLoaded", function () {
        let toastElement = document.getElementById("toastMessage");
        if (toastElement.innerText.trim() !== "") {
            let toast = new bootstrap.Toast(toastElement);
            toast.show();
        }
    });

    function searchUsers() {
        let searchQuery = document.querySelector(".search-input").value.trim();
        let roleId = document.getElementById("roleFilter").value;
        let status = document.getElementById("statusFilter").value;
        $.ajax({
            url: "/user/search",
            type: "get", //send it through get method
            data: {search_fullname: searchQuery, roleFilter: roleId, statusFilter: status}, // Thêm tham số vào request

            success: function (data) {
                var row = document.getElementById("content");
                row.innerHTML = data;
                //Do Something
            },
            error: function (xhr) {
                //Do Something to handle error
            }
        });
    }


    document.addEventListener("DOMContentLoaded", function () {
        document.getElementById("email").addEventListener("input", checkUserExists);
        document.getElementById("username").addEventListener("input", checkUserExists);
        document.getElementById("userForm").addEventListener("submit", function (event) {
            event.preventDefault(); // Ngăn form gửi ngay lập tức
            validateAndSubmitForm();
        });
    });

    function checkUserExists(callback) {
        let email = document.getElementById("email").value.trim();
        let username = document.getElementById("username").value.trim();

        $.ajax({
            url: "/user/checkUserExists",
            type: "get",
            data: {email: email, username: username},
            success: function (data) {
                let emailError = document.getElementById("emailError");
                let usernameError = document.getElementById("usernameError");

                emailError.innerHTML = "";
                usernameError.innerHTML = "";
                emailError.style.display = "none";
                usernameError.style.display = "none";

                let hasError = false;

                if (data.includes("Email already exists!")) {
                    emailError.innerHTML = "Email already exists!";
                    emailError.style.display = "block";
                    hasError = true;
                }

                if (data.includes("Username already exists!")) {
                    usernameError.innerHTML = "Username already exists!";
                    usernameError.style.display = "block";
                    hasError = true;
                }

                // Gọi callback để tiếp tục xử lý sau khi kiểm tra xong
                if (callback) {
                    callback(!hasError);
                }
            }
        });
    }


    function validateAndSubmitForm() {
        checkUserExists(function (isValidUser) {
            if (isValidUser) {
                document.getElementById("userForm").submit(); // Nếu tất cả hợp lệ thì submit form
            }
        });
    }

    document.addEventListener("DOMContentLoaded", function () {
        const toastEl = document.getElementById('statusToast');
        const toastBody = document.getElementById('toastMessage');

        if (toastBody && toastBody.innerText.trim() !== "") {
            const toastIcon = document.getElementById('toastIcon');
            const toastTitle = document.getElementById('toastTitle');

            // Gán biểu tượng và tiêu đề động, nhưng nội dung là chính xác từ server
            toastEl.classList.add('toast-success');
            toastIcon.classList.add('bi-check-circle');
            toastTitle.textContent = 'Success';

            const bsToast = new bootstrap.Toast(toastEl);
            bsToast.show();
        }
    });

</script>
</html>
