<%@ page import="models.User" %><%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2/25/2025
  Time: 12:27 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page isELIgnored="false" %>
<html>
<head>
    <title>Class</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <link href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="CSS/Class/classList.css">
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


        <!-- Main Content -->
        <div class="col p-0">
            <!-- Header Bar -->
            <div class="header-bar d-flex justify-content-between align-items-center px-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="header-title">Class Management</div>
                    <div class="position-relative">
                        <i class="bi bi-search search-icon"></i>
                        <input oninput="searchClasses()" name="searchClassFilter" type="text" id="searchClassFilter"
                               class="form-control search-input" placeholder="Search class...">
                    </div>
                    <div>
                        <select onchange="searchClasses()" class="form-select" id="semesterFilter"
                                name="semesterFilter">
                            <c:forEach var="semester" items="${semesterList}">
                                <option value="${semester.id}">${semester.title}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <select onchange="searchClasses()" class="form-select" id="domainFilter" name="domainFilter">
                            <option value="">Domain</option>
                            <c:forEach var="domain" items="${domainList}">
                                <option value="${domain.id}">${domain.title}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <select onchange="searchClasses()" class="form-select" id="statusFilter" name="statusFilter">
                            <option value="">All Status</option>
                            <option value="Public">Public</option>
                            <option value="Private">Private</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <a href="class_management/export" id="exportBtn" class="btn btn-success">
                        <i class="bi bi-download"></i> Export File
                    </a>
                    <button type="button" class="btn btn-primary shadow-sm" data-bs-toggle="modal"
                            data-bs-target="#newClassModal">
                        <i class="bi bi-plus-circle"></i> New Class
                    </button>
                </div>

                <!-- Modal for New Class -->
                <div class="modal fade" id="newClassModal" tabindex="-1" aria-labelledby="newClassModalLabel"
                     aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <form id="classForm" action="/class_management" method="post">
                                <div class="modal-header d-flex align-items-center justify-content-between">
                                    <h3 class="modal-title" id="newClassModalLabel">Create New Class</h3>
                                    <div class="d-flex align-items-center">
                                        <label for="semester" class="form-label me-2 mb-0 text-white">Semester:</label>
                                        <select class="form-select popup small-dropdown" id="semester" name="semester"
                                                required>
                                            <c:forEach var="semester" items="${semesterList}">
                                                <option value="${semester.id}">${semester.title}</option>
                                            </c:forEach>
                                        </select>
                                        <button type="button" class="btn-close ms-2" data-bs-dismiss="modal"
                                                aria-label="Close"></button>
                                    </div>
                                </div>
                                <div class="modal-body">
                                    <div class="row">
                                        <div class="col-md-12 mb-3">
                                            <label for="code" class="form-label">Code</label>
                                            <input type="text" class="form-control popup" id="code" name="code"
                                                   required>
                                        </div>

                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="domain" class="form-label">Domain</label>
                                            <select class="form-select popup" id="domain" name="domain" required
                                                    onchange="updateSubjects()">
                                                <option value="">Select Domain</option>
                                                <c:forEach var="domain" items="${domainList}">
                                                    <option value="${domain.id}">${domain.title}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="col-md-6 mb-3">
                                            <label for="subject" class="form-label">Subject</label>
                                            <select class="form-select popup" id="subject" name="subject" required
                                                    onchange="syncDomain()">
                                                <option value="">Select Subject</option>
                                                <c:forEach var="subject" items="${subjectList}">
                                                    <option value="${subject.id}"
                                                            data-domain="${subject.domainId}">${subject.code}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="manager" class="form-label">Teacher</label>
                                            <input type="text" class="form-control popup" id="manager" name="manager"
                                                   required>
                                            <small id="managerError" class="text-danger ms-2"
                                                   style="display:none;"></small>
                                        </div>

                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">Status</label>
                                            <div class="popup">
                                                <div class="form-check d-inline-block me-3">
                                                    <input class="form-check-input" type="radio" name="status"
                                                           id="statusPublic" value="Public" checked>
                                                    <label class="form-check-label" for="statusPublic">
                                                        Public
                                                    </label>
                                                </div>
                                                <div class="form-check d-inline-block">
                                                    <input class="form-check-input" type="radio" name="status"
                                                           id="statusPrivate" value="Private">
                                                    <label class="form-check-label" for="statusPrivate">
                                                        Private
                                                    </label>
                                                </div>
                                            </div>
                                        </div>

                                    </div>

                                    <button type="submit" class="btn btn-primary w-100 py-2 rounded-3 shadow-sm mt-3">
                                        Create
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Class Table -->
            <div class="table-responsive class-table">
                <table class="table">
                    <thead>
                    <tr>
                        <th>Code</th>
                        <th>Class name</th>
                        <th>Domain</th>
                        <th>Subject</th>
                        <th>Teacher</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody id="content">
                    <c:forEach var="cls" items="${classList}">
                        <tr>
                            <td>${cls.code}</td>
                            <td>${cls.className}</td>
                            <td>${domainMap[cls.subjectId]}</td>
                            <td>${subjectCodeMap[cls.subjectId]}</td>
                            <td>${managerUsernameMap[cls.managerId]}</td>
                            <td>
                                <span id="status-${cls.id}" class="badge
                                    <c:choose>
                                        <c:when test="${cls.status == 'Public'}">bg-success</c:when>
                                        <c:when test="${cls.status == 'Private'}">bg-info</c:when>
                                        <c:otherwise>bg-danger</c:otherwise>
                                    </c:choose>
                                ">${cls.status}</span>
                            </td>

                            <td>
                                <a href="class_update_management?classId=${cls.id}"
                                   class="btn btn-sm action-btn" title="Edit">
                                    <i class="bi bi-pencil-square fs-5"></i>
                                </a>

                                <!-- Icon khóa/mở khóa -->
                                <a href="javascript:void(0);" class="btn btn-sm action-btn" title="Toggle Status"
                                   onclick="toggleStatus(${cls.id})">
                                    <i id="lock-icon-${cls.id}" class="bi
                                        <c:choose>
                                            <c:when test="${cls.status == 'Private'}">bi-lock-fill text-info</c:when>
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

            <div class="pagination">
                <%
                    // Lấy giá trị currentPage và totalPages từ request
                    int currentPage = (int) request.getAttribute("currentPage");
                    int totalPages = (int) request.getAttribute("totalPages");

                    if (totalPages > 1) {
                %>
                <a href="?page=<%= Math.max(1, currentPage - 1) %>"
                   class="pagination-item <%= currentPage == 1 ? "disabled" : "" %>">
                    <i class="fas fa-chevron-left"></i>
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
                    <i class="fas fa-chevron-right"></i>
                </a>
                <% } %>
            </div>


        </div>
    </div>


</body>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>
<script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
<script>
    // hiện thị thông báo
    document.addEventListener("DOMContentLoaded", function () {
        let toastElement = document.getElementById("toastMessage");
        if (toastElement.innerText.trim() !== "") {
            let toast = new bootstrap.Toast(toastElement, {delay: 1500});
            toast.show();
        }
    });

    function updateSubjects(selectedSubject = null) {
        let domainId = document.getElementById("domain").value;
        let subjectDropdown = document.getElementById("subject");

        // Xóa hết option cũ trong Subject trước khi cập nhật
        subjectDropdown.innerHTML = '<option value="">Select Subject</option>';

        if (domainId !== "") {
            $.ajax({
                url: "/getSubjectsByDomain",
                type: "GET",
                data: {domainId: domainId},
                success: function (data) {
                    subjectDropdown.innerHTML += data;

                    // Giữ lại Subject đã chọn nếu có
                    if (selectedSubject) {
                        subjectDropdown.value = selectedSubject;
                    }
                },
                error: function (xhr) {
                    console.error("Error fetching subjects:", xhr);
                }
            });
        } else {
            $.ajax({
                url: "/getSubjectsByDomain",
                type: "GET",
                success: function (data) {
                    subjectDropdown.innerHTML += data;

                    // Giữ lại Subject đã chọn nếu có
                    if (selectedSubject) {
                        subjectDropdown.value = selectedSubject;
                    }
                },
                error: function (xhr) {
                    console.error("Error fetching all subjects:", xhr);
                }
            });
        }
    }

    function syncDomain() {
        let domainDropdown = document.getElementById("domain");
        let subjectDropdown = document.getElementById("subject");
        let selectedSubject = subjectDropdown.value; // Lưu lại Subject đã chọn

        if (selectedSubject !== "" && domainDropdown.value === "") {
            let subjectDomainId = subjectDropdown.options[subjectDropdown.selectedIndex].getAttribute("data-domain");
            domainDropdown.value = subjectDomainId;

            // Gọi updateSubjects() để cập nhật danh sách Subject của Domain mới
            updateSubjects(selectedSubject);
        }
    }

    function searchClasses() {
        let searchQuery = document.getElementById("searchClassFilter").value.trim();
        let semesterId = document.getElementById("semesterFilter").value;
        let domainId = document.getElementById("domainFilter").value;
        let status = document.getElementById("statusFilter").value;

        $.ajax({
            url: "/class_management/search",
            type: "GET",
            data: {
                searchClassFilter: searchQuery,
                semesterFilter: semesterId,
                domainFilter: domainId,
                statusFilter: status
            },
            success: function (data) {
                document.getElementById("content").innerHTML = data;
            },
            error: function (xhr) {
                console.error("Lỗi khi lọc lớp học:", xhr);
            }
        });
    }

    document.addEventListener("DOMContentLoaded", function () {
        document.getElementById("manager").addEventListener("input", checkManagerRole);
        document.getElementById("classForm").addEventListener("submit", function (event) {
            event.preventDefault(); // Ngừng việc submit form
            validateAndSubmitForm();
        });
    });

    function checkManagerRole(callback) {
        let manager = document.getElementById("manager").value.trim();  // Lấy giá trị từ trường "manager"

        $.ajax({
            url: "/user/checkManagerRole",  // Đường dẫn tới servlet kiểm tra vai trò của manager
            type: "get",  // Phương thức GET
            data: {manager: manager},  // Gửi dữ liệu (manager) tới server
            success: function (data) {
                let managerError = document.getElementById("managerError");

                managerError.innerHTML = "";  // Reset error message
                managerError.style.display = "none";  // Ẩn thông báo lỗi

                let hasError = false;

                if (data.includes("Manager must be a teacher.")) {
                    managerError.innerHTML = "Manager must be a teacher.";  // Hiển thị lỗi
                    managerError.style.display = "block";  // Hiển thị thông báo lỗi
                    hasError = true;
                }

                // Gọi callback để tiếp tục xử lý sau khi kiểm tra xong
                if (callback) {
                    callback(!hasError);  // Trả về true nếu không có lỗi, false nếu có lỗi
                }
            },
            error: function (xhr) {
                console.error("Error checking manager role:", xhr);
                if (callback) {
                    callback(false);  // Trả về false khi có lỗi
                }
            }
        });
    }

    function validateAndSubmitForm() {
        checkManagerRole(function (isValidManager) {
            if (isValidManager) {
                document.getElementById("classForm").submit(); // Nếu hợp lệ thì submit form
            }
        });
    }

    function toggleStatus(classId) {
        if (!confirm("Bạn có chắc chắn muốn thay đổi trạng thái lớp học này?")) return;

        $.ajax({
            url: "/class_management/toggleStatus",
            type: "POST",
            data: {classId: classId},
            dataType: "json",
            success: function (response) {
                let statusSpan = $("#status-" + classId); // Lấy phần tử chứa trạng thái
                let icon = $("#lock-icon-" + classId); // Lấy biểu tượng khóa/mở khóa

                // Cập nhật trạng thái text trong bảng
                statusSpan.text(response.newStatus);
                statusSpan.removeClass("bg-success bg-info bg-secondary")
                    .addClass("bg-" + response.statusClass); // Cập nhật màu sắc cho trạng thái

                // Cập nhật icon khóa/mở khóa
                if (response.newStatus === "Private") {
                    icon.removeClass("bi-unlock-fill text-success")
                        .addClass("bi-lock-fill text-info");
                } else {
                    icon.removeClass("bi-lock-fill text-info")
                        .addClass("bi-unlock-fill text-success");
                }

                console.log("Class ID: " + classId + " -> Updated to: " + response.newStatus);
            },
            error: function () {
                alert("Có lỗi xảy ra, vui lòng thử lại!");
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
