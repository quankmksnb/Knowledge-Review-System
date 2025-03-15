<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Answer Management</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
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
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }

        .form-container {
            margin: 20px auto 40px;
            background-color: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 900px;
        }

        .form-control {
            background-color: #d9edf7;
            border: none;
            border-radius: 8px;
            padding: 10px;
        }

        .form-select {
            background-color: #d9edf7;
            border: none;
            border-radius: 8px;
            padding: 10px;
        }

        .btn-primary {
            background-color: #9370DB;
            color: white;
            border-radius: 8px;
            padding: 10px 20px;
            border: none;
        }

        .btn-primary:hover {
            background-color: #7B68EE;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
            border-radius: 8px;
            padding: 10px 20px;
            border: none;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .btn-success {
            background-color: #28a745;
            color: white;
            border-radius: 8px;
            padding: 10px 20px;
            border: none;
        }

        .btn-success:hover {
            background-color: #218838;
        }

        .row .col-md-6 {
            margin-bottom: 25px;
        }

        .form-check-input {
            margin-right: 10px;
        }

        .container-box {
            margin-bottom: 20px;
        }

        .nav-tabs .nav-link.active {
            font-weight: bold;
        }

        .modal-header {
            background-color: #9370DB;
            color: white;
        }

        .question-box {
            background-color: #f0f7ff;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 5px solid #9370DB;
        }

        .answer-list {
            margin-top: 20px;
        }

        .answer-item {
            background-color: #fff;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            border: 1px solid #ddd;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .answer-correct {
            background-color: #e6ffe6;
            border-left: 5px solid #28a745;
        }

        .answer-incorrect {
            border-left: 5px solid #dc3545;
        }

        .empty-state {
            text-align: center;
            padding: 30px;
            font-size: 18px;
            color: #555;
            margin-bottom: 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.4);
            overflow: auto;
        }

        .modal-content {
            background-color: #fefefe;
            margin: 10% auto;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            width: 60%;
            max-width: 600px;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            color: black;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-auto px-0 sidebar d-none d-md-block">
            <div class="d-flex flex-column p-3">
                <h5 class="text-white mb-4">AdminKit</h5>
                <nav class="nav flex-column">
                    <a class="nav-link" href="/home"><i class="bi bi-house me-2"></i> Home</a>
                    <a class="nav-link" href="/user"><i class="bi bi-people me-2"></i> User</a>
                    <a class="nav-link" href="/subject"><i class="bi bi-book me-2"></i> Subject</a>
                    <a class="nav-link" href="/setting"><i class="bi bi-gear me-2"></i> Setting</a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col p-0">
            <!-- Header -->
            <div class="header-bar d-flex justify-content-between align-items-center px-4 bg-white shadow-sm py-3">
                <div class="header-title">Answer Management</div>
            </div>

            <!-- Main Container -->
            <div class="container mt-4">
                <div class="form-container">
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">
                                ${successMessage}
                        </div>
                    </c:if>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">
                                ${errorMessage}
                        </div>
                    </c:if>

                    <c:if test="${not empty question}">
                        <div class="question-box">
                            <h2>Question:</h2>
                            <p>${question.content}</p>
                        </div>

                        <div class="mb-4">
                            <button class="btn btn-primary me-2" onclick="showAddSingleModal()">
                                <i class="fas fa-plus"></i> Add Single Answer
                            </button>

                            <button class="btn btn-primary" onclick="showAddMultipleModal()">
                                <i class="fas fa-list"></i> Add Multiple Answers
                            </button>
                        </div>

                        <div class="answer-list">
                            <h2>Answers:</h2>

                            <c:choose>
                                <c:when test="${empty answers}">
                                    <div class="empty-state">
                                        <h3>No answers available for this question</h3>
                                        <p>Please add answers using the buttons above.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="answer" items="${answers}">
                                        <div class="answer-item ${answer.answer ? 'answer-correct' : 'answer-incorrect'}">
                                            <div>
                                                <p>${answer.content}</p>
                                                <span class="badge">
                                                    <c:if test="${answer.answer}">
                                                        <i class="fas fa-check" style="color: green;"></i> Correct
                                                    </c:if>
                                                    <c:if test="${!answer.answer}">
                                                        <i class="fas fa-times" style="color: red;"></i> Incorrect
                                                    </c:if>
                                                </span>
                                            </div>
                                            <div>
                                                <button class="btn btn-primary me-2" onclick="showEditModal(${answer.id}, '${answer.content}', ${answer.answer})">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <button class="btn btn-danger" onclick="confirmDelete(${answer.id})">
                                                    <i class="fas fa-trash"></i> Delete
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <c:if test="${empty question}">
                        <div class="empty-state">
                            <h3>No question selected</h3>
                            <p>Please select a question from the question list first.</p>
                            <a href="question" class="btn btn-primary">Go to Questions</a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Single Answer Modal -->
<div id="addSingleModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal('addSingleModal')">&times;</span>
        <div class="modal-header">
            <h2>Add New Answer</h2>
        </div>
        <div class="modal-body p-4">
            <form action="answer" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="questionId" value="${question.id}">

                <div class="mb-3">
                    <label for="content" class="form-label">Answer Content:</label>
                    <textarea id="content" name="content" class="form-control" rows="3" required></textarea>
                </div>

                <div class="form-check mb-3">
                    <input type="checkbox" id="isCorrect" name="isCorrect" value="true" class="form-check-input">
                    <label for="isCorrect" class="form-check-label">This is the correct answer</label>
                </div>

                <div class="text-end">
                    <button type="submit" class="btn btn-success">Add Answer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Add Multiple Answers Modal -->
<div id="addMultipleModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal('addMultipleModal')">&times;</span>
        <div class="modal-header">
            <h2>Add Multiple Answers</h2>
        </div>
        <div class="modal-body p-4">
            <div class="mb-3">
                <label for="answerCount" class="form-label">Number of Answers:</label>
                <select id="answerCount" class="form-select" onchange="generateAnswerFields()">
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                </select>
            </div>

            <form id="multipleAnswersForm" action="answer" method="post">
                <input type="hidden" name="action" value="addMultiple">
                <input type="hidden" name="questionId" value="${question.id}">
                <input type="hidden" name="count" id="countField" value="2">

                <div id="answerFieldsContainer">
                    <!-- Answer fields will be generated here -->
                </div>

                <div class="text-end mt-3">
                    <button type="submit" class="btn btn-success">Add Answers</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Answer Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal('editModal')">&times;</span>
        <div class="modal-header">
            <h2>Edit Answer</h2>
        </div>
        <div class="modal-body p-4">
            <form action="answer" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="editId">
                <input type="hidden" name="questionId" value="${question.id}">

                <div class="mb-3">
                    <label for="editContent" class="form-label">Answer Content:</label>
                    <textarea id="editContent" name="content" class="form-control" rows="3" required></textarea>
                </div>

                <div class="form-check mb-3">
                    <input type="checkbox" id="editIsCorrect" name="isCorrect" value="true" class="form-check-input">
                    <label for="editIsCorrect" class="form-check-label">This is the correct answer</label>
                </div>

                <div class="text-end">
                    <button type="submit" class="btn btn-success">Update Answer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div id="deleteModal" class="modal">
    <div class="modal-content" style="max-width: 400px;">
        <span class="close" onclick="closeModal('deleteModal')">&times;</span>
        <div class="modal-header">
            <h2>Confirm Delete</h2>
        </div>
        <div class="modal-body p-4">
            <p>Are you sure you want to delete this answer?</p>
            <form action="answer" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" id="deleteId">

                <div class="text-end mt-3">
                    <button type="button" class="btn btn-primary me-2" onclick="closeModal('deleteModal')">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script>
    // Show modals
    function showAddSingleModal() {
        document.getElementById('addSingleModal').style.display = 'block';
    }

    function showAddMultipleModal() {
        document.getElementById('addMultipleModal').style.display = 'block';
        generateAnswerFields(); // Generate initial fields
    }

    function showEditModal(id, content, isCorrect) {
        document.getElementById('editId').value = id;
        document.getElementById('editContent').value = content;
        document.getElementById('editIsCorrect').checked = isCorrect;
        document.getElementById('editModal').style.display = 'block';
    }

    function confirmDelete(id) {
        document.getElementById('deleteId').value = id;
        document.getElementById('deleteModal').style.display = 'block';
    }

    // Close modals
    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
    }

    // Generate answer fields based on selected count
    function generateAnswerFields() {
        const count = parseInt(document.getElementById('answerCount').value);
        document.getElementById('countField').value = count;

        const container = document.getElementById('answerFieldsContainer');
        container.innerHTML = '';

        for (let i = 1; i <= count; i++) {
            const fieldGroup = document.createElement('div');
            fieldGroup.classList.add('mb-4');
            fieldGroup.style.padding = '10px';
            fieldGroup.style.marginBottom = '15px';
            fieldGroup.style.borderBottom = i < count ? '1px solid #eee' : 'none';

            fieldGroup.innerHTML = `
                <h4>Answer ${i}</h4>
                <div class="mb-3">
                    <label for="content${i}" class="form-label">Answer Content:</label>
                    <textarea id="content${i}" name="content${i}" class="form-control" rows="2" required></textarea>
                </div>

                <div class="form-check">
                    <input type="checkbox" id="isCorrect${i}" name="isCorrect${i}" value="true" class="form-check-input">
                    <label for="isCorrect${i}" class="form-check-label">This is the correct answer</label>
                </div>
            `;

            container.appendChild(fieldGroup);
        }
    }

    // Close modals when clicking outside
    window.onclick = function(event) {
        if (event.target.className === 'modal') {
            event.target.style.display = 'none';
        }
    }
</script>
</body>
</html>