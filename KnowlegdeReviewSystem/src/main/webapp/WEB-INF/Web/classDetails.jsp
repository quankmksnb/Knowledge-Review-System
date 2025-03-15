<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.*" %>
<%@ page import="models.User" %>
<%@ page import="models.dao.SettingDAO" %>
<%@ page import="controllers.WebManager" %>
<%@ page import="models.SettingType" %>
<%@ page import="models.Setting" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Public Classes</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        .main-content {
            width: 80%;
            max-width: 900px;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            font-family: Arial, sans-serif;
        }

        .class-header {
            text-align: center;
            margin-bottom: 20px;
        }

        .class-header h1 {
            color: #007bff;
            font-size: 24px;
        }

        .class-header p {
            font-size: 16px;
            color: #555;
        }

        .tabs {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 20px;
            border-bottom: 2px solid #ddd;
            padding-bottom: 10px;
        }

        .tab {
            cursor: pointer;
            padding: 10px 20px;
            font-size: 16px;
            color: #007bff;
            transition: 0.3s;
            border-bottom: 3px solid transparent;
        }

        .tab:hover,
        .tab.active {
            font-weight: bold;
            border-bottom: 3px solid #007bff;
        }

        .tab-content {
            display: none;
            padding: 15px;
        }

        .tab-content.active {
            display: block;
        }

        .lesson {
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 5px;
            background-color: #f9f9f9;
        }

        .lesson h3 {
            margin: 0;
            color: #333;
        }

        .lesson p {
            color: #666;
            margin: 5px 0;
        }

        .lesson ul {
            margin: 10px 0 0;
            padding-left: 20px;
        }

        .lesson ul li {
            margin-bottom: 5px;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .pagination button {
            margin: 0 5px;
            padding: 8px 15px;
            border: none;
            background-color: #007bff;
            color: white;
            font-size: 14px;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .pagination button:hover {
            background-color: #0056b3;
        }

        .pagination button:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content {
                width: 95%;
                padding: 15px;
            }

            .tabs {
                flex-direction: column;
                align-items: center;
            }

            .tab {
                width: 100%;
                text-align: center;
            }
        }
    </style>

</head>
<jsp:include page="header.jsp"></jsp:include>
<div class="main-content">
    <div class="class-header">
        <h1 id="class-title"></h1>
        <p id="class-code"></p>
        <p id="subject"></p>
    </div>
    <div class="tabs">
        <div class="tab active" onclick="switchTab('lessons', this)">Lessons</div>
        <div class="tab" onclick="switchTab('terms', this)">Terms</div>
        <div class="tab" onclick="switchTab('details', this)">Details</div>
    </div>
    <div id="lessons" class="tab-content active">
        <div id="lesson-list"></div>
        <div class="pagination">
            <button onclick="prevPage()">Previous</button>
            <button onclick="nextPage()">Next</button>
        </div>
    </div>
    <div id="terms" class="tab-content">
        <p>Terms content goes here...</p>
    </div>
    <div id="details" class="tab-content">
        <p>Class details content goes here...</p>
    </div>
    <jsp:include page="footer.jsp"></jsp:include>
</div>

<script>
    let currentPage = 1;
    const lessonsPerPage = 3;
    let lessons = []
    const urlParams = new URLSearchParams(window.location.search);
    const classId = urlParams.get('class-id');

    function fetchClassDetails(){
        $.ajax({
            url: "classInfo?class_id=" + classId,
            type: "GET",
            success: function(data) {
                if (data) {
                    // Update class title and description
                    $("#class-title").text(data.className);
                    $("#class-code").text(data.classCode);
                    $("#subject").text(data.subjectName);

                    // Populate lessons
                    lessons = data.lessons;
                    displayLessons();

                    // Populate terms section
                    $("#terms").html(data.terms ? data.terms : "<p>No terms available.</p>");

                    // Populate details section
                    $("#details").html(data.details ? data.details : "<p>No details available.</p>");
                }
            },
            error: function(xhr, status, error) {
                console.error("Error fetching lessons:", error);
            }
        });
    }

    function fetchTerms() {
        $.ajax({
            url: "getTerms",
            type: "GET",
            data: { class_id: 1 },
            dataType: "json",
            success: function(response) {
                lessons = response;
                displayLessons();
            },
            error: function(xhr, status, error) {
                console.error("Error fetching lessons:", error);
            }
        });
    }

    function displayLessons() {
        const lessonList = document.getElementById("lesson-list");
        lessonList.innerHTML = "";
        const start = (currentPage - 1) * lessonsPerPage;
        const end = start + lessonsPerPage;
        lessons.slice(start, end).forEach(lesson => {
            const lessonDiv = document.createElement("div");
            lessonDiv.classList.add("lesson");
            lessonDiv.innerHTML = `<h3><strong>${lesson.title}</strong></h3><p>${lesson.description}</p><ul>${lesson.questions.map(q => `<li>${q.content}</li>`).join('')}</ul>`;
            lessonList.appendChild(lessonDiv);
        });
        updatePaginationButtons();
    }

    function prevPage() {
        if (currentPage > 1) {
            currentPage--;
            displayLessons();
        }
    }

    function nextPage() {
        if (currentPage * lessonsPerPage < lessons.length) {
            currentPage++;
            displayLessons();
        }
    }

    function updatePaginationButtons() {
        document.querySelector(".pagination button:first-child").disabled = (currentPage === 1);
        document.querySelector(".pagination button:last-child").disabled = (currentPage * lessonsPerPage >= lessons.length);
    }

    function switchTab(tabId, element) {
        document.querySelectorAll(".tab-content").forEach(tab => tab.classList.remove("active"));
        document.getElementById(tabId).classList.add("active");
        document.querySelectorAll(".tab").forEach(tab => tab.classList.remove("active"));
        element.classList.add("active");
    }

    document.addEventListener("DOMContentLoaded", fetchClassDetails);
</script>


</body>
</html>
