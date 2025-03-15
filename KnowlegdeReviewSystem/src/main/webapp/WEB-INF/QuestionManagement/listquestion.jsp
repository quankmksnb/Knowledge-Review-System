<%--
  Created by IntelliJ IDEA.
  User: PC
  Date: 3/2/2025
  Time: 11:43 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Question" %>
<%@ page import="models.Subject" %>
<%@ page import="models.Lesson" %>
<%
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
    Integer selectedSubjectId = (Integer) request.getAttribute("selectedSubjectId");
    Integer selectedLessonId = (Integer) request.getAttribute("selectedLessonId");
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

        .filter-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            padding: 15px;
            margin: 20px;
        }

        .form-select {
            background-color: #f8f9fa;
            border: 1px solid #ced4da;
            border-radius: 8px;
            padding: 0.375rem 0.75rem;
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
                    <a class="nav-link" href="question"><i class="bi bi-question-octagon"></i>Question</a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col p-0">
            <!-- Header Bar -->
            <div class="header-bar d-flex justify-content-between align-items-center px-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="header-title">Question Management</div>
                </div>
                <div>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addQuestionModal">
                        <i class="bi bi-plus-circle"></i> New Question
                    </button>
                </div>
            </div>

            <!-- Toast notifications -->
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

            <!-- Filter Section -->
            <div class="filter-container">
                <form action="question" method="get" id="filterForm" class="row align-items-end g-3">
                    <input type="hidden" name="action" value="filter">
                    <div class="col-md-4">
                        <label for="subjectFilter" class="form-label">Filter by Subject:</label>
                        <select id="subjectFilter" name="subjectId" class="form-select" onchange="updateLessonFilter()">
                            <option value="">All Subjects</option>
                            <% if (subjects != null) {
                                for (Subject subject : subjects) { %>
                            <option value="<%= subject.getId() %>" <%= (selectedSubjectId != null && selectedSubjectId.equals(subject.getId())) ? "selected" : "" %>>
                                <%= subject.getSubjectName() %> (<%= subject.getCode() %>)
                            </option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="lessonFilter" class="form-label">Filter by Lesson:</label>
                        <select id="lessonFilter" name="lessonId" class="form-select">
                            <option value="">All Lessons</option>
                            <% if (lessons != null) {
                                for (Lesson lesson : lessons) { %>
                            <option value="<%= lesson.getId() %>" data-subject="<%= lesson.getSubjectId() %>" <%= (selectedLessonId != null && selectedLessonId.equals(lesson.getId())) ? "selected" : "" %>>
                                <%= lesson.getTitle() %>
                            </option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-funnel"></i> Apply Filter
                        </button>
                    </div>
                </form>
            </div>

            <!-- Question Table -->
            <div class="table-responsive question-table">
                <table class="table">
                    <thead>
                    <tr>
                        <th></th>
                        <th>Question Content</th>
                        <th>Subject</th>
                        <th>Lesson</th>

                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (questions != null && !questions.isEmpty()) {
                        for (int i = 0; i < questions.size(); i++) {
                            Question question = questions.get(i); %>
                    <tr>
                        <td><%= i + 1 %></td>
                        <td><%= question.getContent() %></td>
                        <td>
                            <% if (subjects != null) {
                                for (Subject subject : subjects) {
                                    if (subject.getId() == question.getSubjectId()) { %>
                            <%= subject.getSubjectName() %>
                            <% break; } } } %>
                        </td>
                        <td>
                            <% if (lessons != null) {
                                for (Lesson lesson : lessons) {
                                    // Sửa lỗi: Thay question.getId() bằng question.getLessonId()
                                    if (lesson.getId() == question.getLessonid()) { %>
                            <%= lesson.getTitle() %>
                            <% break; } } } %>
                        </td>

                        <td>
                            <div class="btn-group">
                                <a class="btn btn-sm btn-primary" href="question?action=answer&id=<%= question.getId() %>" >
                                    <i class="bi bi-pen"></i>
                                </a>
                                <button class="btn btn-sm btn-danger" onclick="confirmDelete(<%= question.getId() %>)">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="5" class="text-center">No questions found</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Add Question Modal -->
<div class="modal fade" id="addQuestionModal" tabindex="-1" aria-labelledby="addQuestionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="addQuestionModalLabel">Add New Question</h3>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="question" method="post" id="addQuestionForm">
                    <input type="hidden" name="action" value="create">
                    <div class="mb-3">
                        <label for="subjectId" class="form-label">Subject:</label>
                        <select id="subjectId" name="subjectId" class="form-select popup" required onchange="updateLessonDropdown()">
                            <option value="">Select Subject</option>
                            <% if (subjects != null) {
                                for (Subject subject : subjects) { %>
                            <option value="<%= subject.getId() %>"><%= subject.getSubjectName() %> (<%= subject.getCode() %>)</option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="lessonId" class="form-label">Lesson:</label>
                        <select id="lessonId" name="lessonId" class="form-select popup" required>
                            <option value="">Select Lesson</option>
                            <% if (lessons != null) {
                                for (Lesson lesson : lessons) { %>
                            <option value="<%= lesson.getId() %>" data-subject="<%= lesson.getSubjectId() %>"><%= lesson.getTitle() %></option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="content" class="form-label">Question Content:</label>
                        <textarea id="content" name="content" class="form-control popup" rows="5" required></textarea>
                    </div>
                    <div class="d-flex justify-content-end">
                        <button type="button" class="btn btn-primary py-2 rounded-3 shadow-sm" onclick="validateAndSubmit()">Save Question</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="deleteConfirmModalLabel">Confirm Delete</h3>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
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
    document.addEventListener('DOMContentLoaded', function() {
        // Check for success or error messages
        <% if (successMessage != null && !successMessage.isEmpty()) { %>
        showToast('success', 'Success', '<%= successMessage %>');
        <% } %>

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
        showToast('error', 'Error', '<%= errorMessage %>');
        <% } %>

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
        setTimeout(function() {
            bsToast.hide();
        }, 5000);
    }

    // Filter lessons based on selected subject
    function updateLessonFilter() {
        const subjectId = document.getElementById('subjectFilter').value;
        const lessonSelect = document.getElementById('lessonFilter');
        const lessonOptions = document.querySelectorAll('#lessonFilter option');

        // Nếu không có subject được chọn, hiển thị tất cả lesson
        if (subjectId === '') {
            lessonOptions.forEach(option => {
                if (option.value === '') {
                    option.style.display = '';
                } else {
                    option.style.display = '';
                }
            });
            return;
        }

        // Ẩn/hiện lesson dựa trên subject
        lessonOptions.forEach(option => {
            if (option.value === '') { // Luôn hiển thị option "All Lessons"
                option.style.display = '';
            } else {
                const lessonSubjectId = option.getAttribute('data-subject');
                if (lessonSubjectId == subjectId) {
                    option.style.display = '';
                } else {
                    option.style.display = 'none';
                }
            }
        });

        // Nếu lesson đang chọn không phù hợp với subject mới, reset về "All Lessons"
        const selectedOption = document.querySelector('#lessonFilter option:checked');
        if (selectedOption && selectedOption.style.display === 'none') {
            lessonSelect.value = '';
        }
    }

    // Update lesson dropdown in add modal based on selected subject
    function updateLessonDropdown() {
        const subjectId = document.getElementById('subjectId').value;
        const lessonSelect = document.getElementById('lessonId');
        const lessonOptions = document.querySelectorAll('#lessonId option');

        // Nếu không có subject được chọn, ẩn tất cả các lesson trừ option đầu tiên
        if (subjectId === '') {
            lessonOptions.forEach(option => {
                if (option.value === '') {
                    option.style.display = '';
                } else {
                    option.style.display = 'none';
                }
            });
            lessonSelect.value = '';
            return;
        }

        // Ẩn/hiện lesson dựa trên subject
        let foundMatchingLesson = false;
        lessonOptions.forEach(option => {
            if (option.value === '') { // Luôn hiển thị option "Select Lesson"
                option.style.display = '';
            } else {
                const lessonSubjectId = option.getAttribute('data-subject');
                if (lessonSubjectId == subjectId) {
                    option.style.display = '';
                    foundMatchingLesson = true;
                } else {
                    option.style.display = 'none';
                }
            }
        });

        // Reset lại giá trị lesson
        lessonSelect.value = '';

        // Hiển thị thông báo nếu không có lesson nào cho subject này
        if (!foundMatchingLesson) {
            showToast('error', 'Warning', 'No lessons available for the selected subject');
        }
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
</script>
</body>
</html>