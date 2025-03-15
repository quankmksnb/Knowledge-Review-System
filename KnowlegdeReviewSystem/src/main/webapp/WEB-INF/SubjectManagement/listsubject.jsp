<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="models.Subject" %>
<%@ page import="java.util.List" %>
<%@ page import="models.dao.DTOSubject" %>
<html>
<head>
    <title>Subject Management</title>
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

        .modal-content {
            background-color: #2f3b52;
            border-radius: 12px;
            padding: 30px;
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

        .popup {
            background-color: #3e4a67;
            color: white;
            border: 1px solid #4d5b75;
            border-radius: 8px;
            padding: 0.8rem;
        }

        .popup:focus {
            background-color: #4a5b72;
            border-color: #007bff;
            color: white;
        }
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1060;
        }

        .custom-toast {
            min-width: 250px;
        }

        .toast-success {
            background-color: #198754;
            color: white;
        }

        .toast-error {
            background-color: #dc3545;
            color: white;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-auto px-0 sidebar d-none d-md-block">
            <div class="d-flex flex-column p-3">
                <h5 class="text-white mb-4">AdminKit</h5>
                <nav class="nav flex-column">
                    <a class="nav-link" href="/home"><i class="bi bi-house"></i> Home</a>
                    <a class="nav-link" href="/user"><i class="bi bi-people me-2"></i> User</a>
                    <a class="nav-link" href="/subject"><i class="bi bi-book"></i> Subject</a>
                    <a class="nav-link" href="/setting"><i class="bi bi-gear"></i> Setting</a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col p-0">
            <!-- Header Bar -->
            <div class="header-bar d-flex justify-content-between align-items-center px-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="header-title">Subject Management</div>
                    <div class="position-relative">
                        <i class="bi bi-search search-icon"></i>
                        <input type="text" id="searchInput" class="form-control search-input"
                               placeholder="Search subjects...">
                    </div>
                    <div class="ms-3">
                        <select name="domain" id="domain" class="form-select">
                            <option value="all">All Domains</option>
                            <% HashMap<Integer, String> map = (HashMap<Integer, String>) request.getAttribute("map");
                                for (HashMap.Entry<Integer, String> entry : map.entrySet()) { %>
                            <option value="<%= entry.getKey() %>"><%= entry.getValue() %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                </div>
                <div>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                            data-bs-target="#newSubjectModal">
                        <i class="bi bi-plus-circle"></i> New Subject
                    </button>
                </div>
            </div>
            <div class="toast-container">
                <div id="statusToast" class="toast custom-toast" role="alert" aria-live="assertive" aria-atomic="true" data-bs-delay="1500">
                    <div class="toast-header">
                        <i class="bi me-2" id="toastIcon"></i>
                        <strong class="me-auto" id="toastTitle"></strong>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                    <div class="toast-body" id="toastMessage"></div>
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

                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% List<DTOSubject> subjects = (List<DTOSubject>) request.getAttribute("subjects");
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
                            <% if (s.isStatus()) { %>
                            <span class="badge bg-success">Active</span>
                            <% } else { %>
                            <span class="badge bg-danger">Inactive</span>
                            <% } %>
                        </td>

                        <td>
                            <div class="btn-group">
                                <a href="subject?action=update&id=<%= s.getId() %>" class="btn btn-sm btn-primary">
                                    <i class="bi bi-pen"></i>
                                </a>
                                <a href="subject?action=changeStatus&id=<%= s.getId() %>"
                                   class="btn btn-sm <%= s.isStatus() ? "btn-danger" : "btn-success" %>">
                                    <i class="bi <%= s.isStatus() ? "bi-x-circle" : "bi-check-circle" %>"></i>
                                </a>
                                <a href="subject?action=delete&id=<%= s.getId() %>" class="btn btn-sm btn-danger">
                                    <i class="bi bi-trash"></i>
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

<!-- New Subject Modal -->
<div class="modal fade" id="newSubjectModal" tabindex="-1" aria-labelledby="newSubjectModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="newSubjectModalLabel">Create New Subject</h3>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="subject" method="POST">
                    <input type="hidden" name="action" value="create">

                    <div class="mb-3" style="display: flex; justify-content: space-between">
                        <div>
                            <label for="code" class="form-label">Code</label>
                            <input type="text" class="form-control popup" id="code" name="code" style="width: 150px"
                                   required>
                        </div>
                        <div>
                            <label for="name" class="form-label">Name</label>
                            <input type="text" class="form-control popup" id="name" name="name" style="width: 350px"
                                   required>
                        </div>


                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control popup" id="description" name="description" rows="3"></textarea>
                    </div>

                    <div class="mb-3" style="display: flex; justify-content: space-between; margin-top: 30px;">
                        <div class="col-md-5">
                            <label for="domain" class="form-label">Domain</label>
                            <select class="form-select popup" id="domainSelect" name="domain">
                                <% for (HashMap.Entry<Integer, String> entry : map.entrySet()) { %>
                                <option value="<%= entry.getKey() %>"><%= entry.getValue() %></option>
                                <% } %>
                            </select>
                        </div>

                        <div class="col-md-5">
                            <div>
                                <label class="form-label">Status</label>
                            </div>
                            <div style="display: flex; justify-content: space-evenly">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="status" id="statusActive" value="Active" checked>
                                    <label class="form-check-label" for="statusActive">Active</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="status" id="statusInactive" value="Inactive">
                                    <label class="form-check-label" for="statusInactive">Inactive</label>
                                </div>
                            </div>

                        </div>
                    </div>


                    <div style="display: flex; justify-content: end">
                        <button type="submit" class="btn btn-primary w-30 py-2 rounded-3 shadow-sm mt-3">Create
                            Subject
                        </button>

                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script>
    const searchInput = document.getElementById('searchInput');
    const domainSelect = document.getElementById('domain');

    function performSearch() {
        const searchTerm = searchInput.value.trim();
        const selectedDomain = domainSelect.value;
        const url = `subject?search=${encodeURIComponent(searchTerm)}&domain=${selectedDomain}`;
        window.location.href = url;
    }

    searchInput.addEventListener('keypress', function (event) {
        if (event.key === 'Enter') {
            performSearch();
        }
    });

    domainSelect.addEventListener('change', function () {
        performSearch();
    });
</script>
<script>
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


</script>
</body>
</html>