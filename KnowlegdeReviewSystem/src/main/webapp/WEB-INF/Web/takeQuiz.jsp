<%--
  Created by IntelliJ IDEA.
  User: kat1002
  Date: 3/24/2025
  Time: 2:37 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Take Quiz</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            color: #333;
        }

        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .quiz-container {
            width: 100%;
            max-width: 800px;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .quiz-header {
            font-size: 28px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #3498db;
        }

        .quiz-section {
            margin-top: 20px;
        }

        .quiz-question {
            margin-bottom: 20px;
        }

        .quiz-question p {
            font-size: 16px;
            font-weight: 500;
            color: #34495e;
            margin-bottom: 10px;
        }

        .quiz-option {
            padding: 10px;
            margin: 5px 0;
            background: #fff;
            border: 1px solid #dfe6e9;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .quiz-option:hover {
            background: #e8ecef;
        }

        .quiz-option.selected {
            background: #3498db;
            color: #fff;
            border-color: #2980b9;
        }

        .quiz-option.correct {
            background: #2ecc71;
            color: #fff;
            border-color: #27ae60;
        }

        .quiz-option.incorrect {
            background: #e74c3c;
            color: #fff;
            border-color: #c0392b;
        }

        .quiz-option.disabled {
            cursor: default;
        }

        .submit-button {
            padding: 10px 20px;
            background: #3498db;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
            transition: background 0.3s ease;
        }

        .submit-button:hover {
            background: #2980b9;
        }

        .quiz-score {
            margin-top: 20px;
            font-size: 18px;
            font-weight: 500;
            color: #2c3e50;
            background: #e8ecef;
            padding: 10px;
            border-radius: 5px;
            display: none;
        }

        .back-button {
            padding: 10px 20px;
            background: #7f8c8d;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-bottom: 20px;
            transition: background 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .back-button:hover {
            background: #6c757d;
        }

        @media (max-width: 768px) {
            .quiz-container {
                padding: 20px;
            }

            .quiz-header {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="header.jsp"></jsp:include>
<div class="container">
    <div class="quiz-container">
        <a href="class-details?class-id=<%= request.getParameter("class-id") %>" class="back-button">Back to Class</a>
        <div class="quiz-header" id="quiz-title">Quiz for Lesson</div>
        <div class="quiz-section" id="quiz-section">
            <div id="quiz-questions"></div>
            <button id="submit-quiz" class="submit-button" style="display: none;">Submit Quiz</button>
            <div id="quiz-score" class="quiz-score"></div>
        </div>
    </div>
</div>

<script>
    let userAnswers = []; // Array to store user's selected answers
    let questions = []; // Store all questions
    let isSubmitted = false; // Track if the quiz has been submitted
    const urlParams = new URLSearchParams(window.location.search);
    const lessonId = urlParams.get('lesson-id');
    const classId = urlParams.get('class-id');

    function fetchQuizQuestions() {
        if (!lessonId) {
            document.getElementById("quiz-questions").innerHTML = "<p>Error: Lesson ID not provided.</p>";
            return;
        }

        $.ajax({
            url: "quiz-questions?lesson_id=" + lessonId, // Use the correct endpoint
            type: "GET",
            success: function (data) {
                if (data && data.length > 0) {
                    questions = data;
                    userAnswers = new Array(data.length).fill(null); // Initialize user answers array
                    displayQuizQuestions();
                    document.getElementById("submit-quiz").style.display = "block"; // Show submit button
                    document.getElementById("quiz-score").style.display = "none"; // Hide score display
                    document.getElementById("quiz-title").innerText = "Quiz for Lesson " + lessonId;
                } else {
                    document.getElementById("quiz-questions").innerHTML = "<p>No quiz questions available for this lesson.</p>";
                    document.getElementById("submit-quiz").style.display = "none";
                    document.getElementById("quiz-score").style.display = "none";
                }
            },
            error: function (xhr, status, error) {
                console.error("Error fetching quiz questions:", error);
                document.getElementById("quiz-questions").innerHTML = "<p>Error loading quiz questions.</p>";
                document.getElementById("submit-quiz").style.display = "none";
                document.getElementById("quiz-score").style.display = "none";
            }
        });
    }

    function displayQuizQuestions() {
        const quizContainer = document.getElementById("quiz-questions");
        quizContainer.innerHTML = "";

        questions.forEach((question, index) => {
            const questionDiv = document.createElement("div");
            questionDiv.classList.add("quiz-question");

            const questionText = document.createElement("p");
            questionText.innerText = `${index + 1}. ${question.content}`;
            questionDiv.appendChild(questionText);

            question.options.forEach(option => {
                const optionDiv = document.createElement("div");
                optionDiv.classList.add("quiz-option");
                optionDiv.innerText = option.content;
                optionDiv.dataset.optionId = option.id; // Store option ID for submission
                optionDiv.dataset.isAnswer = option.is_answer; // Store whether this is the correct answer

                // Check if this option was previously selected
                if (userAnswers[index] && userAnswers[index].optionId === option.id) {
                    optionDiv.classList.add("selected");
                    // Don't show correct/incorrect feedback until submission
                }

                // Only allow clicking if the quiz hasn't been submitted
                if (!isSubmitted) {
                    optionDiv.onclick = () => selectAnswer(index, optionDiv, question.options, question.id);
                } else {
                    optionDiv.classList.add("disabled");
                    // Show correct/incorrect feedback after submission
                    if (option.is_answer) {
                        optionDiv.classList.add("correct");
                    } else if (userAnswers[index] && userAnswers[index].optionId === option.id) {
                        optionDiv.classList.add("incorrect");
                    }
                }

                questionDiv.appendChild(optionDiv);
            });

            quizContainer.appendChild(questionDiv);
        });
    }

    function selectAnswer(questionIndex, selectedOption, options, questionId) {
        if (isSubmitted) return; // Prevent changes after submission

        const optionDivs = selectedOption.parentElement.querySelectorAll(".quiz-option");

        // Remove 'selected' class from all options in this question
        optionDivs.forEach(div => div.classList.remove("selected"));

        // Add 'selected' class to the clicked option
        selectedOption.classList.add("selected");

        // Store the user's selected option ID
        userAnswers[questionIndex] = {
            questionId: questionId,
            optionId: parseInt(selectedOption.dataset.optionId)
        };
    }

    function submitQuiz() {
        // Check if all questions have been answered
        if (userAnswers.some(answer => answer === null)) {
            alert("Please answer all questions before submitting.");
            return;
        }

        // Mark the quiz as submitted
        isSubmitted = true;

        // Redisplay questions to show correct answers and disable interaction
        displayQuizQuestions();

        // Calculate the score locally (optional, since the server will also calculate it)
        let score = 0;
        questions.forEach((question, index) => {
            const selectedOption = question.options.find(option => option.id === userAnswers[index].optionId);
            if (selectedOption && selectedOption.is_answer) {
                score++;
            }
        });

        // Display the score
        const totalQuestions = questions.length;
        const scorePercentage = (score / totalQuestions) * 100;
        const scoreDisplay = document.getElementById("quiz-score");
        scoreDisplay.innerText = `Your Score: ${score}/${totalQuestions} (${scorePercentage.toFixed(2)}%)`;
        scoreDisplay.style.display = "block";

        // Hide the submit button
        document.getElementById("submit-quiz").style.display = "none";

        // Send the answers to the server
        $.ajax({
            url: "my_quiz",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({
                lessonId: parseInt(lessonId),
                answers: userAnswers
            }),
            success: function (response) {
                console.log("Quiz submitted successfully:", response);
                // Update the score display with the server's response
                if (response.score !== undefined) {
                    scoreDisplay.innerText = `Your Score: ${response.score}/${totalQuestions} (${(response.score / totalQuestions * 100).toFixed(2)}%)`;
                }
            },
            error: function (xhr, status, error) {
                console.error("Error submitting quiz:", error);
                scoreDisplay.innerText += " (Error saving results to server)";
            }
        });
    }

    // Event listener for the submit button
    document.getElementById("submit-quiz").addEventListener("click", submitQuiz);

    document.addEventListener("DOMContentLoaded", fetchQuizQuestions);
</script>
<jsp:include page="footer.jsp"></jsp:include>
</body>
</html>