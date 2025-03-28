<%@ page import="models.User" %>
<%@ page import="models.Term" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Lesson" %>
<%@ page import="models.dao.DTOSubject" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Flashcards</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="CSS/Card/listcard.css">

</head>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
      rel="stylesheet">
<%List<Term> terms = (List<Term>) request.getAttribute("terms");%>
<% List<DTOSubject> subjects = (List<DTOSubject>) request.getAttribute("subjects");%>
<% List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");%>
<body>





<div class="container">
    <div class="title">
        <div>
            <h1 class="page-title">My Flashcard</h1>

        </div>
        <a class="btn-primary"
           href="card?action=list">
            <i class="bi bi-arrow-return-left">Back to All Flash Card</i>
        </a>

    </div>

    <div class="toast-container">
        <div id="statusToast" class="toast custom-toast hide" role="alert" aria-live="assertive" aria-atomic="true" data-bs-delay="1500">
            <div class="toast-header">
                <i class="bi me-2" id="toastIcon"></i>
                <strong class="me-auto" id="toastTitle"></strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body" id="toastMessage"></div>
        </div>
    </div>
    <div class="filters">
        <div class="filter-group">
            <form action="card">
                <input type="hidden" name="action" value="user">
                <label for="contentFilter" class="filter-label">Flashcard Content:</label>
                <input name="content"  type="text" class="filter-input" id="contentFilter" placeholder="Search flashcards..."/>

                <button style="opacity: 0;" type="submit"></button>
            </form>
        </div>


        <div class="filter-group">
            <label class="filter-label">Filter by Subject:</label>
            <select class="filter-select" id="lessonFilter">
                <option value="">All Subject</option>
                <% if(subjects != null) {
                    for(DTOSubject subject : subjects) { %>
                <option value="<%= subject.getId() %>"><%= subject.getName() %></option>
                <% } } %>
            </select>
        </div>
    </div>

    <div class="flashcard-grid" style="grid-template-columns: repeat(auto-fill, minmax(450px, 1fr))" id="flashcardContainer">
        <%
            int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            int itemsPerPage = 6; // Number of cards per page
            int totalItems = terms != null ? terms.size() : 0;
            int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
            int startIndex = (currentPage - 1) * itemsPerPage;
            int endIndex = Math.min(startIndex + itemsPerPage, totalItems);

            if(terms != null) {
                for(int i = startIndex; i < endIndex; i++) {
                    Term term = terms.get(i);
                    String lessonTitle = "";
                    if(subjects != null) {
                        for(DTOSubject subject : subjects) {
                            if(subject.getId() == term.getLessonId()) {
                                lessonTitle = subject.getName();
                                break;
                            }
                        }
                    }
        %>
        <div class="flashcard" data-lesson-id="<%= term.getLessonId() %>">
            <div class="flashcard-content"
                 data-title="<%= term.getTitle() %>"
                 data-content="<%= term.getContent() %>">
                <%= term.getTitle() %>
            </div>
            <div class="flashcard-footer">
                <%for (Lesson lesson : lessons) {
                    if (lesson.getId() == term.getLessonId()) {
                %>
                <span><%= lesson.getTitle() %></span>
                <%
                        }
                    }%>

                <a class="btn btn-sm btn-primary"
                     href="card?action=delete&termId=<%=term.getId()%>">
                <i class="bi bi-trash"></i>
            </a>
            </div>
        </div>
        <% } } %>
    </div>



    <div class="pagination">
        <% if(totalPages > 1) { %>
        <a href="?page=<%= Math.max(1, currentPage - 1) %>" class="pagination-item <%= currentPage == 1 ? "disabled" : "" %>">
            <i class="fas fa-chevron-left"></i>
        </a>

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

        <a href="?page=<%= Math.min(totalPages, currentPage + 1) %>" class="pagination-item <%= currentPage == totalPages ? "disabled" : "" %>">
            <i class="fas fa-chevron-right"></i>
        </a>
        <% } %>
    </div>
</div>

</body>
<script>
    document.getElementById('lessonFilter').addEventListener('change', function() {
        applyFilters();
    });



    function applyFilters() {
        const selectedLessonId = document.getElementById('lessonFilter').value;

        let queryParams = new URLSearchParams(window.location.search);

        queryParams.set('page', '1');

        if(selectedLessonId) {
            queryParams.set('lessonId', selectedLessonId);
        } else {
            queryParams.delete('lessonId');
        }


        window.location.href = window.location.pathname + '?' + queryParams.toString();
    }



    window.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);

        const lessonId = urlParams.get('lessonId');
        if(lessonId) {
            document.getElementById('lessonFilter').value = lessonId;
        }


    });
    document.addEventListener('DOMContentLoaded', function() {
        const flashcards = document.querySelectorAll('.flashcard');

        flashcards.forEach(flashcard => {
            const content = flashcard.querySelector('.flashcard-content');

            const title = content.getAttribute('data-title');
            const cardContent = content.getAttribute('data-content');

            content.textContent = title;

            let isShowingTitle = true;

            content.addEventListener('click', function() {
                if (isShowingTitle) {
                    content.textContent = cardContent;
                    content.classList.add('flipped');
                } else {
                    content.textContent = title;
                    content.classList.remove('flipped');
                }

                isShowingTitle = !isShowingTitle;
            });
        });
    });

    const urlParams = new URLSearchParams(window.location.search);
    const status = urlParams.get('status');

    if (status) {
        showToast(status);
    }

    function showToast(status) {
        const toast = document.getElementById('statusToast');
        const toastIcon = document.getElementById('toastIcon');
        const toastTitle = document.getElementById('toastTitle');
        const toastMessage = document.getElementById('toastMessage');

        if (status === 'success') {
            toast.classList.add('toast-success');
            toastIcon.classList.add('bi-check-circle');
            toastTitle.textContent = 'Success';
            toastMessage.textContent = 'Operation completed successfully!';
        } else if (status === 'unsuccess') {
            toast.classList.add('toast-error');
            toastIcon.classList.add('bi-x-circle');
            toastTitle.textContent = 'Error';
            toastMessage.textContent = 'Operation failed. Please try again.';
        }

        const bsToast = new bootstrap.Toast(toast);
        bsToast.show();
    }
</script>
</html>