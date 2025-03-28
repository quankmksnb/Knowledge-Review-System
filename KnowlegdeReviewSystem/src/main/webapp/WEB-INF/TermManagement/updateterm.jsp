<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="models.Term" %>
<%@ page import="models.DTOConfig" %>
<%@ page import="java.util.List" %>
<%@ page isELIgnored="false" %>

<html>
<head>
    <title>Update Term</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="CSS/Question/formquestion.css">

</head>
<body>
<%
    Term term = (Term) request.getAttribute("term");
    List<DTOConfig> configs = (List<DTOConfig>) request.getAttribute("configs");
%>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="../Admin/homeAdmin.jsp"></jsp:include>

        <div class="col p-0">
            <div class="header-bar d-flex justify-content-between align-items-center px-4 bg-white shadow-sm py-3">
                <div class="header-title">Term Detail</div>
            </div>

            <div class="container mt-6">


                <div class="container">
                    <div class="form-container">
                        <div class="header-bar">Term Information</div>
                        <form action="term" method="POST">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="<%= term.getId() %>">

                            <div class="row">
                                <div class="col-md-6">
                                    <label for="lesson" class="form-label">Lesson</label>
                                    <select class="form-select" id="lesson" name="lessonId" required>
                                        <option value="<%= term.getLessonId() %>" selected>
                                            <%= term.getLessonId() %>
                                        </option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="title" class="form-label">Title</label>
                                    <input type="text" class="form-control" id="title" name="title"
                                           value="<%= term.getTitle() %>" required>
                                </div>
                                <div class="col-md-12">
                                    <label for="content" class="form-label">Content</label>
                                    <textarea class="form-control" id="content" name="content"
                                              rows="3" required><%= term.getContent() %></textarea>
                                </div>
                                <div class="col-md-6">
                                    <label for="configId" class="form-label">Configuration</label>
                                    <select class="form-select" id="configId" name="configId" required>
                                        <% for (DTOConfig config1 : configs) { %>
                                        <option value="<%= config1.getId() %>">
                                            <%= config1.getDescription() %>
                                        </option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Status</label>
                                    <div class="mt-2">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="status"
                                                   id="statusActive" value="Active"
                                                <%= "Active".equals(term.getStatus()) ? "checked" : "" %>>
                                            <label class="form-check-label" for="statusActive">Active</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="status"
                                                   id="statusInactive" value="Inactive"
                                                <%= "Inactive".equals(term.getStatus()) ? "checked" : "" %>>
                                            <label class="form-check-label" for="statusInactive">Inactive</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="text-end">
                                <input type="submit" name="submit" value="Update" class="btn-primary">
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