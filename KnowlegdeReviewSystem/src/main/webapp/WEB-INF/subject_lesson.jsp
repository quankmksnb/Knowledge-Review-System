<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="models.Lesson"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Subject Lesson</title>
        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body class="bg-light">

        <div class="container mt-4">
            <h2 class="text-center fw-bold">📘 Subject Lesson</h2>

            <!-- Search & New Lesson -->
            <div class="d-flex justify-content-between align-items-center bg-danger text-white p-3 rounded">
                <form action="subjectLesson" method="get">

                    <input name="textSearch" type="text" class="form-control w-50" placeholder="🔍 Search Lesson..." id="searchBox">
                </form>

                <a href="add_lesson.jsp">
                    <button class="btn btn-success">➕ New Lesson</button>

                </a>
            </div>

            <!-- Lesson Table -->
            <div class="table-responsive mt-3">
                <table class="table table-bordered table-striped text-center">
                    <thead class="bg-success text-white">
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Description</th>
                            <th>Created At</th>
                            <th>Modified By</th>
                            <th>Modified At</th>
                            <th>⚙ Action</th>
                        </tr>
                    </thead>
                    <tbody>

                        <%
                           String message = request.getParameter("message");
                           String deleted = request.getParameter("deleted");

                           String alertClass = "";
                           String alertMessage = "";

                           if ("success".equals(message)) {
                               alertClass = "bg-success";
                               alertMessage = "✅ Lesson added successfully!";
                           } else if ("error".equals(message)) {
                               alertClass = "bg-danger";
                               alertMessage = "❌ Operation failed! Please try again.";
                           } else if ("success".equals(deleted)) { // Kiểm tra xóa thành công
                               alertClass = "bg-warning";
                               alertMessage = "🗑 Lesson deleted successfully!";
                           } else if ("error".equals(deleted)) { // Kiểm tra xóa thất bại
                               alertClass = "bg-danger";
                               alertMessage = "❌ Lesson deletion failed! Please try again.";
                           }
    
                           if (!alertMessage.isEmpty()) { 
                        %>
                        <!-- Popup thông báo -->
                    <div id="popupMessage" class="position-fixed top-0 end-0 mt-3 me-3 p-3 text-white rounded shadow-lg <%= alertClass %>" 
                         style="z-index: 1050; display: none;">
                        <%= alertMessage %>
                    </div>

                    <script>
                        // Hiển thị popup
                        document.getElementById("popupMessage").style.display = "block";

                        // Ẩn sau 5s
                        setTimeout(() => {
                            let popup = document.getElementById("popupMessage");
                            popup.style.opacity = "0";
                            setTimeout(() => popup.style.display = "none", 500);
                        }, 5000);
                    </script>
                    <% } %>


                    <%
                        List<Lesson> lessonList = (List<Lesson>) request.getAttribute("lessonList");
                        if (lessonList != null) {
                            for (Lesson lesson : lessonList) {
                    %>
                    <tr>
                        <td class="fw-bold text-danger"><%= lesson.getId() %></td> 
                        <td><%= lesson.getTitle() %></td> 
                        <td><%= lesson.getDescription() %></td> 
                        <td><%= lesson.getCreatedAt() %></td> 
                        <td><%= lesson.getModifiedBy() %></td> 
                        <td><%= lesson.getModifiedAt() %></td> 
                        <td>
                            <a href="subjectLesson?id=<%= lesson.getId() %>&action=edit">
                                <button class="btn btn-warning btn-sm">✏ Edit</button>

                            </a>
                            <a href="#" onclick="deleteLesson(<%= lesson.getId() %>)">
                                <button class="btn btn-danger btn-sm">🗑 Delete</button>
                            </a>

                            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                            <script>
                                function deleteLesson(id) {
                                    Swal.fire({
                                        title: "Bạn có chắc chắn muốn xóa?",
                                        text: "Dữ liệu không thể khôi phục sau khi xóa!",
                                        icon: "warning",
                                        showCancelButton: true,
                                        confirmButtonColor: "#d33",
                                        cancelButtonColor: "#3085d6",
                                        confirmButtonText: "Xóa ngay!",
                                        cancelButtonText: "Hủy"
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            window.location.href = "subjectLesson?id=" + id + "&action=delete";
                                        }
                                    });
                                }
                            </script>

                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="7" class="text-center text-danger fw-bold">No lessons available</td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    let rowsPerPage = 5; // Số dòng mỗi trang
                    let table = document.querySelector("table tbody");
                    let rows = table.querySelectorAll("tr");
                    let totalPages = Math.ceil(rows.length / rowsPerPage);
                    let currentPage = 1;

                    function showPage(page) {
                        let start = (page - 1) * rowsPerPage;
                        let end = start + rowsPerPage;

                        rows.forEach((row, index) => {
                            row.style.display = index >= start && index < end ? "table-row" : "none";
                        });

                        document.getElementById("currentPage").textContent = page;
                        document.getElementById("prevPage").disabled = page === 1;
                        document.getElementById("nextPage").disabled = page === totalPages;
                    }

                    document.getElementById("prevPage").addEventListener("click", function () {
                        if (currentPage > 1) {
                            currentPage--;
                            showPage(currentPage);
                        }
                    });

                    document.getElementById("nextPage").addEventListener("click", function () {
                        if (currentPage < totalPages) {
                            currentPage++;
                            showPage(currentPage);
                        }
                    });

                    showPage(currentPage);
                });
            </script>

            <!-- Thêm phần phân trang vào HTML -->
            <div class="d-flex justify-content-center align-items-center mt-3">
                <button id="prevPage" class="btn btn-outline-primary me-2">Previous</button>
                <span id="currentPage" class="fw-bold">1</span>
                <button id="nextPage" class="btn btn-outline-primary ms-2">Next</button>
            </div>



        </div>

    </body>
</html>
