<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/23/2025
  Time: 6:42 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page isELIgnored="false" %>
<html>
<head>
    <title>My Quiz List</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <link href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="CSS/Quiz/quizList.css">
</head>

<body>
<%
    String message = (String) session.getAttribute("message");
    session.removeAttribute("message");
%>
<%--    Dòng hiện thị thông báo--%>
<div id="toastMessage" class="toast align-items-center text-white bg-success border-0 position-fixed top-0 end-0"
     role="alert" aria-live="assertive" aria-atomic="true">
    <div class="d-flex">
        <div class="toast-body text-center">
            <%= message != null ? message : "" %>
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                aria-label="Close"></button>
    </div>
</div>
<jsp:include page="../Web/header.jsp"></jsp:include>

<div class="container">
    <!-- Table with dropdown and search -->
    <div class="table-container">
        <!-- Bọc phần dropdown và search vào trong bảng -->
        <div class="dropdown-container">
            <div class="d-flex align-items-center gap-4">
                <!-- Subject dropdown -->
                <div>
                    <select class="form-select" id="subjectFilter" onchange="updateLessonsBySubject(); filterTable();">
                        <option value="">Select Subject</option>
                        <c:forEach var="subject" items="${enrolledSubjects}">
                            <option value="${subject.id}">${subject.subjectName}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Lesson dropdown -->
                <div>
                    <select class="form-select" id="lessonFilter" onchange="updateSubjectByLesson(); filterTable();">
                        <option value="">Select Lesson</option>
                        <c:forEach var="lesson" items="${lessons}">
                            <option value="${lesson.id}" data-subject="${lesson.subjectId}">${lesson.title}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Search input -->
                <div class="position-relative">
                    <input oninput="filterTable()" type="text" id="searchQuiz" class="form-control search-input"
                           placeholder="Search quiz...">
                </div>

                <!-- Status dropdown -->
                <div>
                    <select class="form-select" id="statusFilter" onchange="filterTable()">
                        <option value="">All Status</option>
                        <option value="Completed">Completed</option>
                        <option value="Unfinished">Unfinished</option>
                    </select>
                </div>
            </div>
            <div class="d-flex gap-2">
                <button type="button" class="btn btn-primary shadow-sm" data-bs-toggle="modal"
                        data-bs-target="#newQuizModal">
                    <i class="bi bi-plus-circle"></i> New Quiz
                </button>
            </div>
        </div>

        <!-- Table displaying quizzes -->
        <div class="table-responsive content-table">
            <table class="table" id="quizContentTable">
                <thead>
                <tr>
                    <th>Quiz Name</th>
                    <th>Lesson</th>
                    <th>Number of Questions</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody id="quizContent">
                <c:forEach var="quiz" items="${quizList}">
                    <tr>
                        <td>${quiz.quizName}</td>
                        <td>${quizLessonTitleMap[quiz.id]}</td>
                        <td>${quiz.numOfQuestions}</td>
                        <td>
                            <span class="badge
                                <c:choose>
                                    <c:when test="${quiz.status == 'Completed'}">bg-success</c:when>
                                    <c:when test="${quiz.status == 'Unfinished'}">bg-secondary</c:when>
                                    <c:otherwise>bg-warning</c:otherwise>
                                </c:choose>">
                                    ${quiz.status}
                            </span>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${quiz.status == 'Completed'}">
                                    <!-- Chỉ hiển thị Review Quiz khi status là Completed -->
                                    <a href="quiz_result?quizId=${quiz.id}" class="btn btn-sm btn-success"
                                       title="Review Quiz">
                                        <i class="bi bi-file-earmark-text-fill"></i> Review Quiz
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <!-- Hiển thị Start và Details khi status là Unfinished -->
                                    <a href="take_quiz?quizId=${quiz.id}" class="btn btn-sm btn-primary"
                                       title="Start Quiz">
                                        <i class="bi bi-play-circle-fill"></i> Start
                                    </a>

                                    <a href="quiz_detail?id=${quiz.id}" class="btn btn-sm btn-primary"
                                       title="Quiz Detail">
                                        <i class="bi bi-pencil-square"></i> Details
                                    </a>

                                </c:otherwise>
                            </c:choose>
                        </td>

                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <div class="pagination">
            <%
                // Lấy giá trị currentPage và totalPages từ request
                int currentPage = (int) request.getAttribute("currentPage");
                int totalPages = (int) request.getAttribute("totalPages");

                if (totalPages > 1) {
            %>
            <a href="?page=<%= Math.max(1, currentPage - 1) %>"
               class="pagination-item <%= currentPage == 1 ? "disabled" : "" %>">
                <i class="fas fa-chevron-left"></i>
            </a>

            <%
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, startPage + 4);

                if (startPage > 1) {
            %>
            <a href="?page=1" class="pagination-item">1</a>
            <% if (startPage > 2) { %>
            <span class="pagination-item disabled">...</span>
            <% } %>
            <% } %>

            <% for (int i = startPage; i <= endPage; i++) { %>
            <a href="?page=<%= i %>" class="pagination-item <%= i == currentPage ? "active" : "" %>"><%= i %>
            </a>
            <% } %>

            <% if (endPage < totalPages) { %>
            <% if (endPage < totalPages - 1) { %>
            <span class="pagination-item disabled">...</span>
            <% } %>
            <a href="?page=<%= totalPages %>" class="pagination-item"><%= totalPages %>
            </a>
            <% } %>

            <a href="?page=<%= Math.min(totalPages, currentPage + 1) %>"
               class="pagination-item <%= currentPage == totalPages ? "disabled" : "" %>">
                <i class="fas fa-chevron-right"></i>
            </a>
            <% } %>
        </div>


    </div>
</div>
<%-- New Quiz Modal --%>
<div class="modal fade" id="newQuizModal" tabindex="-1" aria-labelledby="newQuizModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form id="quizForm" action="/my_quiz?action=create" method="post">
                <div class="modal-header d-flex align-items-center justify-content-between">
                    <h3 class="modal-title" id="newQuizModalLabel">Create Quiz</h3>
                    <div class="d-flex align-items-center">
                        <button type="button" class="btn-close ms-2" data-bs-dismiss="modal"
                                aria-label="Close"></button>
                    </div>
                </div>

                <div class="modal-body">
                    <div class="mb-3">
                        <label for="quizName" class="form-label">Quiz Name</label>
                        <input type="text" class="form-control popup" id="quizName" name="quizName" required>
                        <small id="quizNameError" class="warning-text text-danger mt-2"></small>
                        <!-- Error message for Quiz Name -->
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="subject" class="form-label">Subject</label>
                            <select class="form-select popup" id="subject" name="subject" required
                                    onchange="updateLessonsBySubjectInModal()">
                                <option value="">Select Subject</option>
                                <c:forEach var="subject" items="${enrolledSubjects}">
                                    <option value="${subject.id}">${subject.subjectName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="lesson" class="form-label">Lesson</label>
                            <select class="form-select popup" id="lesson" name="lesson" required
                                    onchange="updateSubjectByLessonInModal() ; updateQuestionLimitInModal()">
                                <option value="">Select Lesson</option>
                                <c:forEach var="lesson" items="${lessons}">
                                    <option value="${lesson.id}"
                                            data-subject="${lesson.subjectId}">${lesson.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Number of Questions</label>
                        <input type="number" name="numOfQuestions" id="numOfQuestions" value="${quiz.numOfQuestions}"
                               class="form-control popup" required>
                        <small id="maxQuestionsWarning" class="warning-text text-info mt-2"></small>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 rounded-3 shadow-sm mt-3">Create Quiz
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<footer class="site-footer">
    <jsp:include page="../Web/footer.jsp"></jsp:include>
</footer>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.0.2/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
<script>
    function updateLessonsBySubject() {
        var subjectId = document.getElementById("subjectFilter").value;
        var lessonDropdown = document.getElementById("lessonFilter");

        // Xóa các lựa chọn cũ trong Lesson dropdown
        lessonDropdown.innerHTML = '<option value="">Select Lesson</option>';

        if (subjectId !== "") {
            // Gọi AJAX để lấy bài học tương ứng với subjectId
            $.ajax({
                url: "/getLessonsBySubject", // Gọi servlet lấy Lesson
                type: "GET",
                data: {subjectId: subjectId},
                success: function (data) {
                    // Thêm các bài học vào dropdown
                    data.forEach(function (lesson) {
                        var option = document.createElement("option");
                        option.value = lesson.id;
                        option.textContent = lesson.title;
                        option.setAttribute("data-subject", lesson.subjectId); // Đảm bảo mỗi option có data-subject
                        lessonDropdown.appendChild(option);
                    });

                    // Giữ lại giá trị lesson đã chọn nếu có
                    var selectedLesson = document.getElementById("lessonFilter").value;
                    if (selectedLesson !== "") {
                        lessonDropdown.value = selectedLesson;
                    }
                },
                error: function (xhr) {
                    console.error("Error fetching lessons:", xhr);
                }
            });
        }
    }


    function updateSubjectByLesson() {
        var lessonId = document.getElementById("lessonFilter").value;
        var subjectDropdown = document.getElementById("subjectFilter");

        // Kiểm tra nếu có lesson đã chọn
        if (lessonId !== "") {
            // Lấy thông tin về bài học đã chọn
            var lessonOptions = document.getElementById("lessonFilter").options;
            var selectedLessonOption = Array.from(lessonOptions).find(function (option) {
                return option.value == lessonId;
            });

            if (selectedLessonOption) {
                // Lấy subjectId của lesson đã chọn
                var subjectId = selectedLessonOption.getAttribute("data-subject");

                // Cập nhật lại Subject dropdown với subjectId tương ứng
                subjectDropdown.value = subjectId; // Giữ lại giá trị subject đã chọn
            }
        } else {
            // Nếu không chọn lesson thì reset lại subject filter
            subjectDropdown.value = "";
        }
    }


    function updateLessonsBySubjectInModal() {
        var subjectId = document.getElementById("subject").value;
        var lessonDropdown = document.getElementById("lesson");

        // Xóa các lựa chọn cũ trong Lesson dropdown
        lessonDropdown.innerHTML = '<option value="">Select Lesson</option>';

        if (subjectId !== "") {
            // Gọi AJAX để lấy bài học tương ứng với subjectId
            $.ajax({
                url: "/getLessonsBySubject", // Gọi servlet lấy Lesson
                type: "GET",
                data: {subjectId: subjectId},
                success: function (data) {
                    // Thêm các bài học vào dropdown
                    data.forEach(function (lesson) {
                        var option = document.createElement("option");
                        option.value = lesson.id;
                        option.textContent = lesson.title;
                        option.setAttribute("data-subject", lesson.subjectId); // Đảm bảo mỗi option có data-subject
                        lessonDropdown.appendChild(option);
                    });

                    // Giữ lại giá trị lesson đã chọn nếu có
                    var selectedLesson = document.getElementById("lesson").value;
                    if (selectedLesson !== "") {
                        lessonDropdown.value = selectedLesson;
                    }

                    // Kiểm tra lại số câu hỏi khi lesson thay đổi
                    updateQuestionLimit();
                },
                error: function (xhr) {
                    console.error("Error fetching lessons:", xhr);
                }
            });
        }
    }


    function updateSubjectByLessonInModal() {
        var lessonId = document.getElementById("lesson").value;
        var subjectDropdown = document.getElementById("subject");

        // Kiểm tra nếu có lesson đã chọn
        if (lessonId !== "") {
            // Lấy thông tin về bài học đã chọn
            var lessonOptions = document.getElementById("lesson").options;
            var selectedLessonOption = Array.from(lessonOptions).find(function (option) {
                return option.value == lessonId;
            });

            if (selectedLessonOption) {
                // Lấy subjectId của lesson đã chọn
                var subjectId = selectedLessonOption.getAttribute("data-subject");

                // Cập nhật lại Subject dropdown với subjectId tương ứng
                subjectDropdown.value = subjectId; // Giữ lại giá trị subject đã chọn
            }
        } else {
            // Nếu không chọn lesson thì reset lại subject filter
            subjectDropdown.value = "";
        }
    }

    // lấy ra question max khi thay đổi lesson
    function updateQuestionLimitInModal() {
        var lessonId = document.getElementById("lesson").value;
        if (lessonId) {
            $.ajax({
                url: "/getQuestionsCountByLesson",
                type: "GET",
                data: {lessonId: lessonId},
                success: function (response) {
                    if (response && response.maxQuestions !== undefined) {
                        var maxQuestions = response.maxQuestions;
                        document.getElementById("numOfQuestions").max = maxQuestions;
                        document.getElementById("maxQuestionsWarning").textContent = "Max questions: " + maxQuestions;
                    }
                },
                error: function (xhr, status, error) {
                    console.error("Error fetching question count:", error);
                }
            });
        }
    }


    document.getElementById("quizForm").addEventListener("submit", function (event) {
        let numOfQuestions = document.getElementById("numOfQuestions").value;
        let maxQuestions = document.getElementById("numOfQuestions").max;
        let quizName = document.getElementById("quizName").value;  // Get the quiz name value
        let quizNameErrorMessage = document.getElementById("quizNameError");  // The error message element for Quiz Name

        // Clear any previous error messages
        quizNameErrorMessage.textContent = '';

        // Check if the number of questions is less than 0
        if (parseInt(numOfQuestions) < 0) {
            event.preventDefault();  // Prevent form submission
            alert("The number of questions cannot be less than 0.");
            return;
        }

        // Check if the number of questions exceeds the max limit
        if (parseInt(numOfQuestions) > parseInt(maxQuestions)) {
            event.preventDefault();  // Prevent form submission
            alert(`The number of questions cannot be greater than ${maxQuestions}`);
            return;
        }

        // Check the length of the quiz name (should not exceed 20 characters)
        if (quizName.length > 20) {
            event.preventDefault();  // Prevent form submission
            quizNameErrorMessage.textContent = "Quiz Name should not exceed 20 characters.";  // Show error message
            document.getElementById("quizName").classList.add("is-invalid");  // Add invalid class for styling
            return;  // Stop form submission
        } else {
            // If the quiz name is valid, remove the invalid class (if any)
            document.getElementById("quizName").classList.remove("is-invalid");
        }
    });


    function filterTable() {
        var subjectId = document.getElementById("subjectFilter").value;
        var lessonId = document.getElementById("lessonFilter").value;
        var status = document.getElementById("statusFilter").value;
        var quizName = document.getElementById("searchQuiz").value;

        // Gửi yêu cầu AJAX tới servlet
        $.ajax({
            url: "/my_quiz/filter",  // URL của servlet trả về dữ liệu HTML cho <tbody>
            type: "GET",
            data: {
                subjectId: subjectId,
                lessonId: lessonId,
                status: status,
                quizName: quizName
            },
            success: function (response) {
                // Xử lý dữ liệu HTML trả về và cập nhật phần tbody của bảng
                var quizContent = document.getElementById("quizContent");
                quizContent.innerHTML = response;  // Cập nhật nội dung bảng trong tbody
            },
            error: function (xhr, status, error) {
                console.error("Error fetching filtered quizzes:", error);
            }
        });
    }

    // hiện thị thông báo và set time tồn tại 3 giây
    document.addEventListener("DOMContentLoaded", function () {
        let toastElement = document.getElementById("toastMessage");
        if (toastElement.innerText.trim() !== "") {
            let toast = new bootstrap.Toast(toastElement, {delay: 2000});
            toast.show();
        }
    });

    document.addEventListener("DOMContentLoaded", function () {
        let toastElement = document.getElementById("toastMessage");
        if (toastElement.innerText.trim() !== "") {
            let toast = new bootstrap.Toast(toastElement);
            toast.show();
        }
    });

</script>

</body>
</html>
