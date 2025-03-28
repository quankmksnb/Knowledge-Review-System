<%@ page import="models.Config" %>
<%@ page import="models.Setting" %>
<%@ page import="java.util.List" %>
<%@ page import="models.User" %><%--
  Created by IntelliJ IDEA.
  User: PC
  Date: 3/19/2025
  Time: 9:03 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
      rel="stylesheet">
<html>
<head>
    <title>Title</title>
</head>
<link rel="stylesheet" href="CSS/SubjectDetail/formsubjectdetail.css">


<body>
<div class="container-fluid">
    <div class="row">
        <jsp:include page="../Admin/homeAdmin.jsp"></jsp:include>
        <%Config configUpdate = (Config) request.getAttribute("config");
            List<Setting> settingTypes = (List<Setting>) request.getAttribute("settingTypes");
        %>
        <div class="col p-0">
            <div class="header-bar d-flex justify-content-between align-items-center px-4 bg-white shadow-sm py-3">
                <div class="header-title">Config Management</div>
            </div>

                <div class="container">
                    <div class="form-container">
                        <form action="config" method="POST" id="updateConfigForm">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="<%=configUpdate.getId()%>">

                            <div class="mb-3 col-md-6">
                                <label for="updateConfigType" class="form-label">Configuration Type</label>
                                <select class="form-select" id="updateConfigType" name="typeId" required>
                                    <option value="" selected disabled>Select a configuration type</option>
                                    <% if (settingTypes != null) {
                                        for (Setting setting : settingTypes) { %>
                                    <option value="<%= setting.getId() %>" <%=configUpdate.getTypeId() == setting.getId() ? "selected" : ""%>><%= setting.getTitle() %>
                                    </option>
                                    <% }
                                    } %>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="updateConfigDescription" class="form-label">Description</label>
                                <textarea class="form-control" id="updateConfigDescription" name="description" rows="6" required><%=configUpdate.getDescription()%></textarea>
                            </div>
                            <div class="mt-2">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="status" id="statusActive"
                                           value="Active" <%=(configUpdate.getStatus().equals("Active")) ? "checked" : ""%>>
                                    <label class="form-check-label" for="statusActive">Active</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="status" id="statusInactive"
                                           value="Inactive" <%=(configUpdate.getStatus().equals("Inactive")) ? "checked" : ""%>>
                                    <label class="form-check-label" for="statusInactive">Inactive</label>
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
