<%@ page import="models.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>KRS - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background: #f5f7fa;
        }



        .dashboard-banner h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 15px;
            text-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .dashboard-banner p {
            font-size: 1.1rem;
            margin-bottom: 20px;
            color: rgba(255,255,255,0.9);
        }

        /* User Dropdown */
        .user-dropdown {
            position: absolute;
            top: 20px;
            right: 20px;
        }

        .header-dropdown {
            position: relative;
            display: inline-block;
        }

        .header-dropbtn {
            background-color: transparent;
            color: white;
            padding: 10px;
            font-size: 16px;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
        }

        .header-dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            background-color: #f9f9f9;
            min-width: 180px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
            border-radius: 8px;
        }

        .header-dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }

        .header-dropdown-content a:hover {
            background-color: #f1f1f1;
        }

        .header-dropdown:hover .header-dropdown-content {
            display: block;
        }

        /* Quick Access Section */
        .quick-access-section {
            padding: 60px 0;
            background: #fff;
        }

        .quick-access-section h2 {
            text-align: center;
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 40px;
        }

        .dashboard-card {
            text-align: center;
            padding: 25px;
            background: #f8f9fa;
            border-radius: 10px;
            transition: all 0.3s ease;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.15);
        }

        .dashboard-card i {
            font-size: 3rem;
            color: #007bff;
            margin-bottom: 15px;
        }

        .dashboard-card h3 {
            font-size: 1.3rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }

        .dashboard-card p {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 15px;
        }

        .dashboard-card .btn {
            background: #007bff;
            color: white;
            padding: 10px 20px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .dashboard-card .btn:hover {
            background: #0056b3;
        }

        @media (max-width: 768px) {
            .dashboard-banner {
                padding: 50px 0 30px;
            }

            .dashboard-banner h1 {
                font-size: 2rem;
            }

            .dashboard-banner p {
                font-size: 1rem;
            }

            .user-dropdown {
                position: relative;
                top: 0;
                right: 0;
                text-align: right;
                padding: 15px;
                background-color: rgba(0,0,0,0.1);
            }
        }
    </style>
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRoleId() == 3) {
        request.getRequestDispatcher("../Web/error.jsp").forward(request, response);
    }
%>



<!-- Quick Access Section -->
<section class="quick-access-section">
    <div class="container">
        <h2>Quick Access</h2>
        <div class="row">


            <% if (user.getRoleId() == 1) { %>
            <div class="col-md-4 col-sm-6">
                <div class="dashboard-card">
                    <i class="bi bi-person-circle"></i>
                    <h3>User Management</h3>
                    <p>Manage user accounts and access levels.</p>
                    <a href="/user" class="btn">Manage Users</a>
                </div>
            </div>
            <% } %>

            <% if (user.getRoleId() == 1 || user.getRoleId() == 5) { %>
            <div class="col-md-4 col-sm-6">
                <div class="dashboard-card">
                    <i class="bi bi-book"></i>
                    <h3>Subject Management</h3>
                    <p>View and manage educational subjects.</p>
                    <a href="/subject" class="btn">Manage Subjects</a>
                </div>
            </div>
            <% } %>

            <% if (user.getRoleId() == 2) { %>
            <div class="col-md-4 col-sm-6">
                <div class="dashboard-card">
                    <i class="bi bi-people"></i>
                    <h3>Class Teacher</h3>
                    <p>Organize and track class information.</p>
                    <a href="/class_teacher" class="btn">Manage Classes</a>
                </div>
            </div>
            <% } %>

            <% if (user.getRoleId() == 1 || user.getRoleId() == 4 || user.getRoleId() == 5) { %>
            <div class="col-md-4 col-sm-6">
                <div class="dashboard-card">
                    <i class="bi bi-people"></i>
                    <h3>Class Management</h3>
                    <p>Organize and track class information.</p>
                    <a href="/class_management" class="btn">Manage Classes</a>
                </div>
            </div>
            <% } %>

            <% if (user.getRoleId() == 1) { %>
            <div class="col-md-4 col-sm-6">
                <div class="dashboard-card">
                    <i class="bi bi-gear"></i>
                    <h3>System Settings</h3>
                    <p>Configure platform-wide settings and preferences.</p>
                    <a href="/setting" class="btn">System Settings</a>
                </div>
            </div>
            <% } %>

            <% if (user.getRoleId() == 1 || user.getRoleId() == 5) { %>
            <div class="col-md-4 col-sm-6">
                <div class="dashboard-card">
                    <i class="bi bi-question-octagon"></i>
                    <h3>Question Bank</h3>
                    <p>Create and manage quiz questions.</p>
                    <a href="question?action=choose" class="btn">Manage Questions</a>
                </div>
            </div>
            <% } %>

            <% if (user.getRoleId() == 1 || user.getRoleId() == 5) { %>
            <div class="col-md-4 col-sm-6">
                <div class="dashboard-card">
                    <i class="bi bi-journal-text"></i>
                    <h3>Term Management</h3>
                    <p>Manage academic terms and periods.</p>
                    <a href="term?action=choose" class="btn">Manage Terms</a>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="../Web/footer.jsp"></jsp:include>

<script>
    function logout() {
        // Implement logout functionality
        window.location.href = "logout";
    }
</script>
</body>
</html>