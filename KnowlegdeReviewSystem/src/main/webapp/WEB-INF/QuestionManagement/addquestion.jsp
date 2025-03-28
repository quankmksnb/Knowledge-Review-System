<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.*" %>

<html>
<head>
    <title>Add Question</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
            crossorigin="anonymous">

    </script>
    <link rel="stylesheet" href="CSS/Question/formquestion.css">

</head>
<%
    List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
    List<DTOConfig> configs = (List<DTOConfig>) request.getAttribute("configs");

%>
<body>
<div class="container-fluid">
    <div class="row">
        <jsp:include page="../Admin/homeAdmin.jsp"></jsp:include>

        <div class="col p-0">
            <div class="header-bar d-flex justify-content-between align-items-center px-4 bg-white shadow-sm py-3">
                <div class="header-title">Add Question</div>
            </div>

            <div class="form-container">
                <div class="header-bar">Question Information</div>
                <form action="question" method="post" id="addQuestionForm">
                    <input type="hidden" name="action" value="create">
                    <div class="row">
                        <div style="display: flex; justify-content: space-between; gap: 150px">
                            <div class="col-md-6">
                                <label for="lesson" class="form-label">Lesson</label>
                                <select class="form-select" id="lesson" name="lessonId" required>
                                    <option value="">Select Lesson</option>
                                    <% if (lessons != null) {
                                        for (Lesson lesson : lessons) { %>
                                    <option value="<%= lesson.getId() %>" data-subject="<%= lesson.getSubjectId() %>">
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
                                    <input type="radio" name="configId" value="<%=config1.getId()%>"/>
                                </label>
                                <%=config1.getDescription()%>
                                <br>
                                <% }
                                } %>
                            </div>
                        </div>


                        <div class="col-md-12">
                            <label for="content" class="form-label">Question Content</label>
                            <textarea class="form-control" id="content" name="content" rows="3" required></textarea>
                        </div>
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
<jsp:include page="../Web/footer.jsp"></jsp:include>

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

        document.getElementById('addQuestionForm').submit();
    }
</script>

</html>