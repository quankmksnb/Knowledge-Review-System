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
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
            background-image: url('../Images/background.jpg'); /* Path to your HD image */
            background-size: cover; /* Ensures the image covers the entire background */
            background-position: center center; /* Centers the image */
            background-attachment: fixed; /* Keeps the background fixed when scrolling */
            background-repeat: no-repeat; /* Prevents the image from repeating */
        }

        /* Card Styles */
        .card-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            padding: 20px;
        }

        .card-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center; /* Centers the cards horizontally */
            align-items: center; /* Aligns items vertically (if needed) */
            gap: 20px;
            padding: 20px;
        }

        .card {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0px 6px 18px rgba(0, 0, 0, 0.15);
        }
        .card h3 {
            font-size: 20px;
            margin-bottom: 15px;
            font-weight: 600;
            color: #333;
        }

        .card p {
            font-size: 14px;
            color: #555;
            max-height: 40px; /* Set a maximum height */
            overflow: hidden; /* Hide any overflow */
            text-overflow: ellipsis; /* Display ellipsis (...) for overflowed text */
            line-height: 1.5;
        }


        .card a {
            font-size: 16px;
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        .card a:hover {
            color: #0056b3;
        }
        .section-title {
            font-size: 28px;
            font-weight: 700;
            margin: 30px 0;
            color: #333;
            text-align: center;
        }

        #searchResults {
            position: absolute;
            width: 300px;
            background: white;
            border: 1px solid #ccc;
            display: none;
            max-height: 200px;
            overflow-y: auto;
        }
        .result-item {
            padding: 8px;
            border-bottom: 1px solid #ddd;
            cursor: pointer;
        }
        .result-item:hover {
            background: #f1f1f1;
        }

        .pagination-container {
            text-align: center;
            margin-top: 20px;
        }

        .page-btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 14px;
            margin: 5px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .page-btn:hover {
            background-color: #0056b3;
            transform: scale(1.1);
        }

        .page-btn.active {
            background-color: #0056b3;
            font-weight: bold;
            cursor: default;
        }


        /* Modal Background */
        .modal {
            display: none; /* Hidden by default */
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
        }

        /* Popup Card */
        .modal-content {
            background: #ffffff;
            padding: 20px;
            width: 50%;
            max-width: 600px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            text-align: left;
            position: relative;
            border-left: 5px solid #007bff;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .modal-content {
                width: 80%;
            }
        }

        /* Close Button */
        .close-btn {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 20px;
            cursor: pointer;
            color: #888;
        }

        .close-btn:hover {
            color: #000;
        }

        .modal-content h2 {
            color: #007bff;
            font-size: 22px;
            margin-bottom: 10px;
        }

        .modal-content p {
            font-size: 16px;
            color: #555;
            margin: 5px 0;
        }

        .enroll-section {
            text-align: center;
            margin-top: 20px;
        }

        .enroll-btn {
            background: #28a745;
            color: white;
            padding: 12px 20px;
            font-size: 16px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            transition: 0.3s;
        }

        .enroll-btn:hover {
            background: #218838;
        }

    </style>
</head>
<body>

<jsp:include page="header.jsp"></jsp:include>

<!-- Random Courses Section -->
<div class="section-title">Public Classes</div>
<div class="main-container">
    <div class="card-container" id="course-container">
        <!-- Cards will be loaded here dynamically -->
    </div>
</div>


<!-- Modal (Popup) -->
<div id="classModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal()">&times;</span>
        <h2>Class Information</h2>
        <p><strong>Class Name:</strong> <span id="class-name"></span></p>
        <p><strong>Class Code:</strong> <span id="class-code"></span></p>
        <p><strong>Subject:</strong> <span id="subject"></span></p>
        <p><strong>Instructor:</strong> <span id="instructor-name"></span></p>
        <p><strong>Class Status:</strong> <span id="class-status"></span></p>

        <div class="enroll-section">
            <button class="enroll-btn" onclick="enroll(modalClassId)">Enroll Now</button>
        </div>
    </div>
</div>


<script>
    let modalClassId;

    $(document).ready(function () {
        let coursesPerPage = 6; // Number of courses per page
        let currentPage = 1;
        let totalPages = 1;
        let coursesData = [];

        function renderPagination() {
            let paginationContainer = $('#pagination');
            paginationContainer.empty(); // Clear existing buttons

            if (totalPages > 1) {
                for (let i = 1; i <= totalPages; i++) {
                    let activeClass = i === currentPage ? 'active' : '';
                    paginationContainer.append(`<button class="page-btn ${activeClass}" data-page="${i}">${i}</button>`);
                }
            }
        }

        function renderCourses(page) {
            let container = $('#course-container');
            container.empty(); // Clear existing content

            let start = (page - 1) * coursesPerPage;
            let end = start + coursesPerPage;
            let paginatedCourses = coursesData.slice(start, end);

            $.each(paginatedCourses, function (index, classItem) {
                let card = `
                <div class="card">
                            <h3>${classItem.className}</h3>
                            <h5>Code: ${classItem.code}</h5>
                            <h5>Subject: ${classItem.subjectName}</h5>
                            <p>Manager ID: ${classItem.managerName}</p>
                            <p>Status: ${classItem.status}</p>
                            <a onclick="openModal(${classItem.id})"">Learn More</a>
                </div>
                `;
                container.append(card);
            });
        }

        $.ajax({
            url: 'getAllClasses',  // Call HomeServlet
            method: 'GET',
            dataType: 'json',
            success: function (data) {
                console.log(data);
                coursesData = data;
                totalPages = Math.ceil(data.length / coursesPerPage);
                renderCourses(currentPage);
                renderPagination();
            },
            error: function () {
                alert('Failed to load courses.');
            }
        });

        $(document).on('click', '.page-btn', function () {
            currentPage = parseInt($(this).data('page'));
            renderCourses(currentPage);
            renderPagination();
        });
    });


    function openModal(classId) {
        document.getElementById("classModal").style.display = "flex";
        if (classId) {
            $.ajax({
                url: '/getClassDetailsEnroll?id=' + classId,
                method: 'GET',
                dataType: 'json',
                success: function (data) {
                    $('#class-name').text(data.className);
                    $('#class-code').text(data.code);
                    $('#instructor-name').text(data.managerName);
                    $('#class-status').text(data.status);
                    $('#subject').text(data.subjectName);

                    modalClassId = classId;

                    if (data.enrollmentStatus === "Pending") {
                        $('.enroll-btn')
                            .text("Pending Approval")
                            .prop("disabled", true)
                            .css({"background": "#ccc", "cursor": "not-allowed"});
                    } else if (data.enrollmentStatus === "Enrolled") {
                        $('.enroll-btn')
                            .text("Enrolled")
                            .prop("disabled", true)
                            .css({"background": "#ccc", "cursor": "not-allowed"});
                        window.location.href = data.redirectUrl;
                    }
                },
                error: function () {
                    alert('Failed to load course details.');
                }
            });
        } else {
            alert('No course ID provided.');
        }
    }

    function closeModal() {
        document.getElementById("classModal").style.display = "none";
    }

    function enroll(classId) {
        fetch(`/enrollClass?id=${classId}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.success);
                    console.log("Enrolled Successfully", data);
                    location.reload();
                } else {
                    if (data.redirectUrl != null) {
                        window.location.href = data.redirectUrl;
                    }
                    alert(data.error || "Enrollment failed. Please try again.");
                }
            })
            .catch(error => {
                console.error('Error during enrollment:', error);
                alert("There was an error processing your enrollment.");
            });
    }

</script>

<!-- Pagination Container -->
<div id="pagination" style="text-align: center; margin-top: 20px;"></div>


<jsp:include page="footer.jsp"></jsp:include>

</body>
</html>
