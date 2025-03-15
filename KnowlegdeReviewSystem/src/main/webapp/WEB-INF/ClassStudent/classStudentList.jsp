<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2/26/2025
  Time: 12:07 AM
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

        .container-box {
            background-color: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .table thead {
            background-color: #f8f9fa;
        }

        .btn-custom {
            border-radius: 8px;
        }

        .search-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .nav-tabs .nav-item .nav-link.active {
            border-bottom: 2px solid black;
            font-weight: bold;
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
                    <a class="nav-link" href="/class_student"><i class="bi bi-people me-2"></i> Class</a>
                </nav>
            </div>
        </div>


        <div class="col p-0">
            <div class="header-bar d-flex justify-content-between align-items-center px-4 bg-white shadow-sm py-3">
                <div class="header-title">Class Management</div>
            </div>
            <div class="container mt-4">
                <div class="container-box">
                    <ul class="nav nav-tabs">
                        <li class="nav-item">
                            <a class="nav-link active" href="class">CLASS</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">STUDENT</a>
                        </li>
                    </ul>
                    <div class="search-container mt-3">
                        <div class="d-flex gap-2">
                            <div>
                                <select onchange="searchUsers()" class="form-select" id="roleFilter" name="roleFilter">
                                    <option value="">Spring 2025</option>
                                    <option value="">Fall 2024</option>
                                </select>
                            </div>
                            <div class="position-relative ms-3">
                                <i class="bi bi-search search-icon"></i>
                                <input oninput="" name="" type="text"
                                       class="form-control search-input" placeholder="Search class...">
                            </div>
                        </div>
                        <div class="d-flex gap-2">
                            <button class="btn btn-success btn-custom"><i class="bi bi-download"></i> Export file
                            </button>
                            <button class="btn btn-primary btn-custom"><i class="bi bi-plus-circle"></i> New class
                            </button>
                        </div>
                    </div>

                    <!-- Class Table -->
                    <div class="table-responsive class-table">
                        <table class="table">
                            <thead>
                            <tr>
                                <th>Code</th>
                                <th>Class name</th>
                                <th>Subject</th>
                                <th>Manager</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                            </thead>
                            <tbody id="content">
                            <tr>
                                <td>SE1870-NJ</td>
                                <td>Class 1870-NodeJs</td>
                                <td>SWP391</td>
                                <td>PhucNT</td>
                                <td>
                                    <span class="badge bg-success">Public</span>
                                </td>
                                <td>
                                    <a href="#"
                                       class="btn btn-sm btn-outline-secondary">
                                        <i class="bi bi-three-dots-vertical"></i>
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <td>SE1811-NJ</td>
                                <td>Class 1811-NodeJs</td>
                                <td>FER202</td>
                                <td>HuyLQ</td>
                                <td>
                                    <span class="badge bg-danger">Private</span>
                                </td>
                                <td>
                                    <a href="#"
                                       class="btn btn-sm btn-outline-secondary">
                                        <i class="bi bi-three-dots-vertical"></i>
                                    </a>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>

</html>
