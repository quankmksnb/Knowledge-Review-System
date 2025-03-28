<%--
Created by IntelliJ IDEA.
User: PC
Date: 3/2/2025
Time: 11:43 PM
To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Question" %>
<%@ page import="models.Subject" %>
<%@ page import="models.Lesson" %>
<%@ page import="models.DTOConfig" %>
<%
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
    List<DTOConfig> configs = (List<DTOConfig>) request.getAttribute("configs");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
    int itemsPerPage = 8;
    int totalItems = questions != null ? questions.size() : 0;
    int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Question Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
    <link rel="stylesheet" href="CSS/SubjectQuestion/listsubjectquestion.css">

</head>
<body>
<div class="container-fluid">
    <div class="row">
        <jsp:include page="../Admin/homeAdmin.jsp"></jsp:include>
        <div class="col p-0">
            <div class="header-bar d-flex justify-content-between align-items-center px-4">
                <div class="d-flex align-items-center gap-3">
                    <a class="btn btn-sm btn-primary"
                       href="question?action=choose">
                        <i class="bi bi-arrow-return-left"></i>
                        Choose subject of question
                    </a>
                    <div class="header-title">Questions of <%=(String) request.getAttribute("subjectName")%>
                    </div>
                </div>
                <div>

                    <a class="btn btn-sm btn-primary"
                       href="question?action=create">
                        <i class="bi bi-plus-circle"></i>
                    </a>
                </div>
            </div>

            <div class="toast-container">
                <div id="statusToast" class="toast custom-toast hide" role="alert" aria-live="assertive"
                     aria-atomic="true" data-bs-delay="1500">
                    <div class="toast-header">
                        <i class="bi me-2" id="toastIcon"></i>
                        <strong class="me-auto" id="toastTitle"></strong>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"
                                aria-label="Close"></button>
                    </div>
                    <div class="toast-body" id="toastMessage"></div>
                </div>
            </div>
            <div class="filter-container">
                <div style="flex: 1;">
                    <form action="question">
                        <input type="hidden" name="action" value="list">
                        <label for="searchInput" class="form-label">Question Content:</label>
                        <input type="text" id="searchInput" class="form-control search-input"
                               placeholder="Search question..." name="content"/>
                        <button style="opacity: 0;" type="submit"></button>
                    </form>

                </div>
                <div style="flex: 1;">
                    <label for="lessonFilter" class="form-label">Filter by Lesson:</label>
                    <select id="lessonFilter" name="lessonId" class="form-select">
                        <option value="all">All Lessons</option>
                        <% if (lessons != null) {
                            for (Lesson lesson : lessons) { %>
                        <option value="<%= lesson.getId() %>">
                            <%= lesson.getTitle() %>
                        </option>
                        <% }
                        } %>
                    </select>
                </div>
                <div style="flex: 1; display: none">
                    <label for="configFilter" class="form-label">Filter by config:</label>
                    <select id="configFilter" name="configId" class="form-select">
                        <option value="">All Domain</option>
                        <% if (configs != null) {
                            for (DTOConfig domain : configs) { %>
                        <option value="<%= domain.getId() %>">
                            <%= domain.getDescription() %>
                        </option>
                        <% }
                        } %>
                    </select>
                </div>

            </div>

            <div class="table-responsive question-table">
                <table class="table">
                    <thead>
                    <tr>
                        <th></th>
                        <th>Question Content</th>
                        <th>Lesson</th>
                        <th>Domain</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (questions != null && !questions.isEmpty()) {
                        for (int i = startIndex; i < endIndex; i++) {
                            Question question = questions.get(i); %>
                    <tr>
                        <td><%= i + 1 %>
                        </td>
                        <td><%= question.getContent() %>
                        </td>
                        <td>
                            <% if (lessons != null) {
                                for (Lesson lesson : lessons) {
                                    if (lesson.getId() == question.getLessonId()) { %>
                            <%= lesson.getTitle() %>
                            <% break;
                            }
                            }
                            } %>
                        </td>
                        <td><%= question.getDomain() %>
                        </td>
                        <td>
                            <% if (question.getStatus().equals("active")) { %>
                            <span class="badge bg-success">Active</span>
                            <% } else { %>
                            <span class="badge bg-danger">Inactive</span>
                            <% } %>
                        </td>
                        <td>
                            <div class="btn-group">
                                <a class="btn btn-sm btn-primary"
                                   href="question?action=update&id=<%=question.getId()%>">
                                    <i class="bi bi-pen"></i>
                                </a>
                                <a href="question?action=changeStatus&id=<%= question.getId() %>&status=<%= question.getStatus() %>"
                                   class="btn btn-sm <%= question.getStatus().equals("active") ? "btn-danger" : "btn-success" %>">
                                    <i class="bi <%= question.getStatus().equals("active") ? "bi-x-circle" : "bi-check-circle" %>"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% }
                    } else { %>
                    <tr>
                        <td colspan="6" class="text-center">No questions found</td>
                    </tr>
                    <% } %>
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
                <a href="?page=<%= i %>" class="pagination-item <%= i == currentPage ? "active" : "" %>"><%= i %>
                </a>
                <% } %>

                <% if (endPage < totalPages) { %>
                <% if (endPage < totalPages - 1) { %>
                <span class="pagination-item disabled">...</span>
                <% } %>
                <a href="?page=<%= totalPages %>" class="pagination-item"><%= totalPages %>
                </a>
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
<jsp page="../Web/footer.jsp"></jsp>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
        crossorigin="anonymous"></script>
<script>
    // Auto-hide notifications after 5 seconds
    document.addEventListener('DOMContentLoaded', function () {
        // Check for success or error messages
        <% if (successMessage != null && !successMessage.isEmpty()) { %>
        showToast('success', 'Success', '<%= successMessage %>');
        <% } %>

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
        showToast('error', 'Error', '<%= errorMessage %>');
        <% } %>
        <%
    String successMessages = (String) session.getAttribute("successMessage");
    if (successMessages != null && !successMessages.isEmpty()) {
    %>
        showToast('success', 'Success', '<%= successMessages %>');
        <%
            session.removeAttribute("successMessage");
        } %>

    });

    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.getElementById('searchInput');
        const lessonFilter = document.getElementById('lessonFilter');
        const configFilter = document.getElementById('configFilter');

        lessonFilter.addEventListener('change', applyFilters);
        configFilter.addEventListener('change', applyFilters);

        searchInput.addEventListener('keypress', function(event) {
            if (event.key === 'Enter') {
                applyFilters();
            }
        });

        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('lessonId')) {
            lessonFilter.value = urlParams.get('lessonId');
        }
        if (urlParams.has('configId')) {
            configFilter.value = urlParams.get('configId');
        }
        if (urlParams.has('searchContent')) {
            searchInput.value = urlParams.get('searchContent');
        }

        function applyFilters() {
            const lessonId = lessonFilter.value;
            const configId = configFilter.value;
            const searchContent = searchInput.value.trim();

            let url = 'question?action=filter';
            if (lessonId) {
                url += '&lessonId=' + encodeURIComponent(lessonId);
            }
            if (configId) {
                url += '&configId=' + encodeURIComponent(configId);
            }
            if (searchContent) {
                url += '&searchContent=' + encodeURIComponent(searchContent);
            }

            window.location.href = url;
        }
    });
    // Function to show toast
    function showToast(type, title, message) {
        const toast = document.getElementById('statusToast');
        const toastIcon = document.getElementById('toastIcon');
        const toastTitle = document.getElementById('toastTitle');
        const toastMessage = document.getElementById('toastMessage');

        // Reset classes
        toast.classList.remove('toast-success', 'toast-error');
        toastIcon.classList.remove('bi-check-circle', 'bi-x-circle');

        if (type === 'success') {
            toast.classList.add('toast-success');
            toastIcon.classList.add('bi-check-circle');
        } else {
            toast.classList.add('toast-error');
            toastIcon.classList.add('bi-x-circle');
        }

        toastTitle.textContent = title;
        toastMessage.textContent = message;

        const bsToast = new bootstrap.Toast(toast);
        bsToast.show();

        // Auto hide after 5 seconds
        setTimeout(function () {
            bsToast.hide();
        }, 1500);
    }


    // Kiểm tra trước khi submit form thêm mới question
    function validateAndSubmit() {
        const subjectId = document.getElementById('subjectId').value;
        const lessonId = document.getElementById('lessonId').value;
        const content = document.getElementById('content').value;

        if (!subjectId) {
            showToast('error', 'Error', 'Please select a subject');
            return;
        }

        if (!lessonId) {
            showToast('error', 'Error', 'Please select a lesson');
            return;
        }

        if (!content.trim()) {
            showToast('error', 'Error', 'Please enter question content');
            return;
        }

        // Nếu tất cả đều hợp lệ, submit form
        document.getElementById('addQuestionForm').submit();
    }

    // Handle delete confirmation
    function confirmDelete(questionId) {
        document.getElementById('deleteQuestionId').value = questionId;
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
        deleteModal.show();
    }

    let answerIndex = 1;

    function addAnswer() {
        const answerContainer = document.getElementById('answerContainer');
        const newAnswer = document.createElement('div');
        newAnswer.className = 'mb-3 answer-item';
        newAnswer.innerHTML = `
            <textarea name="answers[]" class="form-control mb-2" rows="2" required></textarea>
            <div class="form-check mb-3">
                <input class="form-check-input" type="checkbox" name="correctAnswers[]" value="${answerIndex}">
                <label class="form-check-label">Correct</label>
            </div>
        `;
        answerContainer.appendChild(newAnswer);
        answerIndex++;
    }
</script>

<script>
    function confirmDelete(questionId) {
        if (confirm("Are you sure you want to delete this question?")) {
            window.location.href = "question?action=delete&id=" + questionId;
        }
    }
</script>

</body>
</html>