<%@ page import="models.User" %><%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/3/2025
  Time: 1:26 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page isELIgnored="false" %>
<html>
<head>
    <title>Class Teacher</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="CSS/ClassStudent/classTeacherList.css">
</head>
<body>

<div class="container-fluid">
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
                    <div class="header-title">My Class</div>
                </div>

            </div>
            <div class="semester-container px-4">
                <select id="semesterFilter" name="semesterId" class="form-select" onchange="filterClassesBySemester()">
                    <c:forEach var="semester" items="${semesters}">
                        <option value="${semester.id}">${semester.title}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Container chứa danh sách lớp -->
            <div id="classContainer" class="card-container px-4">
                <c:forEach var="classList" items="${teacherClasses}">
                    <div class="card">
                        <h3>${subjectCodeMap[classList.id]}</h3>
                        <h5>Class: ${classList.code}</h5>
                        <p>${subjectNameMap[classList.id]}</p>
                        <!-- Hiển thị trạng thái với màu sắc và icon -->
                        <p>
                            <c:choose>
                                <c:when test="${classList.status eq 'Public'}">
                        <span class="badge bg-success">
                            <i class="bi bi-unlock"></i> View: Public
                        </span>
                                </c:when>
                                <c:when test="${classList.status eq 'Private'}">
                        <span class="badge bg-dark">
                            <i class="bi bi-lock"></i> View: Private
                        </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">${classList.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <div style="display: flex; justify-content: space-between; margin-top: 10px;">
                            <a href="class_student_detail?classId=${classList.id}">View Students</a>
                            <a href="class-details?class-id=${classList.id}">View Details</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

    </div>
</div>

</body>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>
<script>
    function filterClassesBySemester() {
        let semesterId = document.getElementById("semesterFilter").value;

        $.ajax({
            url: "/filter_class_by_semester",
            type: "GET",
            data: { semesterId: semesterId },
            success: function (response) {
                $("#classContainer").html(response); // Cập nhật container bằng dữ liệu từ server
            },
            error: function () {
                alert("Failed to load classes. Please try again.");
            }
        });
    }

</script>
</html>
