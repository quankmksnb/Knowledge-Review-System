<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="models.Setting"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Settings Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body class="bg-light">
        <div class="container mt-4">
            <h2 class="text-center fw-bold">⚙ Settings Management</h2>

            <!-- Search & Add New -->
            <div class="d-flex justify-content-between align-items-center bg-primary text-white p-3 rounded">
                <input type="text" class="form-control w-50" placeholder="🔍 Search Setting..." id="searchBox">



                <a href="add_setting.jsp">
                    <button class="btn btn-success">➕ Add Setting</button>
                </a>
            </div>
            <form action="setting" method="get">
                <select name="typeFilter" id="typeFilter" class="form-control w-25">
                    <option value="">All Types</option>
                    <option value="Role">Role</option>
                    <option value="Category">Category</option>
                </select>

                <button type="submit" class="btn btn-primary" id="filterBtn">Filter</button>
            </form>

            <!-- Settings Table -->
            <div class="table-responsive mt-3">
                <table class="table table-bordered table-striped text-center">
                    <thead class="bg-success text-white">
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Type</th>
                            <th>⚙ Action</th>
                        </tr>
                    </thead>
                    <tbody id="settingsTableBody">
                        <% 
                            List<Setting> settingList = (List<Setting>) request.getAttribute("settingList");
                            if (settingList != null && !settingList.isEmpty()) {
                                for (Setting setting : settingList) {
                        %>
                        <tr>
                            <td class="fw-bold text-primary"><%= setting.getId() %></td>
                            <td><%= setting.getTitle() %></td>
                            <td><%= setting.getType() %></td>
                            <td>
                                <a href="setting?id=<%= setting.getId() %>&action=detail">
                                    <button class="btn btn-info btn-sm">📄 Detail</button>
                                </a>
                            </td>
                        </tr>
                        <% 
                                }
                            } else { 
                        %>
                        <tr>
                            <td colspan="7" class="text-center text-danger fw-bold">No settings available</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div class="d-flex justify-content-between align-items-center">
                <button id="prevPage" class="btn btn-outline-primary">Previous</button>
                <span id="currentPage" class="fw-bold">1</span>
                <button id="nextPage" class="btn btn-outline-primary">Next</button>
            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const rowsPerPage = 3; // Number of rows per page
                const rows = document.querySelectorAll('#settingsTableBody tr'); // Get all rows in the table body
                const totalRows = rows.length;
                const totalPages = Math.ceil(totalRows / rowsPerPage); // Calculate total number of pages
                let currentPage = 1;

                // Function to show the current page
                function showPage(page) {
                    let start = (page - 1) * rowsPerPage;
                    let end = start + rowsPerPage;

                    // Display the rows for the current page
                    rows.forEach((row, index) => {
                        row.style.display = index >= start && index < end ? '' : 'none';
                    });

                    // Update current page number and button states
                    document.getElementById('currentPage').textContent = page;
                    document.getElementById('prevPage').disabled = page === 1;
                    document.getElementById('nextPage').disabled = page === totalPages;
                }

                // Event listeners for the pagination buttons
                document.getElementById('prevPage').addEventListener('click', function () {
                    if (currentPage > 1) {
                        currentPage--;
                        showPage(currentPage);
                    }
                });

                document.getElementById('nextPage').addEventListener('click', function () {
                    if (currentPage < totalPages) {
                        currentPage++;
                        showPage(currentPage);
                    }
                });

                // Initial page load
                showPage(currentPage);
            });
        </script>
    </body>
</html>
