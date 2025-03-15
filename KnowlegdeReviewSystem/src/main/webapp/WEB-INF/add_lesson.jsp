<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Lesson</title>
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
            max-width: 600px;
            margin: auto;
            margin-top: 50px;
            box-shadow: 5px 5px 15px rgba(0, 0, 0, 0.2);
        }
        .table th {
            background-color: #F59E9E;
            width: 30%;
            text-align: left;
        }
        .table td {
            background-color: #F9C7C7;
        }
        .btn-custom {
            width: 100px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="table-container">
        <h3 class="text-center text-dark fw-bold bg-danger-subtle py-2 rounded">Add New Lesson</h3>
        <form action="subjectLesson" method="POST">
            <input type="text" name="action" value="add" hidden="">
            <table class="table table-bordered">
                <tr>
                    <th><i class="fa-solid fa-book"></i> Subject ID:</th>
                    <td><input type="number" class="form-control" name="subject_id" required></td>
                </tr>
                <tr>
                    <th><i class="fa-solid fa-pen"></i> Lesson Title:</th>
                    <td><input type="text" class="form-control" name="lesson_name" required></td>
                </tr>
                <tr>
                    <th><i class="fa-solid fa-align-left"></i> Description:</th>
                    <td><textarea class="form-control" name="description" rows="3" required></textarea></td>
                </tr>
            </table>
            <div class="d-flex justify-content-between">
                <button type="submit" class="btn btn-success btn-custom"><i class="fa-solid fa-save"></i> Save</button>
                <a href="subjectLesson" class="btn btn-danger btn-custom"><i class="fa-solid fa-arrow-left"></i> Back</a>
            </div>
        </form>
    </div>
</body>
</html>
