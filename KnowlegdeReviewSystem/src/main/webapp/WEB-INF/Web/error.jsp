<%--
  Created by IntelliJ IDEA.
  User: PC
  Date: 3/28/2025
  Time: 10:57 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Access Denied</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            font-family: 'Arial', sans-serif;
        }
        .error-container {
            text-align: center;
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            width: 100%;
        }
        .error-icon {
            font-size: 80px;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .btn-custom {
            margin: 10px;
            padding: 10px 20px;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-icon">
        <i class="bi bi-lock-fill"></i>
    </div>
    <h1 class="mb-4">Access Denied</h1>
    <p class="text-muted mb-4">
        You do not have permission to access this page. Please log in or contact the administrator for permission.
    </p>
    <div>
        <a href="/home" class="btn btn-primary btn-custom">
            <i class="bi bi-house-door me-2"></i>Back to HomePage
        </a>

    </div>
</div>
</body>
</html>
