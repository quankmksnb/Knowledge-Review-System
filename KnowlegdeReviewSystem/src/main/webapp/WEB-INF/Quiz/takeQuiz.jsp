<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/23/2025
  Time: 6:42 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<html>
<head>
    <title>Take Quiz</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            color: #333;
        }

        .quiz-container {
            margin-top: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        .quiz-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .quiz-header h2 {
            margin: 0;
        }

        .timer {
            font-size: 1.2rem;
            font-weight: bold;
            color: #007bff;
        }

        .question-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
        }

        .question-card h5 {
            margin-bottom: 10px;
        }

        .answer-option {
            margin-bottom: 10px;
        }

        .answer-option input[type="radio"] {
            margin-right: 10px;
        }

        .btn-submit {
            background-color: #007bff;
            border-color: #007bff;
            border-radius: 8px;
            padding: 10px 20px;
        }

        .btn-submit:hover {
            background-color: #0056b3;
            border-color: #004085;
        }
    </style>
</head>
<body>
<jsp:include page="../Web/header.jsp"></jsp:include>
<div class="container">
    <div class="quiz-container">
        <div class="quiz-header">
            <h2>${quiz.quizName}</h2>
            <div class="timer" id="timer">00:00</div>
        </div>

        <form id="quizForm" action="/take_quiz" method="post">
            <input type="hidden" name="quizId" value="${quiz.id}">
            <input type="hidden" name="userId" value="${userId}">
            <c:forEach var="question" items="${quizQuestions}" varStatus="loop">
                <div class="question-card">
                    <h5>Question ${loop.count}: ${question.content}</h5>
                    <c:forEach var="option" items="${question.options}">
                        <div class="answer-option">
                            <input type="radio" name="answer_${question.id}" value="${option.id}"
                                   required>
                            <label>${option.content}</label>
                        </div>
                    </c:forEach>
                </div>
            </c:forEach>

            <button type="submit" class="btn btn-submit">Submit Quiz</button>
        </form>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.0.2/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // Timer functionality
    let seconds = 0;
    let timerInterval;

    function startTimer() {
        timerInterval = setInterval(function() {
            seconds++;
            let minutes = Math.floor(seconds / 60);
            let secs = seconds % 60;
            document.getElementById("timer").textContent =
                (minutes < 10 ? "0" + minutes : minutes) + ":" +
                (secs < 10 ? "0" + secs : secs);
        }, 1000);
    }

    // Start the timer when the page loads
    window.onload = startTimer;

    // Stop the timer when the form is submitted
    document.getElementById("quizForm").addEventListener("submit", function() {
        clearInterval(timerInterval);
    });
</script>
</body>
</html>