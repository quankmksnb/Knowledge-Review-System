<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.*" %>

<html>
<head>
    <title>Update Question</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="CSS/Question/formquestion.css">

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
        <jsp:include page="../Admin/homeAdmin.jsp"></jsp:include>

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
                        <div style="display: flex; justify-content: space-between; gap: 150px">
                            <div class="col-md-6">
                                <label for="lesson" class="form-label">Lesson</label>
                                <select class="form-select" id="lesson" name="lessonId" required>
                                    <% if (lessons != null) {
                                        for (Lesson lesson : lessons) { %>
                                    <option value="<%= lesson.getId() %>"
                                            <%= question.getLessonId() == lesson.getId() ? "selected" : "" %>>
                                        <%= lesson.getTitle() %>
                                    </option>
                                    <% }
                                    } %>
                                </select>
                            </div>

                            <div class="col-md-6">

                                <label class="form-label">Config:</label>
                                <br>
                                <% if (configs != null) {
                                    for (DTOConfig config1 : configs) { %>
                                <label>
                                    <input type="radio" name="configId"
                                           value="<%=config1.getId()%>" <%=config1.getDescription().equals(question.getDomain()) ? "checked" : ""%>/>
                                </label><%=config1.getDescription()%>
                                <br>
                                <% }
                                } %>

                            </div>
                        </div>

                        <div class="col-md-12">
                            <label for="content" class="form-label">Question Content</label>
                            <textarea class="form-control" id="content" name="content" rows="3"
                                      required><%= question.getContent() %></textarea>
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
                            <% }
                            } %>
                        </div>
                        <button type="button" id="addAnswer" class="btn btn-outline-primary mt-2">
                            <i class="bi bi-plus"></i> Add Answer
                        </button>
                    </div>

                    <div class="text-end mt-3">
                        <a href="question?action=list">Back</a>
                        <input type="submit" value="Update" name="submit" class="btn-primary">
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>

<jsp:include page="../Web/footer.jsp"></jsp:include>


</body>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('addAnswer').addEventListener('click', function () {
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

        newAnswer.querySelector('.delete-answer').addEventListener('click', function () {
            newAnswer.remove();
        });
    });

    document.querySelectorAll('.delete-answer').forEach(function (deleteBtn) {
        deleteBtn.addEventListener('click', function () {
            this.closest('.answer-item').remove();
        });
    });
</script>
</html>