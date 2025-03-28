<%@ page import="models.Lesson" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Subject" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page isELIgnored="false" %>
<html>
<head>
    <title>Lesson Subject</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="CSS/Lesson/getLesson.css">
    <style>
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 30px;
            gap: 5px;
        }

        .pagination-item {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 35px;
            height: 35px;
            border-radius: 4px;
            border: 1px solid #ddd;
            background-color: white;
            cursor: pointer;
            transition: all 0.2s;
        }

        .pagination-item:hover {
            background-color: #f1f1f1;
        }

        .pagination-item.active {
            background-color: #0d6efd;
            color: white;
            border-color: #0d6efd;
        }

        .pagination-item.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
<%
    Subject subject = (Subject) session.getAttribute("subject");
    String subjectName = subject.getSubjectName();
    int subjectId = subject.getId();
%>
<div class="container-fluid">
    <div class="row">
        <jsp:include page="../Admin/homeAdmin.jsp"></jsp:include>

        <div class="col p-0">
            <div class="header-bar d-flex justify-content-between align-items-center px-4 bg-white shadow-sm py-3">
                <div class="header-title"><%= subjectName %> Management</div>
            </div>

            <div class="container mt-6">
                <div class="container-box">
                    <ul class="nav nav-tabs">
                        <li class="nav-item">
                            <a class="nav-link" href="subject?action=update&id=<%=subjectId%>">GENERAL</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="lesson_list?subjectId=<%=subjectId%>">LESSON</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="config">CONFIG</a>
                        </li>
                    </ul>
                </div>

                <div class="form-container">
                    <div class="header-bar d-flex justify-content-between align-items-center px-4 bg-white shadow-sm py-3">
                        Lesson of <%= subjectName %>
                        <!-- Nút Add Lesson căn bên phải -->
                        <a href="create_lesson?subjectId=${subject.id}" class="btn btn-primary float-end">
                            <i class="bi bi-plus-circle"></i> Add Lesson
                        </a>
                    </div>

                    <div class="table-responsive lesson-table">
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th style="width: 5%;">#</th>
                                <th>Title</th>
                                <th>Chapter</th>
                                <th style="width: 10%;">Action</th>
                            </tr>
                            </thead>
                            <tbody id="content">
                            <c:forEach var="lesson" items="${lessons}" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td>${lesson.title}</td>
                                    <td>
                                        <c:out value="${lessonChapters[lesson.id]}" default="N/A"/>
                                    </td>
                                    <td>
                                        <a href="update_lesson?id=${lesson.id}" class="text-primary">
                                            <i class="bi bi-pencil-square fs-5"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty lessons}">
                                <tr>
                                    <td colspan="4" class="text-center">No lessons found for this subject.</td>
                                </tr>
                            </c:if>
                            </tbody>

                        </table>
                    </div>
                    <div class="pagination mt-4">
                        <c:if test="${totalPages > 1}">
                            <a href="?subjectId=${subjectId}&page=${currentPage - 1}" class="pagination-item
                               ${currentPage == 1 ? 'disabled' : ''}">
                                <i class="bi bi-chevron-left"></i>
                            </a>

                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <a href="?subjectId=${subjectId}&page=${i}" class="pagination-item
                                   ${i == currentPage ? 'active' : ''}">${i}</a>
                            </c:forEach>

                            <a href="?subjectId=${subjectId}&page=${currentPage + 1}" class="pagination-item
                               ${currentPage == totalPages ? 'disabled' : ''}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </c:if>
                    </div>

                </div>

            </div>
        </div>
    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>
</body>
</html>