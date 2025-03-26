<%@ page import="models.dao.DTOSubject" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: PC
  Date: 3/17/2025
  Time: 8:56 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Choose Subject</title>
</head>
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

    .subject-table {
        margin: 20px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .subject-table th, .subject-table td {
        text-align: center;
        padding: 15px;
        border: none;
    }

    .subject-table th {
        background-color: #f8f9fa;
        font-weight: bold;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }

    .subject-table tr:nth-child(even) {
        background-color: #f9f9f9;
    }

    .subject-table tr:hover {
        background-color: #eef1f5;
    }

    .focus {
        background-color: #4a5b72;
        border-color: #007bff;
        color: whitesmoke;
    }




</style>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
      integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<!-- Bootstrap Icons -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
      rel="stylesheet">
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-auto px-0 sidebar d-none d-md-block">
            <div class="d-flex flex-column p-3">
                <h5 class="text-white mb-4">AdminKit</h5>
                <nav class="nav flex-column">
                    <a class="nav-link" href="/home"><i class="bi bi-house"></i> Home</a>
                    <a class="nav-link" href="/user"><i class="bi bi-person-circle"></i> User</a>
                    <a class="nav-link" href="/subject"><i class="bi bi-book"></i> Subject</a>
                    <a class="nav-link" href="/class_management"><i class="bi bi-people"></i> Class</a>
                    <a class="nav-link" href="/setting"><i class="bi bi-gear"></i> Setting</a>
                    <a class="nav-link" href="question?action=choose"><i class="bi bi-question-octagon"></i>Question</a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col p-0">
            <!-- Header Bar -->
            <div class="header-bar d-flex justify-content-between align-items-center px-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="header-title">Choose the subject</div>
                    <div class="position-relative">
                        <i class="bi bi-search search-icon"></i>
                        <input type="text" id="searchInput" class="form-control search-input"
                               placeholder="Search subjects...">
                    </div>

                </div>
            </div>
            <!-- Subject Table -->
            <div class="table-responsive subject-table">
                <table class="table">
                    <thead>
                    <tr>

                        <th>Code</th>
                        <th>Name</th>
                        <th>Domain</th>

                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% List<DTOSubject> subjects = (List<DTOSubject>) request.getAttribute("list");
                        if (subjects != null) {
                            for (DTOSubject s : subjects) { %>
                    <tr>

                        <td><%= s.getCode() %>
                        </td>
                        <td><%= s.getName() %>
                        </td>
                        <td><%= s.getDomain() %>
                        </td>



                        <td>
                            <div class="btn-group">
                                <a href="question?action=choose&subjectId=<%= s.getId() %>" class="btn btn-sm btn-primary">
                                    <i class="bi bi-search"></i>
                                </a>

                            </div>
                        </td>
                    </tr>
                    <% }
                    } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<style>
    footer {
        position: relative;
    }
</style>
</body>
</html>
