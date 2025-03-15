<%--
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
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">

    <style>
        body {
            background-color: #f4f6f9;
        }

        .sidebar {
            background-color: #1a1f36;
            min-height: 100vh;
        }

        .sidebar .nav-link {
            color: #8b92a8;
            padding: 0.8rem 1rem;
            margin: 0.2rem 0;
            border-radius: 6px;
        }

        .sidebar .nav-link:hover {
            background-color: #2d3548;
            color: #fff;
        }

        .header-bar {
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 15px;
        }

        .header-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }

        .search-input {
            background-color: #f8f9fa;
            border: none;
            padding-left: 2.5rem;
            border-radius: 8px;
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }

        .class-table {
            margin: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .class-table th, .class-table td {
            text-align: center;
            padding: 15px;
            border: none;
        }

        .class-table th {
            background-color: #f8f9fa;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .class-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .class-table tr:hover {
            background-color: #eef1f5;
        }

        .btn-primary {
            border-radius: 8px;
        }

        .btn-success {
            border-radius: 8px;
        }

        .modal-content {
            background-color: #2f3b52; /* Màu nền tối */
            border-radius: 12px; /* Cạnh bo tròn */
            padding: 30px;
        }

        .modal-header {
            background-color: #2f3b52; /* Màu nền header tối */
            color: white;
            border-bottom: none;
        }

        .modal-header .btn-close {
            background-color: white;
            border-radius: 100%;
            color: white;
        }

        .modal-header .btn-close:hover {
            color: #0056b3; /* Màu khi hover */
        }

        .modal-body {
            background-color: #2f3b52;
            color: #ffffff;
        }


        .popup {
            background-color: #3e4a67; /* Nền các input */
            color: white;
            border: 1px solid #4d5b75; /* Viền nhẹ */
            border-radius: 8px;
            padding: 0.8rem;
        }

        .popup:focus {
            background-color: #4a5b72; /* Nền khi focus */
            border-color: #007bff;
            color: white;
        }

        .btn-primary {
            background-color: #007bff; /* Màu nút chính */
            border-color: #007bff;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #004085;
        }

        .text-danger {
            color: #ff4d4d;
        }

        input, select {
            border-radius: 8px;
        }

        .small-dropdown {
            width: 120px;
            height: 30px;
            font-size: 14px;
            padding: 2px 8px;
        }

    </style>
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
        <div class="col-auto px-0 sidebar d-none d-md-block">
            <div class="d-flex flex-column p-3">
                <h5 class="text-white mb-4">AdminKit</h5>
                <nav class="nav flex-column">
                    <a class="nav-link" href="/home"><i class="bi bi-house"></i> Home</a>
                    <a class="nav-link" href="/user"><i class="bi bi-person-circle"></i> User</a>
                    <a class="nav-link" href="/subject"><i class="bi bi-book"></i> Subject</a>
                    <a class="nav-link" href="/class_management"><i class="bi bi-people"></i> Class</a>
                    <a class="nav-link" href="/setting"><i class="bi bi-gear"></i> Setting</a>
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
                                            <span id="managerError" class="text-danger ms-2"
                                                  style="display:none;"></span>
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
        </div>
    </div>
</div>


</body>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>
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


</script>
</html>
