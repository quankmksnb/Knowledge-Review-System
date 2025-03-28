<%@ page import="models.dao.DTOSubject" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Choose Subject</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>

        html, body {
            height: 100%;
            margin: 0;
            display: flex;
            flex-direction: column;
        }
        body {
            background-color: #f4f6f9;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .container-fluid {
            flex: 1;
        }



        .header-bar {
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }

        .search-input {
            background-color: #f8f9fa;
            border: none;
            padding-left: 2.5rem;
            border-radius: 8px;
        }



        .subject-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 40px;
            padding: 20px;
        }

        .subject-thumbnail {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
            transition: transform 0.3s ease;
        }

        .subject-thumbnail:hover {
            transform: translateY(-5px);
        }

        .subject-thumbnail h3 {
            margin-bottom: 10px;
        }

        .subject-thumbnail p {
            color: #666;
        }

        .subject-thumbnail a {
            margin-top: 15px;
            display: inline-block;
        }

        .subject-thumbnail-header {
            background-color: #f0f0f0;
            padding: 10px;
            border-radius: 5px 5px 0 0;
            font-weight: bold;
        }

    </style>
</head>
<body>
<div class="header">
    <jsp:include page="../Web/header.jsp"></jsp:include>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col p-0">
            <div class="header-bar d-flex justify-content-between align-items-center px-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="header-title">Choose the subject of flashcards</div>

                    <div>
                        <form action="card">
                            <input type="hidden" name="action" value="choose">
                            <label for="searchInput">Subject Name:</label><input name="subjectName" type="text" id="searchInput" class="form-control search-input" placeholder="Search subjects...">


                            <button style="opacity: 0;" type="submit"></button>
                        </form>
                    </div>
                    <div>
                        <select name="domain" id="domain" class="form-select">
                            <option value="all">All Domains</option>
                            <% HashMap<Integer, String> map = (HashMap<Integer, String>) request.getAttribute("map");
                                for (HashMap.Entry<Integer, String> entry : map.entrySet()) { %>
                            <option value="<%= entry.getKey() %>"><%= entry.getValue() %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                </div>
            </div>
            <div class="subject-grid">
                <% List<DTOSubject> subjects = (List<DTOSubject>) request.getAttribute("list");

                    if (subjects != null) {
                        for (DTOSubject s : subjects) {%>
                <div class="subject-thumbnail">
                    <div class="subject-thumbnail-header"><%= s.getCode() %></div>
                    <h3><%= s.getName() %></h3>
                    <a href="card?action=choose&subjectId=<%= s.getId() %>" class="btn btn-primary">
                        <i class="bi bi-search"></i> Select
                    </a>
                </div>
                <% }
                } %>
            </div>
        </div>
    </div>
</div>
<div class="footer">
    <jsp:include page="../Web/footer.jsp"></jsp:include>
</div>
<script>
    const domainSelect = document.getElementById('domain');

    function performSearch() {
        const selectedDomain = domainSelect.value;
        const url = `card?action=choose&domain=${selectedDomain}`;
        window.location.href = url;
    }



    domainSelect.addEventListener('change', function () {
        performSearch();
    });
</script>
</body>
</html>