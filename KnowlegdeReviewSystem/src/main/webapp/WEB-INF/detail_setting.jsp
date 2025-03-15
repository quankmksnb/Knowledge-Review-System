<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.Setting"%>

<%
    Setting setting = (Setting) request.getAttribute("setting");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Setting Detail</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            body {
                background-color: #E9F3FF;
            }
            .table-container {
                background: #B2F3F0;
                border-radius: 10px;
                padding: 20px;
                max-width: 900px;
                margin: auto;
                margin-top: 50px;
                box-shadow: 5px 5px 15px rgba(0, 0, 0, 0.2);
            }
            .table {
                width: 100%;
                border-collapse: collapse;
            }
            .table th {
                background-color: #F59E9E;
                width: 30%;
                text-align: left;
                padding: 12px 15px;
                font-weight: bold;
            }
            .table td {
                background-color: #FEE2E2;
                padding: 12px 15px;
                text-align: left;
                vertical-align: middle;
            }
            .btn-custom {
                width: 120px;
                font-weight: bold;
            }
            .table-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
            }
            .table-row .left-column, .table-row .right-column {
                width: 48%;
            }
            .table tr:nth-child(even) {
                background-color: #F7D5D5;
            }
            .table tr:nth-child(odd) {
                background-color: #FEE2E2;
            }
            .table tr:hover {
                background-color: #F59E9E;
                color: white;
            }
            .table th, .table td {
                border: 1px solid #ddd;
                border-radius: 8px;
            }
        </style>
    </head>
    <body>
        <div class="table-container">
            <h3 class="text-center text-dark fw-bold bg-danger-subtle py-2 rounded">Setting Detail</h3>

            <% if (setting != null) { %>
            <div class="table">
                <div class="table-row">
                    <div class="left-column">
                        <table>
                            <tr>
                                <th><i class="fa-solid fa-hashtag"></i> ID:</th>
                                <td><%= setting.getId() %></td>
                            </tr>
                            <tr>
                                <th><i class="fa-solid fa-user"></i> Created By:</th>
                                <td><%= setting.getCreatedBy() %></td>
                            </tr>
                            <tr>
                                <th><i class="fa-solid fa-heading"></i> Title:</th>
                                <td><%= setting.getTitle() %></td>
                            </tr>
                            <tr>
                                <th><i class="fa-solid fa-layer-group"></i> Type:</th>
                                <td><%= setting.getType() %></td>
                            </tr>
                        </table>
                    </div>
                    <div class="right-column">
                        <table>
                            <tr>
                                <th><i class="fa-solid fa-calendar"></i> Created At:</th>
                                <td><%= setting.getCreatedAt() %></td>
                            </tr>
                            <tr>
                                <th><i class="fa-solid fa-user"></i> Modified By:</th>
                                <td><%= setting.getModifiedBy() != null ? setting.getModifiedBy() : "N/A" %></td>
                            </tr>
                            <tr>
                                <th><i class="fa-solid fa-calendar-check"></i> Modified At:</th>
                                <td><%= setting.getModifiedAt() != null ? setting.getModifiedAt() : "N/A" %></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-center gap-3">
                <a href="settings?id=<%= setting.getId() %>&action=edit" class="btn btn-warning btn-custom">
                    <i class="fa-solid fa-pen"></i> Edit
                </a>
                <a href="setting" class="btn btn-danger btn-custom">
                    <i class="fa-solid fa-arrow-left"></i> Back
                </a>
            </div>
            <% } else { %>
            <div class="alert alert-danger text-center">
                <i class="fa-solid fa-triangle-exclamation"></i> Setting not found!
            </div>
            <% } %>
        </div>
    </body>
</html>
