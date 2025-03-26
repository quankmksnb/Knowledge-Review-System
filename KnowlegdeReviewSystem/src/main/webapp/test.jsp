<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course - Udemy Style</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }

        .container {
            display: flex;
            height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 300px;
            background: #fff;
            padding: 20px;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            overflow-y: auto;
        }

        .course-title {
            font-size: 20px;
            font-weight: bold;
            color: #333;
        }

        .lesson-list {
            margin-top: 20px;
            list-style: none;
            padding: 0;
        }

        .lesson-item {
            border-bottom: 1px solid #ddd;
        }

        .lesson-title {
            font-weight: bold;
            padding: 10px;
            background: #f1f1f1;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .lesson-title:hover {
            background: #e0e0e0;
        }

        .dropdown-content {
            display: none;
            padding: 10px;
            background: #f9f9f9;
        }

        .dropdown-option {
            padding: 8px;
            cursor: pointer;
            color: #007bff;
            font-weight: 500;
        }

        .dropdown-option:hover {
            background: #e0e0e0;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .video-container {
            width: 100%;
            background: black;
            height: 400px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            overflow: hidden;
        }

        .video-container video {
            width: 100%;
            height: 100%;
        }

        .lesson-header {
            font-size: 22px;
            font-weight: bold;
            color: #333;
        }

        .lesson-description {
            font-size: 16px;
            color: #666;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                height: auto;
                box-shadow: none;
                border-bottom: 1px solid #ddd;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="course-title" id="class-title">Course Name</div>
        <ul class="lesson-list" id="lesson-list"></ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="video-container">
            <video id="lesson-video" controls>
                <source src="" type="video/mp4">
                Your browser does not support video playback.
            </video>
        </div>
        <div class="lesson-header" id="lesson-title">Introduction</div>
        <div class="lesson-description" id="lesson-description">Welcome to the course! This is the introduction.</div>
    </div>
</div>

<script>
    let lessons = [];
    const urlParams = new URLSearchParams(window.location.search);
    const classId = urlParams.get('class-id');

    function fetchClassDetails() {
        $.ajax({
            url: "classInfo?class_id=1",
            type: "GET",
            success: function (data) {
                if (data) {
                    $("#class-title").text(data.className);
                    lessons = data.lessons;
                    displayLessons();
                }
            },
            error: function (xhr, status, error) {
                console.error("Error fetching lessons:", error);
            }
        });
    }

    function displayLessons() {
        const lessonList = document.getElementById("lesson-list");
        lessonList.innerHTML = "";

        lessons.forEach((lesson, index) => {
            const lessonItem = document.createElement("li");
            lessonItem.classList.add("lesson-item");

            lessonItem.innerHTML = `
                <div class="lesson-title" onclick="toggleDropdown(this)">
                    <span><i class="fas fa-play-circle"></i> ${lesson.title}</span>
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="dropdown-content">
                    <div class="dropdown-option" onclick="loadLesson(${index})">🎥 Watch Video</div>
                    <div class="dropdown-option" onclick="openQuiz(${index})">📝 Take Quiz</div>
                </div>
            `;

            lessonList.appendChild(lessonItem);
        });
    }

    function toggleDropdown(element) {
        const dropdownContent = element.nextElementSibling;
        const icon = element.querySelector("i");

        if (dropdownContent.style.display === "block") {
            dropdownContent.style.display = "none";
            icon.classList.remove("fa-chevron-up");
            icon.classList.add("fa-chevron-down");
        } else {
            dropdownContent.style.display = "block";
            icon.classList.remove("fa-chevron-down");
            icon.classList.add("fa-chevron-up");
        }
    }

    function loadLesson(index) {
        document.getElementById("lesson-video").src = lessons[index].video;
        document.getElementById("lesson-title").innerText = lessons[index].title;
        document.getElementById("lesson-description").innerText = lessons[index].description;
    }

    function openQuiz(index) {
        alert(`Quiz for "${lessons[index].title}" is now opened.`);
        // You can replace the alert with an actual function to show the quiz
    }

    document.addEventListener("DOMContentLoaded", fetchClassDetails);
</script>
</body>
</html>
