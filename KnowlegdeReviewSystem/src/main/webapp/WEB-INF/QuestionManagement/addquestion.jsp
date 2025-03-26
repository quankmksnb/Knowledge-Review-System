<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.*" %>

<html>
<head>
    <title>Add Question</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
            crossorigin="anonymous">

    </script>
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

        .form-control, .form-select {
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

        .btn-danger {
            background-color: #dc3545;
            color: white;
            border-radius: 8px;
            padding: 10px 20px;
            border: none;
            margin-right: 10px;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .row .col-md-6 {
            margin-bottom: 25px;
        }

        .answer-item {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
        }

        .nav-tabs .nav-link.active {
            font-weight: bold;
        }

        .delete-answer {
            color: #dc3545;
            cursor: pointer;
        }

        .form-check-input {
            margin-right: 10px;
        }
    </style>
</head>
<%
    List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
    List<DTOConfig> configs = (List<DTOConfig>) request.getAttribute("configs");

%>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-auto px-0 sidebar d-none d-md-block">
            <div class="d-flex flex-column p-3">
                <h5 class="text-white mb-4">AdminKit</h5>
                <nav class="nav flex-column">
                    <a class="nav-link" href="/home"><i class="bi bi-house me-2"></i> Home</a>
                    <a class="nav-link" href="/user"><i class="bi bi-people me-2"></i> User</a>
                    <a class="nav-link" href="/subject"><i class="bi bi-book me-2"></i> Subject</a>
                    <a class="nav-link" href="/question"><i class="bi bi-question-circle me-2"></i> Question</a>
                    <a class="nav-link" href="/setting"><i class="bi bi-gear me-2"></i> Setting</a>
                    <a class="nav-link" href="question?action=choose"><i class="bi bi-question-octagon"></i>Question</a>
                </nav>
            </div>
        </div>

        <div class="col p-0">
            <div class="header-bar d-flex justify-content-between align-items-center px-4 bg-white shadow-sm py-3">
                <div class="header-title">Question Management</div>
            </div>

            <div class="container mt-6">


                    <div class="form-container">
                        <div class="header-bar">Question Information</div>

                        <form action="question" method="post" id="addQuestionForm">
                            <input type="hidden" name="action" value="create">

                            <div class="mb-3">
                                <label for="lessonId" class="form-label">Lesson:</label>
                                <select id="lessonId" name="lessonId" class="form-select popup" required>
                                    <option value="">Select Lesson</option>
                                    <% if (lessons != null) {
                                        for (Lesson lesson : lessons) { %>
                                    <option value="<%= lesson.getId() %>"
                                            data-subject="<%= lesson.getSubjectId() %>"><%= lesson.getTitle() %>
                                    </option>
                                    <% }
                                    } %>
                                </select>
                            </div>
                            <div class="mb-3">

                                <label  class="form-label">Config:</label>
                                <br>
                                <% if (configs != null) {
                                    for (DTOConfig config1 : configs) { %>
                                <label>
                                    <input type="radio" name="configId" value="<%=config1.getId()%>" />
                                </label><%=config1.getDescription()%>
                                <br>
                                <% }
                                } %>

                            </div>
                            <div class="mb-3">
                                <label for="content" class="form-label">Question Content:</label>
                                <textarea id="content" name="content" class="form-control popup" rows="5" required></textarea>
                            </div>
                            <div>
                                <label>Answers:</label>
                            </div>

                            <div id="answerContainer">
                                <div class="mb-3 answer-item">
                                    <textarea name="answers[]" class="form-control mb-2" rows="2" required></textarea>
                                    <div class="form-check mb-3">
                                        <input class="form-check-input" type="checkbox" name="correctAnswers[]"
                                               value="${answerIndex}">
                                        <label class="form-check-label">Correct</label>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-end">
                                <button type="button" class="btn btn-secondary me-2" onclick="addAnswer()">Add Answer</button>

                                    <input type="submit" name="submit" value="Add" class="btn-primary">

                            </div>
                        </form>
                    </div>
            </div>
        </div>
    </div>
</div>

</body>
<script>
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

    function validateAndSubmit() {
        const lessonId = document.getElementById('lessonId').value;
        const content = document.getElementById('content').value;



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
</script>

</html>