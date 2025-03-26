<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/23/2025
  Time: 6:42 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>
<html>
<head>
    <title>Quiz Result</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .container {
            flex: 1;
        }

        .result-container {
            margin-top: 40px;
            margin-bottom: 40px;
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            padding: 30px;
            text-align: center;
            max-width: 900px;
            margin-left: auto;
            margin-right: auto;
        }

        .result-header {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 10px;
        }

        .result-header h2 {
            font-size: 2.5rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .grade-circle {
            width: 140px;
            height: 140px;
            background: conic-gradient(#28a745 ${quizResult.grade * 10}%, #e9ecef ${quizResult.grade * 10}%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            position: relative;
        }

        .grade-circle::before {
            content: '';
            position: absolute;
            width: 120px;
            height: 120px;
            background-color: #fff;
            border-radius: 50%;
        }

        .grade-circle span {
            position: relative;
            font-size: 2rem;
            font-weight: 600;
            color: #2c3e50;
        }

        .grade-text {
            font-size: 1.2rem;
            color: #6c757d;
            margin-bottom: 10px;
        }

        .grade-text strong {
            color: #2c3e50;
            font-weight: 600;
        }

        .summary-card {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-around;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            border-left: 5px solid #007bff;
        }

        .summary-item {
            text-align: center;
        }

        .summary-item h6 {
            font-size: 1rem;
            color: #6c757d;
            margin-bottom: 5px;
        }

        .summary-item p {
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
        }

        .summary-item.correct p {
            color: #28a745;
        }

        .summary-item.incorrect p {
            color: #dc3545;
        }

        .question-review {
            background-color: #fff;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            text-align: left;
            border: 1px solid #e9ecef;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .question-review:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
        }

        .question-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }

        .question-header h5 {
            margin: 0;
            font-size: 1.25rem;
            color: #2c3e50;
            flex: 1;
        }

        .correct-icon, .incorrect-icon {
            font-size: 1.5rem;
        }

        .correct-icon {
            color: #28a745;
        }

        .incorrect-icon {
            color: #dc3545;
        }

        .answer-detail p {
            margin: 5px 0;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .answer-detail .user-answer.correct {
            color: #28a745;
            font-weight: 500;
        }

        .answer-detail .user-answer.incorrect {
            color: #dc3545;
            font-weight: 500;
        }

        .answer-detail .correct-answer {
            color: #28a745;
            font-weight: 500;
        }

        .answer-detail i {
            font-size: 1.2rem;
        }

        .btn-back {
            background-color: #007bff;
            border-color: #007bff;
            border-radius: 8px;
            padding: 10px 30px;
            font-size: 1rem;
            font-weight: 500;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .btn-back:hover {
            background-color: #0056b3;
            border-color: #004085;
            transform: translateY(-2px);
        }

        .btn-back i {
            margin-right: 5px;
        }

        @media (max-width: 576px) {
            .result-header h2 {
                font-size: 2rem;
            }

            .grade-circle {
                width: 120px;
                height: 120px;
            }

            .grade-circle::before {
                width: 100px;
                height: 100px;
            }

            .grade-circle span {
                font-size: 1.5rem;
            }

            .summary-card {
                flex-direction: column;
            }

            .question-review {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../Web/header.jsp"></jsp:include>
<div class="container">
    <div class="result-container">
        <div class="result-header">
            <h2>Quiz Result</h2>
            <div class="grade-circle">
                <span><fmt:formatNumber value="${quizResult.grade}" maxFractionDigits="2" minFractionDigits="2"/>/10</span>
            </div>
            <p class="grade-text">
                Your score for "<strong>${quiz.quizName}</strong>":
                <strong><fmt:formatNumber value="${quizResult.grade}" maxFractionDigits="2" minFractionDigits="2"/>/10</strong>
            </p>
        </div>

        <!-- Summary Section -->
        <div class="summary-card">
            <div class="summary-item">
                <h6>Total Questions</h6>
                <p>${totalQuestion}</p>
            </div>
            <div class="summary-item correct">
                <h6>Correct Answers</h6>
                <p>${correctAnswer}</p>
            </div>
            <div class="summary-item incorrect">
                <h6>Incorrect Answers</h6>
                <p>${wrongAnswer}</p>
            </div>
        </div>

<%--        <!-- Review Section -->--%>
<%--        <h3 class="mt-4 mb-3">Detailed Review</h3>--%>
<%--        <c:forEach var="review" items="${questionReviews}" varStatus="loop">--%>
<%--            <div class="question-review">--%>
<%--                <div class="question-header">--%>
<%--                    <c:choose>--%>
<%--                        <c:when test="${review.correct}">--%>
<%--                            <i class="bi bi-check-circle-fill correct-icon"></i>--%>
<%--                        </c:when>--%>
<%--                        <c:otherwise>--%>
<%--                            <i class="bi bi-x-circle-fill incorrect-icon"></i>--%>
<%--                        </c:otherwise>--%>
<%--                    </c:choose>--%>
<%--                    <h5>Question ${loop.count}: ${review.question.content}</h5>--%>
<%--                </div>--%>
<%--                <div class="answer-detail">--%>
<%--                    <p>--%>
<%--                        <i class="bi bi-person-fill"></i>--%>
<%--                        <strong>Your Answer:</strong>--%>
<%--                        <c:choose>--%>
<%--                            <c:when test="${review.userAnswer != null}">--%>
<%--                                <span class="user-answer ${review.correct ? 'correct' : 'incorrect'}">${review.userAnswer.content}</span>--%>
<%--                            </c:when>--%>
<%--                            <c:otherwise>--%>
<%--                                <span class="user-answer incorrect">Not answered</span>--%>
<%--                            </c:otherwise>--%>
<%--                        </c:choose>--%>
<%--                    </p>--%>
<%--                    <p>--%>
<%--                        <i class="bi bi-check2-circle correct-icon"></i>--%>
<%--                        <strong>Correct Answer:</strong>--%>
<%--                        <span class="correct-answer">${review.correctAnswer.content}</span>--%>
<%--                    </p>--%>
<%--                    <p>--%>
<%--                        <i class="bi bi-bookmark-fill"></i>--%>
<%--                        <strong>Domain:</strong> ${review.question.domain}--%>
<%--                    </p>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </c:forEach>--%>

        <a href="/my_quiz" class="btn btn-back"><i class="bi bi-arrow-left"></i> Back to Quiz List</a>
    </div>
</div>
</body>
</html>