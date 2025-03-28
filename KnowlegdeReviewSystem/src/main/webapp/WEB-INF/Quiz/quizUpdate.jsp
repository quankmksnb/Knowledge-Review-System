<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/24/2025
  Time: 5:36 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Update Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="CSS/Quiz/quizUpdate.css">
</head>
<body>
<jsp:include page="../Web/header.jsp"></jsp:include>
<div class="container mt-4">
    <div class="header-bar">
        <div class="header-title">Update Quiz - ${quiz.quizName}</div>
    </div>
    <div class="card mt-4">
        <div class="card-body">
            <form action="quiz_detail" method="post" id="quizForm">
                <input type="hidden" name="quizId" value="${quiz.id}">

                <div class="mb-3">
                    <label class="form-label">Quiz Name</label>
                    <input type="text" name="quizName" value="${quiz.quizName}" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Subject</label>
                    <select class="form-select" id="subjectFilter" name="subject" required onchange="updateLessonsBySubject()">
                        <c:forEach var="subject" items="${enrolledSubjects}">
                            <option value="${subject.id}" <c:if test="${subject.id == quiz.subjectId}">selected</c:if>>${subject.subjectName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Lesson</label>
                    <select class="form-select" id="lessonFilter" name="lesson" required onchange="updateQuestionLimit()">
                        <c:forEach var="lesson" items="${lessons}">
                            <option value="${lesson.id}" <c:if test="${lesson.id == lessonId}">selected</c:if>>${lesson.title}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Number of Questions</label>
                    <input type="number" name="numOfQuestions" id="numOfQuestions" value="${quiz.numOfQuestions}" class="form-control" required>
                    <small id="maxQuestionsWarning" class="warning-text text-success mt-2"></small>
                </div>

                <div class="d-flex gap-2 mt-4">
                    <a href="my_quiz" class="btn btn-secondary">Back to Quiz List</a>
                    <button type="submit" class="btn btn-save">Update Quiz</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // Cập nhật danh sách bài học khi chọn subject
    function updateLessonsBySubject() {
        var subjectId = document.getElementById("subjectFilter").value;
        var lessonDropdown = document.getElementById("lessonFilter");

        lessonDropdown.innerHTML = '<option value="">Select Lesson</option>';

        if (subjectId !== "") {
            $.ajax({
                url: "/getLessonsBySubject",
                type: "GET",
                data: { subjectId: subjectId },
                success: function(data) {
                    data.forEach(function(lesson) {
                        var option = document.createElement("option");
                        option.value = lesson.id;
                        option.textContent = lesson.title;
                        option.setAttribute("data-subject", lesson.subjectId);
                        lessonDropdown.appendChild(option);
                    });

                    var selectedLesson = document.getElementById("lessonFilter").value;
                    if (selectedLesson !== "") {
                        lessonDropdown.value = selectedLesson;
                    }

                    // Kiểm tra lại số câu hỏi khi lesson thay đổi
                    updateQuestionLimit();
                },
                error: function(xhr) {
                    console.error("Error fetching lessons:", xhr);
                }
            });
        }
    }

    // Cập nhật số câu hỏi tối đa khi bài học được chọn
    function updateQuestionLimit() {
        var lessonId = document.getElementById("lessonFilter").value;

        if (lessonId) {
            $.ajax({
                url: "/getQuestionsCountByLesson",
                type: "GET",
                data: { lessonId: lessonId },
                success: function(response) {
                    if (response && response.maxQuestions !== undefined) {
                        var maxQuestions = response.maxQuestions;
                        document.getElementById("numOfQuestions").max = maxQuestions;
                        document.getElementById("maxQuestionsWarning").textContent = "Max questions: " + maxQuestions;
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Error fetching question count:", error);
                }
            });
        }
    }

    // Kiểm tra khi submit form để đảm bảo số câu hỏi không vượt quá giới hạn
    document.getElementById("quizForm").addEventListener("submit", function(event) {
        var numOfQuestions = document.getElementById("numOfQuestions").value;
        var maxQuestions = document.getElementById("numOfQuestions").max;

        if (parseInt(numOfQuestions) < 0) {
            event.preventDefault();  // Prevent form submission
            alert("The number of questions cannot be less than 0.");
            return;
        }

        if (parseInt(numOfQuestions) > parseInt(maxQuestions)) {
            event.preventDefault();
            alert(`The number of questions cannot be greater than ${maxQuestions}`);
        }
    });

    // Gọi hàm khi trang tải để kiểm tra số câu hỏi khi đã chọn bài học
    document.addEventListener("DOMContentLoaded", function () {
        updateQuestionLimit();
    });
</script>
</body>
</html>


