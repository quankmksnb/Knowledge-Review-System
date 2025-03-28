<%@ page import="models.User" %><%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2/27/2025
  Time: 11:35 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page isELIgnored="false" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Class Update Management</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="CSS/Class/classUpdate.css">
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
                <div class="header-title">Class Management - ${oldClass.className}</div>
            </div>

            <div class="container mt-4">
                <div class="tab-container">
                    <ul class="nav nav-tabs" id="classTabs">
                        <li class="nav-item">
                            <a class="nav-link active" id="class-details-tab" data-bs-toggle="tab"
                               href="#classDetails">Class Details</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="student-list-tab" data-bs-toggle="tab"
                               href="#studentList">Student List</a>
                        </li>
                    </ul>

                    <div class="tab-content mt-3">
                        <div class="tab-pane fade show active" id="classDetails">
                            <div class="card border-0">
                                <div class="card-body">
                                    <form action="class_update_management" method="post">
                                        <!-- Thêm ID lớp vào form để gửi khi cập nhật -->
                                        <input type="hidden" name="classId" value="${oldClass.id}">

                                        <div class="row">
                                            <div class="col-md-6">
                                                <label class="form-label">Code</label>
                                                <input type="text" class="form-control" name="code"
                                                       value="${oldClass.code}" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Class Name</label>
                                                <input type="text" class="form-control" name="className"
                                                       value="${oldClass.className}" readonly>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Domain</label>
                                                <select class="form-select" id="domain" required onchange="updateSubjects()">
                                                    <c:forEach var="domain" items="${domainList}">
                                                        <option value="${domain.id}"
                                                                <c:if test="${domain.title == oldDomain}">selected</c:if>>${domain.title}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Subject</label>
                                                <select class="form-select" name="subject" id="subject" required onchange="syncDomain()">
                                                    <c:forEach var="subject" items="${subjectList}">
                                                        <option value="${subject.id}"
                                                                <c:if test="${subject.id == oldClass.subjectId}">selected</c:if>>${subject.code}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Teacher</label>
                                                <input type="text" class="form-control" name="teacher"
                                                       value="${oldManager}" required>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Status</label>
                                                <div class="form-control" style="padding: 8.5px">
                                                    <c:forEach var="statusOption" items="${statusOptions}">
                                                        <div class="form-check d-inline-block me-3">
                                                            <input class="form-check-input" type="radio" name="status" id="status${statusOption}" value="${statusOption}"
                                                                   <c:if test="${statusOption == oldClass.status}">checked</c:if>>
                                                            <label class="form-check-label" for="status${statusOption}">
                                                                    ${statusOption}
                                                            </label>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>

                                        </div>
                                        <button type="submit" class="btn btn-save mt-4">Update</button>
                                    </form>

                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="studentList">
                            <div class="card border-0">
                                <div class="card-body">

                                    <table class="table class-table">
                                        <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Avatar</th>
                                            <th>Name</th>
                                            <th>Email</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="student" items="${approvedStudents}">
                                            <tr>
                                                <td>${student.id}</td>
                                                <td>
                                                    <img src="https://chiemtaimobile.vn/images/companies/1/%E1%BA%A2nh%20Blog/avatar-facebook-dep/Anh-avatar-hoat-hinh-de-thuong-xinh-xan.jpg?1704788263223"
                                                         alt="Avatar" class="student-img">
                                                </td>
                                                <td>${student.fullName}</td>
                                                <td>${student.email}</td>
                                            </tr>
                                        </c:forEach>

                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>
</body>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        let selectedSubject = ${oldClass.subjectId};
        updateSubjects(selectedSubject);
    });

    function updateSubjects(selectedSubject = null) {
        let domainId = document.getElementById("domain").value;
        let subjectDropdown = document.getElementById("subject");
        subjectDropdown.innerHTML = '<option value="">Select Subject</option>';
        if (domainId !== "") {
            $.ajax({
                url: "/getSubjectsByDomain",
                type: "GET",
                data: {domainId: domainId},
                success: function (data) {
                    subjectDropdown.innerHTML += data;
                    if (selectedSubject) {
                        subjectDropdown.value = selectedSubject;
                    }
                },
                error: function (xhr) {
                    console.error("Error fetching subjects:", xhr);
                }
            });
        }
    }

    function syncDomain() {
        let domainDropdown = document.getElementById("domain");
        let subjectDropdown = document.getElementById("subject");
        let selectedSubject = subjectDropdown.value;
        if (selectedSubject !== "" && domainDropdown.value === "") {
            let subjectDomainId = subjectDropdown.options[subjectDropdown.selectedIndex].getAttribute("data-domain");
            domainDropdown.value = subjectDomainId;
            updateSubjects(selectedSubject);
        }
    }
</script>
</html>
