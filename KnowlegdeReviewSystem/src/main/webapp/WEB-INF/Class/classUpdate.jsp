<%--
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

        .tab-container {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .nav-tabs .nav-link {
            border: none;
            color: #333;
        }

        .nav-tabs .nav-link.active {
            background-color: #4c5a9c;
            color: white;
            border-radius: 10px 10px 0 0;
        }

        .class-table {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .class-table th,
        .class-table td {
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

        .form-control {
            background-color: #d9edf7;
            border: none;
            border-radius: 8px;
            padding: 10px;
        }

        .btn-save {
            background-color: #9370DB;
            color: white;
            border-radius: 8px;
            padding: 10px 15px;
            border: none;
        }

        .btn-save:hover {
            background-color: #7B68EE;
            color: white;
        }

        .row .col-md-6 {
            margin-bottom: 25px;
        }

        .student-img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 1px solid #ddd;
            display: block;
            margin: auto;
        }
    </style>
</head>

<body>

<div class="container-fluid">
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
                                                <label class="form-label">Manager</label>
                                                <input type="text" class="form-control" name="manager"
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
