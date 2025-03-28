<%@ page import="models.Lesson, models.Config" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Lesson</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- CKEditor CDN -->
    <script src="https://cdn.ckeditor.com/ckeditor5/36.0.1/classic/ckeditor.js"></script>
    <link rel="stylesheet" href="CSS/Lesson/createLesson.css">
</head>

<body>


<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <jsp:include page="../Admin/homeAdmin.jsp"></jsp:include>

        <!-- Main Content -->
        <div class="col p-0">
            <!-- Header Bar -->
            <div class="header-bar d-flex justify-content-between align-items-center px-4">
                <div class="header-title">Create New Lesson</div>
            </div>

            <div class="container mt-4">
                <div class="form-container">
                    <h3 class="text-center">Create New Lesson</h3>

                    <form action="create_lesson" method="post">
                        <input type="hidden" name="subjectId" value="${param.subjectId}" />
                        <div class="row">
                            <!-- Lesson Title -->
                            <div class="col-md-6">
                                <label class="form-label">Lesson Title</label>
                                <input type="text" name="title" class="form-control" required />
                            </div>

                            <!-- Video URL -->
                            <div class="col-md-6">
                                <label class="form-label">Video URL</label>
                                <input type="text" name="videoUrl" class="form-control" />
                            </div>

                            <!-- Select Chapter -->
                            <div class="col-md-6">
                                <label class="form-label">Select Chapter</label>
                                <select name="chapterId" class="form-control" required>
                                    <c:forEach var="chapter" items="${chapterList}">
                                        <option value="${chapter.id}">${chapter.description}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Description (CKEditor) -->
                            <div class="col-md-12">
                                <label class="form-label">Description</label>
                                <textarea name="description" class="form-control" id="descriptionEditor"></textarea>
                            </div>
                        </div>

                        <button type="submit" class="btn-update btn-block mt-4">Create Lesson</button>
                    </form>

                </div>
            </div>
        </div>
    </div>
</div>


<script>
    ClassicEditor
        .create(document.querySelector('#descriptionEditor'))
        .catch(error => {
            console.error(error);
        });
</script>
</body>
</html>
