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
        /* Centering the class-details div */
        #details {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh; /* Full height of viewport */
            background-color: #eef2f7;
        }

        /* Class Details Section */
        .class-details {
            background: #ffffff;
            padding: 20px;
            width: 50%;
            max-width: 600px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            border-left: 5px solid #007bff;
            text-align: left;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .class-details {
                width: 80%;
            }
        }

        .class-details h2 {
            color: #007bff;
            font-size: 22px;
            margin-bottom: 10px;
        }

        .class-details p {
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
<div id="details" class="tab-content">
    <div class="class-details">
        <h2>Class Information</h2>
        <p><strong>Class Name:</strong> <span id="class-name"></span></p>
        <p><strong>Class Code:</strong> <span id="class-code"></span></p>
        <p><strong>Subject:</strong> <span id="subject"></span></p>
        <p><strong>Instructor:</strong> <span id="instructor-name"></span></p>
        <p><strong>Class Status:</strong> <span id="class-status"></span></p>

        <div class="enroll-section">
            <button class="enroll-btn" onclick="enroll()">Enroll Now</button>
        </div>
    </div>
</div>
<jsp:include page="footer.jsp"></jsp:include>


<script>
    $(document).ready(function () {
        const urlParams = new URLSearchParams(window.location.search);
        const courseId = urlParams.get('class-id');

        if (courseId) {
            $.ajax({
                url: '/getClassDetailsEnroll?id=' + courseId,
                method: 'GET',
                dataType: 'json',
                success: function (data) {
                    $('#class-name').text(data.className);
                    $('#class-code').text(data.code);
                    $('#instructor-name').text(data.managerName);
                    $('#class-status').text(data.status);
                    $('#subject').text(data.subjectName);

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
    });


    function enroll() {
        const courseId = new URLSearchParams(window.location.search).get('class-id'); // Get class ID from URL

        fetch(`/enrollClass?id=${courseId}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.success); // Show success message
                    console.log("Enrolled Successfully", data);
                    location.reload(); // Optional: Reload page to reflect changes
                } else {

                    if(data.redirectUrl != null){
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

</body>
</html>
