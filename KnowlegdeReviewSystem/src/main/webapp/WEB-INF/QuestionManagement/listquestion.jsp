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
    <style>
        body {
            background-color: #f4f6f9;
            font-family: Arial, sans-serif;
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

        .question-table {
            margin: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .question-table th, .question-table td {
            text-align: center;
            padding: 15px;
            border: none;
        }

        .question-table th {
            background-color: #f8f9fa;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .question-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .question-table tr:hover {
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

        .filter-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            padding: 15px;
            margin: 20px;
            display: flex;
        }

        .form-select {
            background-color: #3E4A67;
            color: whitesmoke;
            border: 1px solid #ced4da;
            border-radius: 8px;
            padding: 0.375rem 0.75rem;
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
                    <a class="nav-link" href="/user"><i class="bi bi-person-circle"></i> User</a>
                    <a class="nav-link" href="/subject"><i class="bi bi-book"></i> Subject</a>
                    <a class="nav-link" href="/class_management"><i class="bi bi-people"></i> Class</a>
                    <a class="nav-link" href="/setting"><i class="bi bi-gear"></i> Setting</a>
                    <a class="nav-link" href="question?action=choose"><i class="bi bi-question-octagon"></i>Question</a>
                </nav>
            </div>
        </div>

        <div class="col p-0">
            <div class="header-bar d-flex justify-content-between align-items-center px-4">
                <div class="d-flex align-items-center gap-3">
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
                <div>
                    <label for="searchInput" class="form-label">Question Content:</label>
                    <input type="text" id="searchInput" class="form-control search-input"
                           placeholder="Search question...">
                </div>
                <div>
                    <label for="lessonFilter" class="form-label">Filter by Lesson:</label>
                    <select id="lessonFilter" name="lessonId" class="form-select">
                        <option value="">All Lessons</option>
                        <% if (lessons != null) {
                            for (Lesson lesson : lessons) { %>
                        <option value="<%= lesson.getId() %>">
                            <%= lesson.getTitle() %>
                        </option>
                        <% }
                        } %>
                    </select>
                </div>
                <div>
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
                        for (int i = 0; i < questions.size(); i++) {
                            Question question = questions.get(i); %>
                    <tr>
                        <td><%= i + 1 %>
                        </td>
                        <td><%= question.getContent() %>
                        </td>
                        <td>
                            <% if (lessons != null) {
                                for (Lesson lesson : lessons) {
                                    // Sửa lỗi: Thay question.getId() bằng question.getLessonId()
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
        </div>
    </div>
</div>


</body>
<style>
    footer {
        position: relative;
    }
</style>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="deleteConfirmModalLabel">Confirm Delete</h3>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this question?</p>
                <form action="question" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" id="deleteQuestionId" name="id">
                    <div class="d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

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
        // Initialize lesson filter
        updateLessonFilter();

        // Ẩn ban đầu các lesson trong modal thêm mới không thuộc subject nào
        updateLessonDropdown();
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
        }, 100000);
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
</html>