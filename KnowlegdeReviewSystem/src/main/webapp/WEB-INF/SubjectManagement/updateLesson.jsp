<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/26/2025
  Time: 10:18 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="models.Lesson, models.Config" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page isELIgnored="false" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Lesson</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- CKEditor CDN -->
    <script src="https://cdn.ckeditor.com/ckeditor5/36.0.1/classic/ckeditor.js"></script>
    <style>
        body {
            background-color: #f4f6f9;
        }

        .sidebar {
            background-color: #1a1f36;
            min-height: 100vh;
        }

        .sidebar .nav-link {
            color: #8b92a8;
            padding: 0.8rem 1rem;
            margin: 0.2rem 0;
            border-radius: 6px;
        }

        .sidebar .nav-link:hover {
            background-color: #2d3548;
            color: #fff;
        }

        .header-bar {
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 15px;
        }

        .header-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }

        .form-container {
            margin-top: 40px;
            padding: 30px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .form-label {
            font-weight: bold;
        }

        .form-control {
            margin-bottom: 20px;
            background-color: #f1f8ff;
            border-radius: 8px;
            border: none;
        }

        .btn-update {
            background-color: #4c5a9c;
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            border: none;
        }

        .btn-update:hover {
            background-color: #3a4d77;
        }
    </style>
</head>

<body>
<jsp:include page="../Web/header.jsp"></jsp:include>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-auto px-0 sidebar d-none d-md-block">
            <div class="d-flex flex-column p-3">
                <h5 class="text-white mb-4">AdminKit</h5>
                <nav class="nav flex-column">
                    <a class="nav-link" href="/home"><i class="bi bi-house"></i> Home</a>
                    <a class="nav-link" href="/user"><i class="bi bi-person-circle"></i> User</a>
                    <a class="nav-link" href="/subject"><i class="bi bi-book"></i> Subject</a>
                    <a class="nav-link" href="/class_management"><i class="bi bi-people"></i> Class</a>
                    <a class="nav-link" href="/setting"><i class="bi bi-gear"></i> Setting</a>
                    <a class="nav-link" href="question?action=choose"><i class="bi bi-question-octagon"></i>Question</a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col p-0">
            <!-- Header Bar -->
            <div class="header-bar d-flex justify-content-between align-items-center px-4">
                <div class="header-title">Update Lesson</div>
            </div>

            <div class="container mt-4">
                <div class="form-container">
                    <h3 class="text-center">Update Lesson</h3>

                    <form action="update_lesson" method="post">
                        <input type="hidden" name="lessonId" value="${lesson.id}"/>

                        <div class="row">
                            <!-- Lesson Title -->
                            <div class="col-md-6">
                                <label class="form-label">Lesson Title</label>
                                <input type="text" name="title" class="form-control" value="${lesson.title}" required />
                            </div>

                            <!-- Video URL -->
                            <div class="col-md-6">
                                <label class="form-label">Video URL</label>
                                <input type="text" name="videoUrl" class="form-control" value="${lesson.videoUrl}" />
                            </div>

                            <!-- Select Chapter -->
                            <div class="col-md-6">
                                <label class="form-label">Select Chapter</label>
                                <select name="chapterId" class="form-control" required>
                                    <c:forEach var="chapter" items="${chapterList}">
                                        <option value="${chapter.id}"
                                                <c:if test="${chapter.id == currentChapterId}">selected</c:if>>
                                                ${chapter.description}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Lesson Description (CKEditor) -->
                            <div class="col-md-12">
                                <label class="form-label">Description</label>
                                <textarea name="description" class="form-control" required id="descriptionEditor">${lesson.description}</textarea>
                            </div>

                        </div>

                        <button type="submit" class="btn-update btn-block mt-4">Update Lesson</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- CKEditor Script -->
<script>
    // Initialize CKEditor for the Description textarea
    ClassicEditor
        .create(document.querySelector('#descriptionEditor'))
        .catch(error => {
            console.error(error);
        });
</script>
</body>
</html>
