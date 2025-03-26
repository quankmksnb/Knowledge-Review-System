<%@ page import="models.Lesson" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Subject" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page isELIgnored="false" %>
<html>
<head>
    <title>Lesson Subject</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }

        .form-container {
            margin: 20px auto 40px;
            background-color: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 900px;
        }

        .form-control {
            background-color: #d9edf7;
            border: none;
            border-radius: 8px;
            padding: 10px;
        }

        .form-select {
            background-color: #d9edf7;
            border: none;
            border-radius: 8px;
            padding: 10px;
        }

        .btn-primary {
            background-color: blue;
            color: white;
            border-radius: 8px;
            padding: 10px 20px;
            border: none;
        }

        .btn-primary:hover {
            background-color: darkblue;
        }

        .row .col-md-6 {
            margin-bottom: 25px;
        }

        .form-check-input {
            margin-right: 10px;
        }

        .container-box {
            margin-bottom: 20px;
        }

        .nav-tabs .nav-link.active {
            font-weight: bold;
        }

        .no-config-message {
            text-align: center;
            padding: 30px;
            font-size: 18px;
            color: #555;
            margin-bottom: 20px;
        }

        .modal-header {
            background-color: #2f3b52;
            color: white;
            border-bottom: none;
        }

        .modal-body {
            background-color: #2f3b52;
            color: #ffffff;
        }

        .modal-footer {
            background-color: #2f3b52;

        }

        .popup {
            background-color: #3e4a67;
            color: whitesmoke;
            border: 1px solid #4d5b75;
            border-radius: 8px;
            padding: 0.8rem;
        }

        .popup:focus {
            background-color: #4a5b72;
            border-color: #007bff;
            color: whitesmoke;
        }

        .custom-toast {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }

        .toast-success {
            background-color: #d4edda;
            border-color: #c3e6cb;
        }

        .toast-success .toast-header {
            background-color: #28a745;
            color: white;
        }

        .toast-error {
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }

        .toast-error .toast-header {
            background-color: #dc3545;
            color: white;
        }
    </style>
</head>
<body>
<%
    Subject subject = (Subject) session.getAttribute("subject");
    String subjectName = subject.getSubjectName();
    int subjectId = subject.getId();
%>
<div class="container-fluid">
    <div class="row">
        <div class="col-auto px-0 sidebar d-none d-md-block">
            <div class="d-flex flex-column p-3">
                <h5 class="text-white mb-4">AdminKit</h5>
                <nav class="nav flex-column">
                    <a class="nav-link" href="/home"><i class="bi bi-house me-2"></i> Home</a>
                    <a class="nav-link" href="/user"><i class="bi bi-people me-2"></i> User</a>
                    <a class="nav-link" href="/subject"><i class="bi bi-book me-2"></i> Subject</a>
                    <a class="nav-link" href="/setting"><i class="bi bi-gear me-2"></i> Setting</a>
                </nav>
            </div>
        </div>

        <div class="col p-0">
            <div class="header-bar d-flex justify-content-between align-items-center px-4 bg-white shadow-sm py-3">
                <div class="header-title"><%= subjectName %> Management</div>
            </div>

            <div class="container mt-6">
                <div class="container-box">
                    <ul class="nav nav-tabs">
                        <li class="nav-item">
                            <a class="nav-link" href="subject?action=update&id=<%=subjectId%>">GENERAL</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="lesson_list?subjectId=<%=subjectId%>">LESSON</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="config">CONFIG</a>
                        </li>
                    </ul>
                </div>

                <div class="form-container">
                    <div class="header-bar d-flex justify-content-between align-items-center px-4 bg-white shadow-sm py-3">
                        Lesson of <%= subjectName %>
                        <!-- Nút Add Lesson căn bên phải -->
                        <a href="create_lesson?subjectId=${subject.id}" class="btn btn-primary float-end">
                            <i class="bi bi-plus-circle"></i> Add Lesson
                        </a>
                    </div>

                    <div class="table-responsive lesson-table">
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th style="width: 5%;">#</th>
                                <th>Title</th>
                                <th>Chapter</th>
                                <th style="width: 10%;">Action</th>
                            </tr>
                            </thead>
                            <tbody id="content">
                            <c:forEach var="lesson" items="${lessons}" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td>${lesson.title}</td>
                                    <td>
                                        <c:out value="${lessonChapters[lesson.id]}" default="N/A"/>
                                    </td>
                                    <td>
                                        <a href="update_lesson?id=${lesson.id}" class="text-primary">
                                            <i class="bi bi-pencil-square fs-5"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty lessons}">
                                <tr>
                                    <td colspan="4" class="text-center">No lessons found for this subject.</td>
                                </tr>
                            </c:if>
                            </tbody>

                        </table>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>