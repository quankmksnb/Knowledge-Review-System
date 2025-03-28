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
                    <div class="header-title">Settings Management</div>
<%--                    <div class="position-relative">--%>
<%--                        <i class="bi bi-search search-icon"></i>--%>
<%--                        <input oninput="searchClasses()" name="searchClassFilter" type="text" id="searchClassFilter"--%>
<%--                               class="form-control search-input" placeholder="Search class...">--%>
<%--                    </div>--%>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#newClassModal">
                        <i class="bi bi-plus-circle"></i> New Setting
                    </button>
                </div>

                <!-- Modal for New Settings -->
                <div class="modal fade" id="newClassModal" tabindex="-1" aria-labelledby="newClassModalLabel"
                     aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <form id="classForm" action="/add-setting" method="post">
                                <div class="modal-header d-flex align-items-center justify-content-between">
                                    <h3 class="modal-title" id="newClassModalLabel">Create New Settings</h3>
                                    <div class="d-flex align-items-center">
                                        <button type="button" class="btn-close ms-2" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                </div>
                                <div class="modal-body">
                                    <div class="row">
                                        <div class="col-md-12 mb-3">
                                            <label for="title" class="form-label">Title</label>
                                            <input type="text" class="form-control popup" id="title" name="title" required>
                                        </div>

                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="type" class="form-label">Type</label>
                                            <select class="form-select popup" id="type" name="type" required onchange="updateSubjects()">
                                                <option value="">Select Type</option>
                                                <c:forEach var="type" items="${settingTypes}">
                                                    <option value="${type}">${type}</option>
                                                </c:forEach>
                                            </select>
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

                <!-- Modal for Update settings -->
                <div class="modal fade" id="settingDetailModal" tabindex="-1" aria-labelledby="settingDetailModalLabel"
                     aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <form id="updateForm" action="javascript:void(0);" onsubmit="updateSetting()">
                                <div class="modal-header d-flex align-items-center justify-content-between">
                                    <h3 class="modal-title" id="settingDetailModalLabel">Settings Details</h3>
                                    <div class="d-flex align-items-center">
                                        <button type="button" class="btn-close ms-2" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                </div>
                                <div class="modal-body">
                                    <div class="row">
                                        <div class="col-md-12 mb-3">
                                            <label for="update-title" class="form-label">Title</label>
                                            <input type="text" class="form-control popup" id="update-title" name="update-title" value="" required>
                                        </div>

                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="update-type" class="form-label">Type</label>
                                            <select class="form-select popup" id="update-type" name="update-type" required>
                                                <option value="">Select Type</option>
                                                <c:forEach var="type" items="${settingTypes}">
                                                    <option value="${type}">${type}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <button type="submit" class="btn btn-primary w-100 py-2 rounded-3 shadow-sm mt-3">
                                        Update
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
                        <th>Id</th>
                        <th>Title</th>
                        <th>Type</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody id="content">
                    <c:forEach var="setting" items="${settings}">
                        <tr class="setting-id" data-id="${setting.id}">
                            <td>${setting.id}</td>
                            <td>${setting.title}</td>
                            <td>${setting.type}</td>
                            <td>
                                <a onclick="fetchSetting(${setting.id})" data-bs-toggle="modal" data-bs-target="#settingDetailModal"
                                   class="btn btn-sm action-btn" title="Edit">
                                    <i class="bi bi-pencil-square fs-5"></i>
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
    // // hiện thị thông báo
    // document.addEventListener("DOMContentLoaded", function () {
    //     let toastElement = document.getElementById("toastMessage");
    //     if (toastElement.innerText.trim() !== "") {
    //         let toast = new bootstrap.Toast(toastElement, {delay: 1500});
    //         toast.show();
    //     }
    // });

    document.addEventListener("DOMContentLoaded", function() {
        // Check if the message is not empty or null
        var message = "<%= message != null ? message : "" %>";

        if (message) {
            var toastElement = document.getElementById('toastMessage');
            var toast = new bootstrap.Toast(toastElement, {delay: 1500});
            toast.show();
        }
    });

    var currentSettingId;

    function fetchSetting(id) {
        // Make an AJAX request to fetch the setting data
        fetch('/get-setting?id=' + id)
            .then(response => response.json())  // Parse JSON response
            .then(data => {
                // Check if the data is valid and contains the expected fields
                if (data) {

                    console.log(data);

                    // Populate the modal fields with the data
                    document.getElementById('update-title').value = data.settingTitle;

                    // Set the selected value in the 'update-type' select dropdown
                    let selectElement = document.getElementById('update-type');

                    // Find the option that matches the fetched type
                    let option = Array.from(selectElement.options).find(option => option.value === data.settingType);

                    // Set the selected option if found
                    if (option) {
                        option.selected = true;
                    } else {
                        console.error('Type value not found in dropdown options:', data.settingType);
                    }
                    currentSettingId = data.settingId;
                    //
                    // // Optionally, trigger the modal to open if it's not already visible
                    // $('#settingDetailModal').modal('show');
                } else {
                    console.error('Invalid setting data received:', data);
                }
            })
            .catch(error => console.error('Error fetching setting:', error));
    }

    document.getElementById('updateForm').addEventListener('submit', function(event) {
        event.preventDefault();  // Prevent form submission
        updateSetting();  // Call the update function
    });

    function updateSetting() {
        // Get the values from the form
        const title = document.getElementById('update-title').value;
        const type = document.getElementById('update-type').value;

        // Validate if the values are not empty
        if (!title || !type) {
            alert("Please fill in all fields.");
            return;
        }

        // Create an object to hold the data
        const data = {
            title: title,
            type: type
        };

        // Make the AJAX request to update the setting
        fetch('/update-setting?id=' + currentSettingId + '&title=' + data.title + '&type=' + data.type, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
            .then(response => response.json())  // Assuming the server responds with JSON
            .then(data => {
                if (data.success) {
                    // Update was successful, close the modal
                    $('#settingDetailModal').modal('hide');

                    if (data.message) {
                        var messageElement = document.getElementById('toastMessage');
                        messageElement.querySelector('.toast-body').textContent = data.message; // Set the message dynamically

                        var toastElement = document.getElementById('toastMessage');
                        var toast = new bootstrap.Toast(toastElement, {delay: 1500});
                        toast.show();
                    }

                    window.location.reload();
                } else {
                    // Handle error if the update was not successful

                    if (data.message) {
                        var messageElement = document.getElementById('toastMessage');
                        messageElement.querySelector('.toast-body').textContent = data.message; // Set the message dynamically

                        var toastElement = document.getElementById('toastMessage');
                        var toast = new bootstrap.Toast(toastElement, {delay: 1500});
                        toast.show();
                    }
                    //alert('Failed to update settings: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error updating settings:', error);
                alert('An error occurred while updating settings.');
            });
    }

</script>
</html>