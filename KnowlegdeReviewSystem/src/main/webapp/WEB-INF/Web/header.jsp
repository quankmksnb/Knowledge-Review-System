<%@ page import="models.dao.SettingDAO" %>
<%@ page import="controllers.WebManager" %>
<%@ page import="models.Setting" %>
<%@ page import="models.SettingType" %>
<%@ page import="java.util.List" %>
<%@ page import="models.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            padding: 15px 30px;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .nav-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            max-width: 1400px;
            margin: 0 auto;
        }

        .logo img {
            height: 50px;
            transition: transform 0.3s ease;
        }

        .logo img:hover {
            transform: scale(1.1);
        }

        .header-dropdown {
            position: relative;
            margin: 0 20px;
        }

        .header-dropbtn {
            background: none;
            border: none;
            font-size: 16px;
            font-weight: 500;
            color: #333;
            padding: 12px 20px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .header-dropbtn:hover {
            color: #007bff;
        }

        .header-dropdown-content {
            display: none;
            position: absolute;
            background: white;
            border-radius: 8px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            min-width: 220px;
            z-index: 1000;
            overflow: hidden;
        }

        .header-dropdown:hover .header-dropdown-content {
            display: block;
        }

        .header-dropdown-content a {
            color: #333;
            padding: 12px 20px;
            text-decoration: none;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }

        .header-dropdown-content a:hover {
            background: #f8f9fa;
            color: #007bff;
        }

        .search-container {
            position: relative;
        }

        .search-box {
            display: flex;
            border: 1px solid #ddd;
            border-radius: 30px;
            background: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .search-box:hover {
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .search-box input {
            border: none;
            padding: 12px 20px;
            width: 300px;
            font-size: 15px;
            color: #333;
            outline: none;
        }

        .search-box button {
            border: none;
            background: #007bff;
            color: white;
            padding: 12px 20px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .search-box button:hover {
            background: #0056b3;
        }

        #searchResults {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border-radius: 8px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            max-height: 300px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
        }

        .result-item {
            padding: 12px 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            border-bottom: 1px solid #eee;
        }

        .result-item:last-child {
            border-bottom: none;
        }

        .result-item:hover {
            background: #f8f9fa;
            color: #007bff;
        }

        .no-results {
            padding: 12px 20px;
            color: #666;
            font-style: italic;
        }

        .login-btn {
            background: linear-gradient(45deg, #007bff, #00c4ff);
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s ease;
            margin-left: 10px;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 123, 255, 0.3);
            color: white;
        }

        .user-dropdown .header-dropbtn {
            display: flex;
            align-items: center;
            padding: 8px 15px;
            border-radius: 30px;
            transition: all 0.3s ease;
        }

        .user-dropdown .header-dropbtn:hover {
            background: #f8f9fa;
        }

        .user-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
            border: 2px solid #fff;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .my-class-link {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            padding: 12px 20px;
            transition: all 0.3s ease;
        }

        .my-class-link:hover {
            color: #007bff;
        }
    </style>
</head>

<body>
<header>
    <div class="nav-container">
        <!-- Logo -->
        <div class="logo">
            <a href="/home">
                <img src="Images/logo.png" alt="Logo">
            </a>
        </div>

        <!-- Navigation Links -->
        <div class="header-dropdown">
            <button class="header-dropbtn" onclick="location='/public-classes'">Public Classes</button>
        </div>

        <%
            SettingDAO settingDAO = WebManager.getInstance().getSettingDAO();
            List<Setting> categories = settingDAO.findAllByType(SettingType.Category);
            User user = (User) session.getAttribute("user");
            String myQuizHref = "#";
            if (user != null) {
                if(user.getRoleId() == 3) {
        %>

            <a href="/my-class" class="my-class-link">My Class</a>

        <% }  else { %>
            <a href="/class_teacher" class="my-class-link">My Class</a>

        <%} %>

        <div>
            <a id="myQuiz" href="/my_quiz" style="text-decoration: none; color: black">My Quiz</a>
        </div>

        <div>
            <a id="myFlashcard" href="/card?action=choose" style="text-decoration: none; color: black">My Flashcard</a>
        </div>


        <%}%>

        <!-- Search Bar -->
        <div class="search-container">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search for subjects..." oninput="debounceSearch()">
                <button type="submit"><i class="fas fa-search"></i></button>
            </div>
            <div id="searchResults"></div>
        </div>

        <!-- User Login/Profile Dropdown -->
        <div class="user-dropdown">
            <% if (user == null) { %>
            <a href="register" class="login-btn">Register</a>
            <a href="login" class="login-btn">Login</a>
            <% } else { %>
            <div class="header-dropdown">
                <button class="header-dropbtn">
                    <img src="<%= user.getAvatar() != null ? user.getAvatar() : "Images/default-avatar.png" %>"
                         alt="User Avatar" class="user-avatar">
                    <span><%= user.getFullName() %></span>
                </button>
                <div class="header-dropdown-content">
                    <a href="profile"><i class="fas fa-user me-2"></i>Profile</a>
                    <% if(user.getRoleId() != 3) { %>
                    <a href="admin"><i class="fas fa-cog me-2"></i>Web Settings</a>
                    <% } %>
                    <a href="#" onclick="logout()"><i class="fas fa-sign-out-alt me-2"></i>Logout</a>
                </div>
            </div>
            <% } %>
        </div>
    </div>

    <script>
        function logout() {
            fetch('/logout', {
                method: 'GET',
                credentials: 'same-origin',
            })
                .then(response => {
                    if (response.ok) {
                        window.location.href = 'login';
                    } else {
                        alert('Error logging out. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error logging out. Please try again.');
                });
        }

        let debounceTimer;
        function debounceSearch() {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(searchSubjects, 300);
        }

        function searchSubjects() {
            let query = $("#searchInput").val();
            if (query.length < 2) {
                $("#searchResults").hide();
                return;
            }

            $.ajax({
                url: "/searchClasses",
                type: "GET",
                data: { query: query },
                dataType: "json",
                success: function(data) {
                    let html = "";
                    if (data.length === 0) {
                        html = `<div class="no-results">No results found</div>`;
                    } else {
                        data.forEach(subject => {
                            html += `<div class="result-item" onclick="selectSubject('${subject.id}', '${subject.className} - ${subject.code}')">
                                        <strong>${subject.className}</strong> - ${subject.code}
                                    </div>`;
                        });
                    }
                    $("#searchResults").html(html).show();
                },
                error: function() {
                    $("#searchResults").html(`<div class="no-results">Error fetching results</div>`).show();
                }
            });
        }

        function selectSubject(id, displayName) {
            $("#searchInput").val(displayName); // Show the class name and code in the input
            $("#searchResults").hide();
            window.location.href = '/class-enroll?class-id=' + id;
        }

        $(document).on("click", function(event) {
            if (!$(event.target).closest("#searchInput, #searchResults").length) {
                $("#searchResults").hide();
            }
        });
    </script>
</header>
</body>
</html>