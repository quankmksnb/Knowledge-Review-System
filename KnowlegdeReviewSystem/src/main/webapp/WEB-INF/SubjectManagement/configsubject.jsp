<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page import="models.DTOConfig" %>
<%@ page import="models.Setting" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Subject" %>
<%@ page import="models.User" %>
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
    <link rel="stylesheet" href="CSS/SubjectDetail/config.css">
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
        <jsp:include page="../Admin/homeAdmin.jsp"></jsp:include>

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
                                    <th>Value</th>
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