<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="models.Subject" %>
<%@ page import="java.util.List" %>
<%@ page import="models.dao.DTOSubject" %>
<%@ page import="models.User" %>
<html>
<head>
    <title>Subject Management</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="CSS/SubjectQuestion/listsubjectquestion.css">

</head>



<body>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="../Admin/homeAdmin.jsp"></jsp:include>


        <div class="col p-0">
            <div class="header-bar d-flex justify-content-between align-items-center px-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="header-title">Subject Management</div>
                    <div class="position-relative">
                        <label for="searchInput" class="search-input"></label>
                        <input type="text" id="searchInput" class="form-control search-input" placeholder="Search subjects..."/>
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
                        <i class="bi bi-plus-circle"></i>
                    </button>
                </div>
            </div>
            <div class="toast-container">
                <div id="statusToast" class="toast custom-toast hide" role="alert" aria-live="assertive" aria-atomic="true" data-bs-delay="1500">
                    <div class="toast-header">
                        <i class="bi me-2" id="toastIcon"></i>
                        <strong class="me-auto" id="toastTitle"></strong>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                    <div class="toast-body" id="toastMessage"></div>
                </div>
            </div>
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


<div class="modal fade" id="newSubjectModal" tabindex="-1" aria-labelledby="newSubjectModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="newSubjectModalLabel">Create New Subject</h3>
                <button type="button" class="btn-close btn-close-black" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="subject" method="POST">
                    <input type="hidden" name="action" value="create">

                    <div class="mb-3" style="display: flex; justify-content: space-between">
                        <div class="position-relative" style="width: 150px">
                            <label for="code" class="form-label">Code</label>
                            <input type="text" class="form-control popup" id="code" name="code" required>
                            <!-- Error message will be inserted here -->
                        </div>
                        <div class="position-relative" style="width: 350px">
                            <label for="name" class="form-label">Name</label>
                            <input type="text" class="form-control popup" id="name" name="name" required>
                            <!-- Error message will be inserted here -->
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control popup" id="description" name="description" rows="3" style="height: 150px"></textarea>
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
    const urlParams = new URLSearchParams(window.location.search);
    const status = urlParams.get('status');
    // Show toast if status parameter exists
    if (status) {
        showToast(status);
    }
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

    document.addEventListener('DOMContentLoaded', function() {
        const codeInput = document.getElementById('code');
        const nameInput = document.getElementById('name');
        const submitButton = document.querySelector('button[type="submit"]');

        function validateCode(code) {
            // Regex for exactly 3 characters (uppercase letters and numbers)
            const codeRegex = /^[A-Z0-9]{3}$/;
            return codeRegex.test(code);
        }

        function validateName(name) {
            // Regex for name (only letters, numbers, and spaces)
            const nameRegex = /^[a-zA-Z0-9 ]+$/;
            return nameRegex.test(name);
        }

        function showError(input, message) {
            // Remove any existing error states
            input.classList.remove('is-valid');
            input.classList.add('is-invalid');

            // Find or create error message element
            let errorElement = input.parentNode.querySelector('.invalid-feedback');
            if (!errorElement) {
                errorElement = document.createElement('div');
                errorElement.classList.add('invalid-feedback');
                input.parentNode.appendChild(errorElement);
            }

            errorElement.textContent = message;
            errorElement.style.display = 'block';
        }

        function showSuccess(input) {
            input.classList.remove('is-invalid');
            input.classList.add('is-valid');

            const errorElement = input.parentNode.querySelector('.invalid-feedback');
            if (errorElement) {
                errorElement.style.display = 'none';
            }
        }

        codeInput.addEventListener('input', function() {
            const code = this.value.trim().toUpperCase();

            this.value = code;

            if (code.length === 0) {
                showError(this, 'Code is required');
            } else if (!validateCode(code)) {
                showError(this, 'Code must be 3 characters (A-Z, 0-9)');
            } else {
                showSuccess(this);
            }
        });

        nameInput.addEventListener('input', function() {
            const name = this.value.trim();

            if (name.length === 0) {
                showError(this, 'Name is required');
            } else if (!validateName(name)) {
                showError(this, 'Name can only contain letters, numbers, and spaces');
            } else {
                showSuccess(this);
            }
        });

        document.querySelector('form').addEventListener('submit', function(event) {
            const code = codeInput.value.trim().toUpperCase();
            const name = nameInput.value.trim();

            let isValid = true;

            if (!validateCode(code)) {
                showError(codeInput, 'Code must be 3 characters (A-Z, 0-9)');
                isValid = false;
            }

            if (!validateName(name)) {
                showError(nameInput, 'Name can only contain letters, numbers, and spaces');
                isValid = false;
            }

            if (!isValid) {
                event.preventDefault();
            }
        });
    });
</script>
</body>
</html>