<%@ page import="models.User" %><%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 1/27/2025
  Time: 12:35 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page isELIgnored="false" %>

<html>
<head>
    <title>Update User</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="CSS/UserManagement/userUpdate.css">
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <%
            User user = (User) session.getAttribute("user");
        %>

        <jsp:include page="../../Admin/homeAdmin.jsp"></jsp:include>

        <div class="col p-0">
            <div class="header-bar">Information User</div>

            <div class="form-container">
                <form action="user_update" method="post">
                    <input type="hidden" name="id" value="${oldUser.id}" />
                    <div class="row">
                        <div class="col-md-6">
                            <label for="fullname" class="form-label">Fullname</label>
                            <input type="text" class="form-control" id="fullname" name="fullname" value="${oldUser.fullName}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" value="${oldUser.username}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" value="${oldUser.email}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label for="status" class="form-label">Status</label>
                            <input type="text" class="form-control" id="status" name="status" value="${oldUser.status}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label for="role" class="form-label">Role</label>
                            <select class="form-select" id="role" name="role">
                                <c:forEach var="role" items="${requestScope.settings}">
                                    <option value="${role.id}" <c:if test="${role.id == oldUser.roleId}">selected</c:if>>${role.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="createdAt" class="form-label">Created At</label>
                            <input type="text" class="form-control" id="createdAt" name="createdAt" value="${oldUser.createdAt}" readonly>
                        </div>
                    </div>
                    <button type="submit" class="btn-save mt-4">Save</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>

