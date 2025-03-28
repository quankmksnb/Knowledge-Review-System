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
    <title>My Class</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>

        html {
            height: 100%;
        }

        .main-content {
            flex: 1 0 auto; /* Grows to push footer down */
        }

        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            min-height: 100%;
            display: flex;
            flex-direction: column;
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        @media (min-width: 1200px) {
            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }
        }

        /* Filter Dropdown */
        .filter-container {
            text-align: center;
            margin: 20px 0;
        }

        .filter-dropdown {
            padding: 12px 20px;
            font-size: 16px;
            border-radius: 25px;
            border: 1px solid #007bff;
            background-color: #ffffff;
            color: #007bff;
            cursor: pointer;
            outline: none;
            transition: all 0.3s ease;
            width: 250px;
            appearance: none;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24"><path fill="%23007bff" d="M7 10l5 5 5-5z"/></svg>');
            background-repeat: no-repeat;
            background-position: right 15px center;
        }

        .filter-dropdown:hover {
            border-color: #0056b3;
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
        }

        .filter-dropdown:focus {
            border-color: #0056b3;
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.5);
        }

        /* Card Container */
        .card-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            padding: 20px;
            justify-content: center;
        }

        /* Enhanced Card Styles */
        .card {
            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
            border: 1px solid #e0e0e0;
        }

        .card:hover {
            transform: translateY(-12px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #007bff, #00c6ff);
        }

        .card h3 {
            font-size: 22px;
            margin: 10px 0;
            font-weight: 700;
            color: #2c3e50;
        }

        .card h5 {
            font-size: 14px;
            color: #7f8c8d;
            margin: 5px 0;
        }

        .card p {
            font-size: 14px;
            color: #34495e;
            margin: 10px 0;
            max-height: 40px;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.5;
        }

        .card a {
            display: inline-block;
            font-size: 16px;
            color: #007bff;
            text-decoration: none;
            font-weight: 600;
            padding: 8px 15px;
            border-radius: 20px;
            background: rgba(0, 123, 255, 0.1);
            transition: all 0.3s ease;
        }

        .card a:hover {
            color: white;
            background: #007bff;
        }

        .section-title {
            font-size: 32px;
            font-weight: 700;
            margin: 30px 0;
            color: #2c3e50;
            text-align: center;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Pagination */
        .pagination-container {
            text-align: center;
            margin-top: 30px;
        }

        .page-btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
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

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .card-container {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            }
            .filter-dropdown {
                width: 200px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp"></jsp:include>

<div class="main-content">
<!-- My Classes Section -->
<div class="section-title">My Classes</div>

<!-- Filter Dropdown -->
<div class="filter-container">
    <select class="filter-dropdown" id="subject-filter">
        <option value="all">All Subjects</option>
        <!-- Dynamic options will be added here via JavaScript -->
    </select>
</div>

<div class="main-container">
    <div class="card-container" id="class-container">
        <!-- Cards will be loaded here dynamically -->
    </div>
</div>

<!-- Pagination Container -->
<div id="pagination" class="pagination-container"></div>

<script>
    let allClasses = [];
    let filteredClasses = [];

    $(document).ready(function () {
        let classesPerPage = 12;
        let currentPage = 1;
        let totalPages = 1;

        function renderPagination() {
            let paginationContainer = $('#pagination');
            paginationContainer.empty();
            if (totalPages > 1) {
                for (let i = 1; i <= totalPages; i++) {
                    let activeClass = i === currentPage ? 'active' : '';
                    paginationContainer.append(`<button class="page-btn ${activeClass}" data-page="${i}">${i}</button>`);
                }
            }
        }

        function renderClasses(page) {
            let container = $('#class-container');
            container.empty();

            let start = (page - 1) * classesPerPage;
            let end = start + classesPerPage;
            let paginatedClasses = filteredClasses.slice(start, end);

            $.each(paginatedClasses, function (index, classItem) {
                let card = `
                    <div class="card">
                        <h3>${classItem.className}</h3>
                        <h5>Code: ${classItem.code}</h5>
                        <h5>Subject: ${classItem.subjectName}</h5>
                        <p>Lecturer: ${classItem.managerName}</p>
                        <a href="/class-enroll?class-id=${classItem.id}">Learn More</a>
                    </div>
                `;
                container.append(card);
            });
        }

        // Fetch classes and populate dropdown
        $.ajax({
            url: '/getMyClasses',
            method: 'GET',
            dataType: 'json',
            success: function (data) {
                console.log(data);
                allClasses = data;
                filteredClasses = data;
                totalPages = Math.ceil(filteredClasses.length / classesPerPage);
                renderClasses(currentPage);
                renderPagination();

                // Populate dropdown dynamically
                let subjects = [...new Set(data.map(item => item.subjectName))];
                let dropdown = $('#subject-filter');
                subjects.forEach(subject => {
                    dropdown.append(`<option value="${subject}">${subject}</option>`);
                });
            },
            error: function () {
                alert('Failed to load classes.');
            }
        });

        // Pagination click handler
        $(document).on('click', '.page-btn', function () {
            currentPage = parseInt($(this).data('page'));
            renderClasses(currentPage);
            renderPagination();
        });

        // Dropdown change handler
        $('#subject-filter').on('change', function () {
            let subject = $(this).val();
            if (subject === 'all') {
                filteredClasses = allClasses;
            } else {
                filteredClasses = allClasses.filter(classItem => classItem.subjectName === subject);
            }

            currentPage = 1;
            totalPages = Math.ceil(filteredClasses.length / classesPerPage);
            renderClasses(currentPage);
            renderPagination();
        });
    });
</script>
</div>
<jsp:include page="footer.jsp"></jsp:include>

</body>
</html>