<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Question" %>
<%@ page import="models.AnswerOption" %>
<%@ page import="models.Subject" %>
<%@ page import="models.Lesson" %>
<%@ page import="java.util.List" %>
<%@ page import="models.DTOConfig" %>

<html>
<head>
    <title>Update Question</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css" rel="stylesheet">
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
<body>
<%
    Question question = (Question) request.getAttribute("question");
    List<AnswerOption> answers = (List<AnswerOption>) request.getAttribute("answers");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
    List<DTOConfig> configs = (List<DTOConfig>) request.getAttribute("configs");

%>
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
                <div class="header-title">Question Detail</div>
            </div>


                    <div class="form-container">
                        <div class="header-bar">Question Information</div>
                        <form action="question" method="POST">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="<%= question.getId() %>">
                            <div class="row">

                                <div class="col-md-6">
                                    <label for="lesson" class="form-label">Lesson</label>
                                    <select class="form-select" id="lesson" name="lessonId" required>
                                        <% if (lessons != null) {
                                            for (Lesson lesson : lessons) { %>
                                        <option value="<%= lesson.getId() %>"
                                                <%= question.getLessonId() == lesson.getId() ? "selected" : "" %>>
                                            <%= lesson.getTitle() %>
                                        </option>
                                        <% } } %>
                                    </select>
                                </div>

                                <div class="col-md-12">

                                    <label  class="form-label">Config:</label>
                                    <br>
                                    <% if (configs != null) {
                                        for (DTOConfig config1 : configs) { %>
                                    <label>
                                        <input type="radio" name="configId" value="<%=config1.getId()%>" <%=config1.getDescription().equals(question.getDomain()) ? "checked" : ""%>/>
                                    </label><%=config1.getDescription()%>
                                    <br>
                                    <% }
                                    } %>

                                </div>
                                <div class="col-md-12">
                                    <label for="content" class="form-label">Question Content</label>
                                    <textarea class="form-control" id="content" name="content" rows="3" required><%= question.getContent() %></textarea>
                                </div>
                            </div>

                            <div class="mt-4">
                                <h5>Answers</h5>
                                <div id="answersContainer">
                                    <% if (answers != null) {
                                        for (int i = 0; i < answers.size(); i++) {
                                            AnswerOption answer = answers.get(i);
                                    %>
                                    <div class="answer-item">
                                        <div class="row">
                                            <div class="col-md-10">
                                                <input type="text" name="answers[]" class="form-control"
                                                       value="<%= answer.getContent() %>" required>
                                            </div>
                                            <div class="col-md-2 d-flex align-items-center">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox"
                                                           name="correctAnswers[]" value="<%= i %>"
                                                        <%= answer.isAnswer() ? "checked" : "" %>>
                                                    <label class="form-check-label">Correct</label>
                                                </div>
                                                <i class="bi bi-trash delete-answer ms-2"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <% } } %>
                                </div>
                                <button type="button" id="addAnswer" class="btn btn-outline-primary mt-2">
                                    <i class="bi bi-plus"></i> Add Answer
                                </button>
                            </div>

                            <div class="text-end mt-3">
                                <a href="question">Back</a>
                                <input type="submit" value="Update" name="submit" class="btn-primary">
                            </div>
                        </form>
                    </div>

            </div>
        </div>
    </div>



</body>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('addAnswer').addEventListener('click', function() {
        var container = document.getElementById('answersContainer');
        var index = container.children.length;
        var newAnswer = document.createElement('div');
        newAnswer.className = 'answer-item';
        newAnswer.innerHTML = `
        <div class="row">
            <div class="col-md-10">
                <input type="text" name="answers[]" class="form-control" required>
            </div>
            <div class="col-md-2 d-flex align-items-center">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox"
                           name="correctAnswers[]" value="\${index}">
                    <label class="form-check-label">Correct</label>
                </div>
                <i class="bi bi-trash delete-answer ms-2"></i>
            </div>
        </div>
    `;
        container.appendChild(newAnswer);

        // Add delete functionality to new delete buttons
        newAnswer.querySelector('.delete-answer').addEventListener('click', function() {
            newAnswer.remove();
        });
    });

    // Delete existing answer
    document.querySelectorAll('.delete-answer').forEach(function(deleteBtn) {
        deleteBtn.addEventListener('click', function() {
            this.closest('.answer-item').remove();
        });
    });
</script>
</html>