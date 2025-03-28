<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="models.Subject" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="models.User" %>
<%@ page isELIgnored="false" %>

<html>
<head>
    <title>Update Subject</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="CSS/SubjectDetail/formsubjectdetail.css">

</head>
<body>
<%
    Subject subject = (Subject) session.getAttribute("subject");
    String subjectName = subject.getSubjectName();
    int subjectId = subject.getId();
%>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <jsp:include page="../Admin/homeAdmin.jsp"></jsp:include>

        <!-- Main Content -->
        <div class="col p-0">
            <!-- Header -->
            <div class="header-bar d-flex justify-content-between align-items-center px-4 bg-white shadow-sm py-3">
                <div class="header-title"><%=subject.getSubjectName()%> Management</div>
            </div>

            <!-- Navigation Tabs -->
            <div class="container mt-6">
                <div class="container-box">
                    <ul class="nav nav-tabs">
                        <li class="nav-item">
                            <a class="nav-link active" href="subject">GENERAL</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="lesson_list?subjectId=<%=subjectId%>">LESSON</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="config">CONFIG</a>
                        </li>
                    </ul>
                </div>
                <!-- Subject Information Section -->
                <div class="container">


                    <div class="form-container">
                        <div class="header-bar" >Subject Information</div>
                        <form action="subject" method="POST">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="<%=subject.getId()%>">

                            <div class="row">
                                <div class="col-md-6">
                                    <label for="code" class="form-label">Subject Code</label>
                                    <input type="text" class="form-control" id="code" name="code" value="${subject.code}"
                                           required>
                                </div>
                                <div class="col-md-6">
                                    <label for="name" class="form-label">Subject Name</label>
                                    <input type="text" class="form-control" id="name" name="name"
                                           value="<%=subject.getSubjectName()%>" required>
                                </div>
                                <div class="col-md-12">
                                    <label for="description" class="form-label">Description</label>
                                    <textarea class="form-control" id="description" name="description"
                                              rows="3"><%=subject.getDescription()%></textarea>
                                </div>
                                <div class="col-md-6">
                                    <label for="domain" class="form-label">Domain</label>
                                    <select class="form-select" id="domain" name="domain">
                                        <% HashMap<Integer, String> map = (HashMap<Integer, String>) request.getAttribute("map"); %>
                                        <% for (HashMap.Entry<Integer, String> entry : map.entrySet()) { %>
                                        <option value="<%= entry.getKey() %>" <%=subject.getDomainId() == entry.getKey() ? "selected" : ""%>>
                                            <%= entry.getValue() %>
                                        </option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Status</label>
                                    <div class="mt-2">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="status" id="statusActive"
                                                   value="Active" <%=(subject.isStatus()) ? "checked" : ""%>>
                                            <label class="form-check-label" for="statusActive">Active</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="status" id="statusInactive"
                                                   value="Inactive" <%=(!subject.isStatus()) ? "checked" : ""%>>
                                            <label class="form-check-label" for="statusInactive">Inactive</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">

                                    <label class="form-label" for="manage">Manage By</label>

                                    <input type="text" class="form-control popup" id="manage" name="manage" value="admin" readonly>
                                </div>
                            </div>
                            <div class="text-end">
                                <input type="submit" name="submit" value="Change" class="btn-primary">
                            </div>
                        </form>
                    </div>
                </div>
            </div>


        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>