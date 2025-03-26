<%@ page import="models.Config" %>
<%@ page import="models.Setting" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: PC
  Date: 3/19/2025
  Time: 9:03 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
      rel="stylesheet">
<html>
<head>
    <title>Title</title>
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
</style>

<body>
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
        <%Config configUpdate = (Config) request.getAttribute("config");
            List<Setting> settingTypes = (List<Setting>) request.getAttribute("settingTypes");
        %>
        <!-- Main Content -->
        <div class="col p-0">
            <!-- Header -->
            <div class="header-bar d-flex justify-content-between align-items-center px-4 bg-white shadow-sm py-3">
                <div class="header-title">Config Management</div>
            </div>

                <!-- Subject Information Section -->
                <div class="container">



                    <div class="form-container">
                        <form action="config" method="POST" id="updateConfigForm">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="<%=configUpdate.getId()%>">

                            <div class="mb-3 col-md-6">
                                <label for="updateConfigType" class="form-label">Configuration Type</label>
                                <select class="form-select" id="updateConfigType" name="typeId" required>
                                    <option value="" selected disabled>Select a configuration type</option>
                                    <% if (settingTypes != null) {
                                        for (Setting setting : settingTypes) { %>
                                    <option value="<%= setting.getId() %>" <%=configUpdate.getTypeId() == setting.getId() ? "selected" : ""%>><%= setting.getTitle() %>
                                    </option>
                                    <% }
                                    } %>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="updateConfigDescription" class="form-label">Description</label>
                                <textarea class="form-control" id="updateConfigDescription" name="description" rows="6" required><%=configUpdate.getDescription()%></textarea>
                            </div>
                            <div class="mt-2">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="status" id="statusActive"
                                           value="Active" <%=(configUpdate.getStatus().equals("Active")) ? "checked" : ""%>>
                                    <label class="form-check-label" for="statusActive">Active</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="status" id="statusInactive"
                                           value="Inactive" <%=(configUpdate.getStatus().equals("Inactive")) ? "checked" : ""%>>
                                    <label class="form-check-label" for="statusInactive">Inactive</label>
                                </div>
                            </div>
                            <div class="text-end">
                                <input type="submit" name="submit" value="Change" class="btn-primary">
                            </div>
                        </form>

                    </div>
                </div>
            </div>


        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
