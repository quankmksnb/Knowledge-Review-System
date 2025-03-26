<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page import="models.DTOConfig" %>
<%@ page import="models.Setting" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Subject" %>
<%@ page isELIgnored="false" %>

<html>
<head>
    <title>Subject Configuration</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
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
            display: flex;
            justify-content: space-between;
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
        .config-table {
            margin: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .config-table th, .config-table td {
            text-align: center;
            padding: 15px;
            border: none;
        }

        .config-table th {
            background-color: #f8f9fa;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .config-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .config-table tr:hover {
            background-color: #eef1f5;
        }
    </style>
</head>

<body>
<%
    List<DTOConfig> dtoConfig = (List<DTOConfig>) request.getAttribute("dtoConfigList");
    Subject subject = (Subject) session.getAttribute("subject");
    List<Setting> settingTypes = (List<Setting>) request.getAttribute("settingTypes");
    String subjectName = subject.getSubjectName();
    int subjectId = subject.getId();


%>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
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

        <!-- Main Content -->
        <div class="col p-0">
            <!-- Header -->
            <div class="header-bar d-flex justify-content-between align-items-center px-4 bg-white shadow-sm py-3">
                <div class="header-title"><%= subjectName %> Management</div>
            </div>
            <div class="toast-container">
                <div id="statusToast" class="toast custom-toast" role="alert" aria-live="assertive" aria-atomic="true"
                     data-bs-delay="1500">
                    <div class="toast-header">
                        <i class="bi me-2" id="toastIcon"></i>
                        <strong class="me-auto" id="toastTitle"></strong>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"
                                aria-label="Close"></button>
                    </div>
                    <div class="toast-body" id="toastMessage"></div>
                </div>
            </div>
            <!-- Navigation Tabs -->
            <div class="container mt-6">
                <div class="container-box">
                    <ul class="nav nav-tabs">
                        <li class="nav-item">
                            <a class="nav-link" href="subject?action=update&id=<%=subjectId%>">GENERAL</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="subject?action=getLesson&id=<%=subject.getId()%>">LESSON</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="config">CONFIG</a>
                        </li>
                    </ul>
                </div>

                <!-- Subject Configuration Section -->
                <div class="container">
                        <div class="header-bar">
                            <h3>Config of <%= subjectName %></h3>
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                                    data-bs-target="#createConfigModal">
                                Create Config
                            </button>
                        </div>

                        <%if (dtoConfig != null && !dtoConfig.isEmpty()) {
                            %>
                        <div class="table-responsive config-table">
                            <table class = "table">
                                <thead>
                                <tr>
                                    <th>Type</th>
                                    <th>Description</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%for (DTOConfig configSubject : dtoConfig) {%>
                                <tr>
                                    <td>
                                        <%=configSubject.getType()%>
                                    </td>
                                    <td>
                                        <%=configSubject.getDescription()%>
                                    </td>
                                    <td>
                                        <% if (configSubject.getStatus().equals("Active")) { %>
                                        <span class="badge bg-success">Active</span>
                                        <% } else { %>
                                        <span class="badge bg-danger">Inactive</span>
                                        <% } %>
                                    </td>
                                    <td>
                                       <div>
                                           <a href="config?action=changeStatus&id=<%= configSubject.getId() %>&status=<%= configSubject.getStatus() %>"
                                              class="btn btn-sm <%= configSubject.getStatus().equals("Active") ? "btn-danger" : "btn-success" %>">
                                               <i class="bi <%= configSubject.getStatus().equals("Active") ? "bi-x-circle" : "bi-check-circle" %>"></i>
                                           </a>
                                           <a href="config?action=update&id=<%=configSubject.getId()%>"
                                              class="btn btn-sm btn-primary">
                                               <i class="bi bi-pen"></i>
                                           </a>

                                       </div>
                                    </td>
                                </tr>
                                <%}%>
                                </tbody>
                            </table>
                        </div>




                        <%}  else { %>
                        <div class="no-config-message">
                            <p>Subject haven't configured</p>
                        </div>
                        <% } %>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal để tạo config mới -->
<div class="modal fade" id="createConfigModal" tabindex="-1" aria-labelledby="createConfigModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="createConfigModalLabel">Create New Configuration</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="config" method="POST" id="createConfigForm">
                    <input type="hidden" name="action" value="create">

                    <div class="mb-3 col-md-6" >
                        <label for="configType" class="form-label">Configuration Type</label>
                        <select class="form-select" id="configType" name="typeId" required>
                            <option value="" selected disabled>Select a configuration type</option>
                            <% if (settingTypes != null) {
                                for (Setting setting : settingTypes) { %>
                            <option value="<%= setting.getId() %>"><%= setting.getTitle() %>
                            </option>
                            <% }
                            } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="configDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="configDescription" name="description" rows="6" required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="createConfigForm" class="btn btn-primary">Create</button>
            </div>
        </div>
    </div>
</div>


<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Get status parameter from URL
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status');
        // Show toast if status parameter exists
        if (status) {
            showToast(status);
        }

        // Function to show toast
        function showToast(status) {
            const toast = document.getElementById('statusToast');
            const toastIcon = document.getElementById('toastIcon');
            const toastTitle = document.getElementById('toastTitle');
            const toastMessage = document.getElementById('toastMessage');

            if (status === 'success') {
                toast.classList.add('toast-success');
                toastIcon.classList.add('bi-check-circle');
                toastTitle.textContent = 'Success';
                toastMessage.textContent = 'Operation completed successfully!';
            } else if (status === 'unsuccess') {
                toast.classList.add('toast-error');
                toastIcon.classList.add('bi-x-circle');
                toastTitle.textContent = 'Error';
                toastMessage.textContent = 'Operation failed. Please try again.';
            }

            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
        }
    });


</script>
</body>
</html>