<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Class</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/showdown@2.1.0/dist/showdown.min.js"></script>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            color: #333;
        }

        .container {
            display: flex;
            min-height: 100vh;
            padding-top: 20px;
            padding-bottom: 20px;
        }

        .sidebar {
            width: 320px;
            background: #ffffff;
            padding: 25px;
            box-shadow: 4px 0 20px rgba(0, 0, 0, 0.05);
            border-radius: 12px 0 0 12px;
            overflow-y: auto;
            transition: width 0.3s ease;
        }

        .course-title {
            font-size: 24px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 20px;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }

        .chapter-list {
            margin-top: 10px;
            list-style: none;
            padding: 0;
        }

        .chapter-item {
            border-bottom: 1px solid #eee;
            transition: all 0.3s ease;
        }

        .chapter-title {
            font-weight: 600;
            padding: 15px;
            background: #f8f9fa;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #34495e;
            border-radius: 8px;
            margin: 5px 0;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        .chapter-title:hover {
            background: #e8ecef;
            transform: translateX(5px);
        }

        .chapter-title i {
            color: #3498db;
            transition: transform 0.3s ease;
        }

        .chapter-title.active {
            background: #3498db;
            color: #fff;
        }

        .chapter-title.active i {
            color: #fff;
        }

        .dropdown-content {
            display: none;
            padding: 10px 15px;
            background: #f1f3f5;
            border-radius: 0 0 8px 8px;
            box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .dropdown-option {
            padding: 10px;
            cursor: pointer;
            color: #2980b9;
            font-weight: 500;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .dropdown-option:hover {
            background: #dfe6e9;
            color: #2c3e50;
            transform: translateX(3px);
        }

        .main-content {
            flex: 1;
            padding: 30px;
            background: #fff;
            border-radius: 0 12px 12px 0;
            box-shadow: -4px 0 20px rgba(0, 0, 0, 0.05);
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .video-container {
            width: 100%;
            background: #000;
            height: 450px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease;
            position: relative;
        }

        .video-container:hover {
            transform: scale(1.02);
        }

        .video-container video,
        .video-container iframe {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .video-unavailable {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: #fff;
            font-size: 18px;
            font-weight: 500;
            background: rgba(0, 0, 0, 0.7);
            padding: 15px 25px;
            border-radius: 8px;
            text-align: center;
        }

        .lesson-header {
            font-size: 28px;
            font-weight: 700;
            color: #2c3e50;
            margin: 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #3498db;
        }

        .lesson-description {
            font-size: 16px;
            line-height: 1.6;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.03);
        }
        .take-quiz-button {
            padding: 10px 20px;
            background: #3498db;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
            transition: background 0.3s ease;
        }

        .take-quiz-button:hover {
            background: #2980b9;
        }
        @media (max-width: 768px) {
            .container {
                flex-direction: column;
                padding: 10px;
            }

            .sidebar {
                width: 100%;
                border-radius: 12px;
                margin-bottom: 20px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            }

            .main-content {
                border-radius: 12px;
                padding: 20px;
            }

            .video-container {
                height: 300px;
            }

            .lesson-header {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="header.jsp"></jsp:include>
<div class="container">
    <div class="sidebar">
        <div class="course-title" id="class-title">Course Name</div>
        <ul class="chapter-list" id="chapter-list"></ul>
    </div>
    <div class="main-content">
        <div class="video-container" id="video-container">
            <video id="lesson-video" controls>
                <source src="" type="video/mp4">
                Your browser does not support video playback.
            </video>
            <div class="video-unavailable" id="video-unavailable" style="display: none;">
                No video available for this lesson
            </div>
        </div>
        <div class="lesson-header" id="lesson-title">Introduction</div>
        <div class="lesson-description" id="lesson-description">Welcome to the course! This is the introduction.</div>
        <a id="take-quiz-button" class="take-quiz-button" href="#" style="display: none;">Take Quiz</a>
    </div>
</div>

<script>
    let chapters = [];
    const urlParams = new URLSearchParams(window.location.search);
    const classId = urlParams.get('class-id');

    function fetchClassDetails() {
        $.ajax({
            url: "class-info?class_id=" + classId,
            type: "GET",
            success: function (data) {
                console.log(data);

                if (data) {
                    $("#class-title").text(data.className);
                    chapters = data.chapters;
                    displayChapters();
                    if (chapters.length > 0 && chapters[0].lessons.length > 0) {
                        loadLesson(0, 0);
                    }
                }
            },
            error: function (xhr, status, error) {
                console.error("Error fetching chapters:", error);
            }
        });
    }

    function displayChapters() {
        const chapterList = document.getElementById("chapter-list");
        chapterList.innerHTML = "";

        chapters.forEach((chapter, chapterIndex) => {
            const chapterItem = document.createElement("li");
            chapterItem.classList.add("chapter-item");

            let lessonOptions = "";
            chapter.lessons.forEach((lesson, lessonIndex) => {
                lessonOptions += `
                    <div class="dropdown-option" onclick="loadLesson(${chapterIndex}, ${lessonIndex})">
                        ${lesson.title}
                    </div>
                `;
            });

            chapterItem.innerHTML = `
                <div class="chapter-title" onclick="toggleDropdown(this)">
                    <span><i class="fas fa-book"></i> ${chapter.chapterName}</span>
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="dropdown-content">
                    ${lessonOptions}
                </div>
            `;

            chapterList.appendChild(chapterItem);
        });
    }

    function toggleDropdown(element) {
        const dropdownContent = element.nextElementSibling;
        const icon = element.querySelector(".fa-chevron-down, .fa-chevron-up");

        if (!icon) {
            console.error("Chevron icon not found in chapter title:", element);
            return;
        }

        const allDropdowns = document.querySelectorAll(".dropdown-content");
        const allTitles = document.querySelectorAll(".chapter-title");

        allDropdowns.forEach(d => d.style.display = "none");
        allTitles.forEach(t => t.classList.remove("active"));

        if (dropdownContent.style.display === "block") {
            dropdownContent.style.display = "none";
            icon.classList.remove("fa-chevron-up");
            icon.classList.add("fa-chevron-down");
            element.classList.remove("active");
        } else {
            dropdownContent.style.display = "block";
            icon.classList.remove("fa-chevron-down");
            icon.classList.add("fa-chevron-up");
            element.classList.add("active");
        }
    }

    function loadLesson(chapterIndex, lessonIndex) {
        const lesson = chapters[chapterIndex].lessons[lessonIndex];
        const videoElement = document.getElementById("lesson-video");
        const videoContainer = document.getElementById("video-container");
        const videoUnavailable = document.getElementById("video-unavailable");
        const videoUrl = lesson.videoUrl && lesson.videoUrl.trim() !== "" ? lesson.videoUrl : "";

        console.log("Loading lesson:", lesson.title, "Video URL:", videoUrl);

        // Clear any existing iframe or video content
        videoElement.style.display = "none";
        videoElement.querySelector("source").src = "";
        videoElement.load();
        videoUnavailable.style.display = "none";
        const existingIframe = videoContainer.querySelector("iframe");
        if (existingIframe) {
            existingIframe.remove();
        }

        // Hide the video container by default
        videoContainer.style.display = "none";

        if (videoUrl) {
            videoContainer.style.display = "block";
            if (videoUrl.includes("youtube.com") || videoUrl.includes("youtu.be")) {
                const iframe = document.createElement("iframe");
                iframe.src = videoUrl.replace("watch?v=", "embed/");
                iframe.allow = "autoplay; encrypted-media";
                iframe.allowFullscreen = true;
                videoContainer.appendChild(iframe);
            } else {
                videoElement.querySelector("source").src = videoUrl;
                videoElement.load();
                videoElement.style.display = "block";
            }
        } else {
            videoContainer.style.display = "none";
        }

        document.getElementById("lesson-title").innerText = lesson.title;
        document.getElementById("lesson-description").innerHTML = lesson.description;

        // Check if the lesson has a quiz and display the "Take Quiz" button
        checkForQuiz(lesson.id);

        const allTitles = document.querySelectorAll(".chapter-title");
        allTitles[chapterIndex].classList.add("active");
    }

    function checkForQuiz(lessonId) {
        $.ajax({
            url: "my_quiz?lesson_id=" + lessonId,
            type: "GET",
            success: function (data) {
                const takeQuizButton = document.getElementById("take-quiz-button");
                if (data && data.length > 0) {
                    takeQuizButton.style.display = "inline-block";
                    takeQuizButton.href = `take-quiz?lesson-id=${lessonId}&class-id=${classId}`;
                } else {
                    takeQuizButton.style.display = "none";
                }
            },
            error: function (xhr, status, error) {
                console.error("Error checking for quiz:", error);
                document.getElementById("take-quiz-button").style.display = "none";
            }
        });
    }

    document.addEventListener("DOMContentLoaded", fetchClassDetails);
</script>
<jsp:include page="footer.jsp"></jsp:include>
</body>
</html>