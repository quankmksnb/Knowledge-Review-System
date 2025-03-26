<%@ page import="models.User" %>
<%@ page import="models.Term" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Lesson" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Flashcards</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background-color: #f5f7fa;
        }



        .logo img {
            height: 40px;
        }



        .search-bar input {
            padding: 8px 15px;
            border-radius: 20px 0 0 20px;
            border: 1px solid #ddd;
            width: 100%;
            outline: none;
        }

        .search-bar button {
            background-color: #0d6efd;
            color: white;
            border: none;
            border-radius: 0 20px 20px 0;
            padding: 8px 15px;
            cursor: pointer;
        }



        .container {
            max-width: 1600px;
            margin: 0 auto;
            padding: 20px;
        }

        .page-title {
            margin-bottom: 20px;
            font-size: 24px;
            color: #333;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }

        .filters {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            background-color: white;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
            flex: 1;
        }

        .filter-label {
            font-weight: bold;
            color: #555;
        }

        .filter-input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .filter-select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f8f9fa;
        }

        .flashcard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(450px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .flashcard {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            overflow: hidden;
            transition: transform 0.2s;
        }

        .flashcard:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }

        .flashcard-content {
            padding: 15px;
            height: 150px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            border-bottom: 1px solid #eee;
            overflow: hidden;
        }

        .flashcard-footer {
            display: flex;
            justify-content: space-between;
            padding: 10px 15px;
            background-color: #f8f9fa;
        }

        .btn {
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            border: none;
        }



        /* Pagination styles */
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 30px;
            gap: 5px;
        }

        .pagination-item {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 35px;
            height: 35px;
            border-radius: 4px;
            border: 1px solid #ddd;
            background-color: white;
            cursor: pointer;
            transition: all 0.2s;
        }

        .pagination-item:hover {
            background-color: #f1f1f1;
        }

        .pagination-item.active {
            background-color: #0d6efd;
            color: white;
            border-color: #0d6efd;
        }

        .pagination-item.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }


        header {
            position: relative;
        }
        footer {
            position: relative;
        }
        .title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
        }
        .btn-primary {
            background-color: blue;
            color: white;
            border-radius: 8px;
            padding: 10px 20px;
            border: none;
            text-decoration: none;
        }

        .btn-primary:hover {
            background-color: darkblue;
        }
    </style>
</head>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
      rel="stylesheet">
<%List<Term> terms = (List<Term>) request.getAttribute("terms");%>
<%List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");%>
<body>
<!-- Header Section -->

        <jsp:include page="../Web/header.jsp"></jsp:include>



<!-- Main Content Section -->
<div class="container">
    <div class="title">
        <div>
            <h1 class="page-title">Flashcards</h1>

        </div>
        <div>
            <a class="btn-primary"
               href="card?action=user">
                <i class="bi bi-person">My Collection Flash Card</i>
            </a>
        </div>

    </div>


    <!-- Filters Section -->
    <div class="filters">
        <div class="filter-group">
            <label class="filter-label">Flashcard Content:</label>
            <input type="text" class="filter-input" id="contentFilter" placeholder="Search flashcards...">
        </div>

        <div class="filter-group">
            <label class="filter-label">Filter by Lesson:</label>
            <select class="filter-select" id="lessonFilter">
                <option value="">All Lessons</option>
                <% if(lessons != null) {
                    for(Lesson lesson : lessons) { %>
                <option value="<%= lesson.getId() %>"><%= lesson.getTitle() %></option>
                <% } } %>
            </select>
        </div>
    </div>

    <!-- Flashcard Grid -->
    <div class="flashcard-grid" id="flashcardContainer">
        <%
            // Pagination settings
            int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            int itemsPerPage = 6; // Number of cards per page
            int totalItems = terms != null ? terms.size() : 0;
            int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
            int startIndex = (currentPage - 1) * itemsPerPage;
            int endIndex = Math.min(startIndex + itemsPerPage, totalItems);

            if(terms != null) {
                for(int i = startIndex; i < endIndex; i++) {
                    Term term = terms.get(i);
                    // Find the corresponding lesson
                    String lessonTitle = "";
                    if(lessons != null) {
                        for(Lesson lesson : lessons) {
                            if(lesson.getId() == term.getLessonId()) {
                                lessonTitle = lesson.getTitle();
                                break;
                            }
                        }
                    }
        %>
        <div class="flashcard" data-lesson-id="<%= term.getLessonId() %>">
            <div class="flashcard-content">
                <%= term.getContent() %>
            </div>
            <div class="flashcard-footer">
                <span><%= lessonTitle %></span>

                    <a class="btn btn-sm btn-primary"
                       href="card?action=add&termId=<%=term.getId()%>">
                        <i class="bi bi-plus-circle"></i>
                    </a>
            </div>
        </div>
        <% } } %>
    </div>



    <!-- Pagination -->
    <div class="pagination">
        <% if(totalPages > 1) { %>
        <!-- Previous page button -->
        <a href="?page=<%= Math.max(1, currentPage - 1) %>" class="pagination-item <%= currentPage == 1 ? "disabled" : "" %>">
            <i class="fas fa-chevron-left"></i>
        </a>

        <!-- Page numbers -->
        <%
            int startPage = Math.max(1, currentPage - 2);
            int endPage = Math.min(totalPages, startPage + 4);

            if(startPage > 1) { %>
        <a href="?page=1" class="pagination-item">1</a>
        <% if(startPage > 2) { %>
        <span class="pagination-item disabled">...</span>
        <% } %>
        <% } %>

        <% for(int i = startPage; i <= endPage; i++) { %>
        <a href="?page=<%= i %>" class="pagination-item <%= i == currentPage ? "active" : "" %>"><%= i %></a>
        <% } %>

        <% if(endPage < totalPages) { %>
        <% if(endPage < totalPages - 1) { %>
        <span class="pagination-item disabled">...</span>
        <% } %>
        <a href="?page=<%= totalPages %>" class="pagination-item"><%= totalPages %></a>
        <% } %>

        <!-- Next page button -->
        <a href="?page=<%= Math.min(totalPages, currentPage + 1) %>" class="pagination-item <%= currentPage == totalPages ? "disabled" : "" %>">
            <i class="fas fa-chevron-right"></i>
        </a>
        <% } %>
    </div>
</div>
<div class="footer">

        <jsp:include page="../Web/footer.jsp"></jsp:include>


</div>

</body>
<script>
    // Function to handle filtering by lesson
    document.getElementById('lessonFilter').addEventListener('change', function() {
        applyFilters();
    });

    // Function to handle content filtering
    document.getElementById('contentFilter').addEventListener('input', function() {
        applyFilters();
    });

    // Apply all active filters
    function applyFilters() {
        const selectedLessonId = document.getElementById('lessonFilter').value;
        const contentFilter = document.getElementById('contentFilter').value.toLowerCase();

        // Build query string for filters
        let queryParams = new URLSearchParams(window.location.search);

        // Reset to page 1 when filters change
        queryParams.set('page', '1');

        // Add filters to query string
        if(selectedLessonId) {
            queryParams.set('lessonId', selectedLessonId);
        } else {
            queryParams.delete('lessonId');
        }

        if(contentFilter) {
            queryParams.set('search', contentFilter);
        } else {
            queryParams.delete('search');
        }

        // Redirect with new filters
        window.location.href = window.location.pathname + '?' + queryParams.toString();
    }



    // Set initial filter values from URL
    window.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);

        // Set lesson filter
        const lessonId = urlParams.get('lessonId');
        if(lessonId) {
            document.getElementById('lessonFilter').value = lessonId;
        }

        // Set content filter
        const searchQuery = urlParams.get('search');
        if(searchQuery) {
            document.getElementById('contentFilter').value = searchQuery;
        }
    });
</script>
</html>