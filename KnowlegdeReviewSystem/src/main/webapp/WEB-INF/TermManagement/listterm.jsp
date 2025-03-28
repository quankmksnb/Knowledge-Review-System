<%--
  Created by IntelliJ IDEA.
  User: PC
  Date: 3/26/2025
  Time: 2:31 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="models.Term" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Lesson" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="models.DTOConfig" %>
<html>
<head>
    <title>Term Management</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
    <link rel="stylesheet" href="CSS/SubjectQuestion/listsubjectquestion.css">

</head>
<body>
<%
    List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
    List<Term> terms = (List<Term>) request.getAttribute("terms");
    Hashtable<Integer, String> termDomainConfigMap = (Hashtable<Integer, String>) request.getAttribute("termDomainConfigMap");
    List<DTOConfig> configs = (List<DTOConfig>) request.getAttribute("configs");

    int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
    int itemsPerPage = 12;
    int totalItems = terms != null ? terms.size() : 0;
    int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
%>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="../Admin/homeAdmin.jsp"></jsp:include>
        <div class="col p-0">
            <div class="header-bar d-flex justify-content-between align-items-center px-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="header-title">Term Management
                        <br>
                        <a class="btn btn-sm btn-primary"
                           href="term?action=choose">
                            <i class="bi bi-arrow-return-left"></i>
                            Return to choose a subject
                        </a></div>
                    <div class="position-relative">
                        <label for="searchInput" class="search-input"></label>
                        <input type="text" id="searchInput" class="form-control search-input" placeholder="Search terms..."/>
                    </div>
                    <div class="ms-3">
                        <label for="lessonFilter" class="filter-label">Filter by Lesson:</label>
                        <select class="filter-select" id="lessonFilter">
                            <option value="all">All Lessons</option>
                            <%
                                if (lessons != null) {
                                    for (Lesson lesson : lessons) {
                            %>
                            <option value="<%= lesson.getId() %>"><%= lesson.getTitle() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                </div>
                <div>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                            data-bs-target="#newTermModal">
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
                        <th></th>
                        <th>Title</th>
                        <th>Lesson</th>
                        <th>Domain</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (terms != null) {
                            for (int i = startIndex; i < endIndex; i++) {
                                Term term = terms.get(i);
                                String domainDescription = termDomainConfigMap.get(term.getId());
                    %>
                    <tr>
                        <td><%= i + 1 %></td>
                        <td><%= term.getTitle() %></td>
                        <td><%
                            for (Lesson lesson : lessons) {
                                if (lesson.getId() == term.getLessonId()) {
                        %>
                            <%= lesson.getTitle() %>
                            <%
                                    }
                                }
                            %>
                        </td>
                        <td><%=domainDescription%></td>
                        <td>
                            <% if ("Active".equals(term.getStatus())) { %>
                            <span class="badge bg-success">Active</span>
                            <% } else { %>
                            <span class="badge bg-danger">Inactive</span>
                            <% } %>
                        </td>
                        <td>
                            <div class="btn-group">
                                <a href="term?action=update&id=<%= term.getId() %>" class="btn btn-sm btn-primary">
                                    <i class="bi bi-pen"></i>
                                </a>
                                <a href="term?action=changeStatus&id=<%= term.getId() %>&status=<%= term.getStatus()%>"
                                   class="btn btn-sm <%= "Active".equals(term.getStatus()) ? "btn-danger" : "btn-success" %>">
                                    <i class="bi <%= "Active".equals(term.getStatus()) ? "bi-x-circle" : "bi-check-circle" %>"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>

            <div class="pagination">
                <% if (totalPages > 1) { %>
                <a href="?page=<%= Math.max(1, currentPage - 1) %>"
                   class="pagination-item <%= currentPage == 1 ? "disabled" : "" %>">
                    <i class="fas fa-chevron-left"></i>
                </a>

                <%
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(totalPages, startPage + 4);

                    if (startPage > 1) {
                %>
                <a href="?page=1" class="pagination-item">1</a>
                <% if (startPage > 2) { %>
                <span class="pagination-item disabled">...</span>
                <% } %>
                <% } %>

                <% for (int i = startPage; i <= endPage; i++) { %>
                <a href="?page=<%= i %>" class="pagination-item <%= i == currentPage ? "active" : "" %>"><%= i %></a>
                <% } %>

                <% if (endPage < totalPages) { %>
                <% if (endPage < totalPages - 1) { %>
                <span class="pagination-item disabled">...</span>
                <% } %>
                <a href="?page=<%= totalPages %>" class="pagination-item"><%= totalPages %></a>
                <% } %>

                <a href="?page=<%= Math.min(totalPages, currentPage + 1) %>"
                   class="pagination-item <%= currentPage == totalPages ? "disabled" : "" %>">
                    <i class="fas fa-chevron-right"></i>
                </a>
                <% } %>
            </div>
        </div>
    </div>
</div>
<jsp:include page="../Web/footer.jsp"></jsp:include>

<div class="modal fade" id="newTermModal" tabindex="-1" aria-labelledby="newTermModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="newTermModalLabel">Create New Term</h3>
                <button type="button" class="btn-close btn-close-black" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="newTermForm" action="term" method="POST">
                    <input type="hidden" name="action" value="add">

                    <div class="mb-3" style="display: flex; justify-content: space-between; flex-direction: column">
                        <div class="position-relative" style="width: 350px">
                            <label for="title" class="form-label">Title</label>
                            <input type="text" class="form-control popup" id="title" name="title" required>
                            <div class="invalid-feedback" id="titleError"></div>
                        </div>
                        <div style="display: flex; justify-content: space-between">
                            <div class="col-md-5">
                                <label for="lesson" class="form-label">Lesson</label>
                                <select class="form-select popup" id="lesson" name="lessonId">
                                    <option value="all">All Lessons</option>
                                    <%
                                        if (lessons != null) {
                                            for (Lesson lesson : lessons) {
                                    %>
                                    <option value="<%= lesson.getId() %>"><%= lesson.getTitle() %></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>

                            <div class="col-md-5">
                                <label  class="form-label">Config:</label>
                                <br>
                                <% if (configs != null) {
                                    for (DTOConfig config1 : configs) { %>
                                <label>
                                    <input type="radio" name="configId" value="<%=config1.getId()%>"/>
                                </label><%=config1.getDescription()%>
                                <br>
                                <% }
                                } %>
                            </div>
                        </div>

                    </div>

                    <div class="mb-3">
                        <label for="content" class="form-label">Content</label>
                        <textarea class="form-control popup" id="content" name="content" rows="3" style="height: 150px"></textarea>
                        <div class="invalid-feedback" id="contentError"></div>
                        <small id="wordCount" class="form-text text-muted">0 / 100 words</small>
                    </div>

                    <div class="mb-3" style="display: flex; justify-content: space-between; margin-top: 30px;">
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
                        <button type="submit" class="btn btn-primary w-30 py-2 rounded-3 shadow-sm mt-3">Create Term</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script>
    function applyFilters() {
        const searchTerm = document.getElementById('searchInput').value.trim();
        const selectedLessonId = document.getElementById('lessonFilter').value;
        let queryParams = new URLSearchParams(window.location.search);

        queryParams.set('page', '1');

        if (searchTerm) {
            queryParams.set('search', searchTerm);
        } else {
            queryParams.delete('search');
        }

        if (selectedLessonId && selectedLessonId !== 'all') {
            queryParams.set('lessonId', selectedLessonId);
        } else {
            queryParams.delete('lessonId');
        }

        window.location.href = window.location.pathname + '?' + queryParams.toString();
    }

    document.getElementById('searchInput').addEventListener('keypress', function(event) {
        if (event.key === 'Enter') {
            applyFilters();
        }
    });

    document.getElementById('lessonFilter').addEventListener('change', function() {
        applyFilters();
    });

    document.addEventListener('DOMContentLoaded', function() {
        const titleInput = document.getElementById('title');
        const contentTextarea = document.getElementById('content');
        const wordCountDisplay = document.getElementById('wordCount');
        const titleError = document.getElementById('titleError');
        const contentError = document.getElementById('contentError');
        const newTermForm = document.getElementById('newTermForm');

        titleInput.addEventListener('input', function() {
            const title = this.value.trim();
            const words = title.split(/\s+/);

            if (words.length > 1) {
                this.classList.add('is-invalid');
                titleError.textContent = 'Title must be a single word';
                return false;
            } else {
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
                titleError.textContent = '';
                return true;
            }
        });

        contentTextarea.addEventListener('input', function() {
            const content = this.value.trim();
            const words = content.split(/\s+/).filter(word => word.length > 0);
            const wordCount = words.length;

            wordCountDisplay.textContent = `${wordCount} / 100 words`;

            if (wordCount > 100) {
                this.classList.add('is-invalid');
                contentError.textContent = 'Content cannot exceed 100 words';
                return false;
            } else {
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
                contentError.textContent = '';
                return true;
            }
        });

        newTermForm.addEventListener('submit', function(event) {
            const title = titleInput.value.trim();
            const content = contentTextarea.value.trim();
            const titleWords = title.split(/\s+/);
            const contentWords = content.split(/\s+/).filter(word => word.length > 0);

            let isValid = true;

            if (titleWords.length > 1) {
                titleInput.classList.add('is-invalid');
                titleError.textContent = 'Title must be a single word';
                isValid = false;
            } else {
                titleInput.classList.remove('is-invalid');
                titleInput.classList.add('is-valid');
                titleError.textContent = '';
            }

            if (contentWords.length > 100) {
                contentTextarea.classList.add('is-invalid');
                contentError.textContent = 'Content cannot exceed 100 words';
                isValid = false;
            } else {
                contentTextarea.classList.remove('is-invalid');
                contentTextarea.classList.add('is-valid');
                contentError.textContent = '';
            }

            if (!isValid) {
                event.preventDefault();
            }
        });
    });

    const urlParams = new URLSearchParams(window.location.search);
    const status = urlParams.get('status');

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
</script>
</body>
</html>