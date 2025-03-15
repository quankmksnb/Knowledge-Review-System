<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/3/2025
  Time: 1:26 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page isELIgnored="false" %>
<html>
<head>
    <title>Class Teacher</title>
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
            background-color: #f4f6f9;
        }

        .sidebar {
            background-color: #1a1f36;
            min-height: 100vh;
        }

        .sidebar .nav-link {
            color: #8b92a8;
            padding: 0.8rem 1rem;
            margin: 0.2rem 0;
            border-radius: 6px;
        }

        .sidebar .nav-link:hover {
            background-color: #2d3548;
            color: #fff;
        }

        .header-bar {
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 15px;
        }

        .header-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }

        /* Card Styles */
        .card-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
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
            max-height: 40px;
            overflow: hidden;
            text-overflow: ellipsis;
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

        /* Semester Dropdown */
        .semester-container {
            display: flex;
            align-items: center;
            padding: 15px 20px;
        }

        .semester-container select {
            width: auto;
            min-width: 200px;
            padding: 10px 15px;
            font-size: 15px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <div class="col-auto px-0 sidebar d-none d-md-block">
            <div class="d-flex flex-column p-3">
                <h5 class="text-white mb-4">AdminKit</h5>
                <nav class="nav flex-column">
                    <a class="nav-link" href="/home"><i class="bi bi-house"></i> Home</a>
                    <a class="nav-link" href="/class_teacher"><i class="bi bi-people me-2"></i> Class</a>
                </nav>
            </div>
        </div>
        <div class="col p-0">
            <div class="header-bar d-flex justify-content-between align-items-center px-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="header-title">My Class</div>
                </div>

            </div>
            <div class="semester-container px-4">
                <select id="semesterFilter" name="semesterId" class="form-select" onchange="filterClassesBySemester()">
                    <c:forEach var="semester" items="${semesters}">
                        <option value="${semester.id}">${semester.title}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Container chứa danh sách lớp -->
            <div id="classContainer" class="card-container px-4">
                <c:forEach var="classList" items="${teacherClasses}">
                    <div class="card">
                        <h3>${subjectCodeMap[classList.id]}</h3>
                        <h5>Class: ${classList.code}</h5>
                        <p>${subjectNameMap[classList.id]}</p>
                        <!-- Hiển thị trạng thái với màu sắc và icon -->
                        <p>
                            <c:choose>
                                <c:when test="${classList.status eq 'Public'}">
                        <span class="badge bg-success">
                            <i class="bi bi-unlock"></i> View: Public
                        </span>
                                </c:when>
                                <c:when test="${classList.status eq 'Private'}">
                        <span class="badge bg-dark">
                            <i class="bi bi-lock"></i> View: Private
                        </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">${classList.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <div style="display: flex; justify-content: space-between; margin-top: 10px;">
                            <a href="class_student_detail?classId=${classList.id}">View Students</a>
                            <a href="#">View Details</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

    </div>
</div>

</body>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>
<script>
    function filterClassesBySemester() {
        let semesterId = document.getElementById("semesterFilter").value;

        $.ajax({
            url: "/filter_class_by_semester",
            type: "GET",
            data: { semesterId: semesterId },
            success: function (response) {
                $("#classContainer").html(response); // Cập nhật container bằng dữ liệu từ server
            },
            error: function () {
                alert("Failed to load classes. Please try again.");
            }
        });
    }

</script>
</html>
