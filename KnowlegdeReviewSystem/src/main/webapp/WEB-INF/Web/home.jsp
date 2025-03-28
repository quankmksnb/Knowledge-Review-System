<%@ page import="models.dao.SettingDAO" %>
<%@ page import="controllers.WebManager" %>
<%@ page import="models.Setting" %>
<%@ page import="models.SettingType" %>
<%@ page import="java.util.List" %>
<%@ page import="models.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>KRS - Your Learning Journey Starts Here</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background: #f5f7fa;
        }

        /* Banner Section */
        .banner {
            position: relative;
            background: linear-gradient(135deg, #007bff, #00c4ff);
            color: white;
            padding: 100px 0;
            text-align: center;
            overflow: hidden;
        }

        .banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('Images/banner.png') no-repeat center center/cover;
            opacity: 0.2;
            z-index: 0;
        }

        .banner-content {
            position: relative;
            z-index: 1;
            max-width: 800px;
            margin: 0 auto;
        }

        .banner h1 {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .banner p {
            font-size: 1.2rem;
            margin-bottom: 30px;
        }

        .banner .btn {
            background: #fff;
            color: #007bff;
            font-weight: 500;
            padding: 12px 30px;
            border-radius: 25px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .banner .btn:hover {
            background: #f8f9fa;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        /* Features Section */
        .features-section {
            padding: 60px 0;
            background: #fff;
        }

        .features-section h2 {
            text-align: center;
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 40px;
        }

        .feature-card {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .feature-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .feature-card h3 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }

        .feature-card p {
            font-size: 1rem;
            color: #666;
            margin-bottom: 15px;
        }

        .feature-card .btn {
            background: #007bff;
            color: white;
            padding: 10px 20px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .feature-card .btn:hover {
            background: #0056b3;
        }

        /* Popular Classes Section */
        .classes-section {
            padding: 80px 0;
            background: linear-gradient(135deg, #e8f0fe 0%, #f5f7fa 100%);
            box-shadow: inset 0 0 20px rgba(0, 0, 0, 0.05);
            position: relative;
        }

        .classes-section h2 {
            text-align: center;
            font-size: 2.8rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 50px;
            position: relative;
        }

        .classes-section h2::after {
            content: '';
            width: 80px;
            height: 4px;
            background: #007bff;
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 2px;
        }

        .class-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            position: relative;
            border: 1px solid #e0e7ff;
        }

        .class-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            border-color: #007bff;
        }

        .class-card-body {
            padding: 20px;
            position: relative;
        }

        .class-card-body .badge {
            position: absolute;
            top: 10px;
            right: 20px;
            background: #ff4d4f;
            color: white;
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .class-card-body h3 {
            font-size: 1.3rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
        }

        .class-card-body h3 i {
            color: #007bff;
            margin-right: 8px;
        }

        .class-card-body p {
            font-size: 0.95rem;
            color: #666;
            margin-bottom: 15px;
            line-height: 1.5;
        }

        .class-card-body .btn {
            background: linear-gradient(45deg, #007bff, #00c4ff);
            color: white;
            padding: 10px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
        }

        .class-card-body .btn:hover {
            background: linear-gradient(45deg, #0056b3, #0096cc);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 123, 255, 0.3);
        }

        @media (max-width: 768px) {
            .banner {
                padding: 60px 0;
            }

            .banner h1 {
                font-size: 2rem;
            }

            .banner p {
                font-size: 1rem;
            }

            .feature-card img {
                height: 150px;
            }

            .class-card-body {
                padding: 15px;
            }

            .class-card-body h3 {
                font-size: 1.1rem;
            }

            .class-card-body p {
                font-size: 0.9rem;
            }

            .class-card-body .btn {
                padding: 8px 20px;
            }
        }
    </style>
</head>

<body>
<!-- Include Header -->
<jsp:include page="header.jsp" />

<!-- Banner Section -->
<section class="banner">
    <div class="banner-content">
        <h1>Unlock Your Potential with KRS</h1>
        <p>Join millions of learners and explore courses from top instructors around the world.</p>
        <a href="/public-classes" class="btn">Explore Courses</a>
    </div>
</section>

<!-- Features Section -->
<section class="features-section">
    <div class="container">
        <h2>Discover Our Features</h2>
        <div class="row">
            <div class="col-md-4 col-sm-6 mb-4">
                <div class="feature-card">
                    <img src="Images/quiz.png" alt="Quiz Feature">
                    <h3>Interactive Quizzes</h3>
                    <p>Test your knowledge with engaging quizzes designed to reinforce your learning.</p>
                    <a href="/my_quiz" class="btn">Take a Quiz</a>
                </div>
            </div>
            <div class="col-md-4 col-sm-6 mb-4">
                <div class="feature-card">
                    <img src="Images/learning.png" alt="Class Learning Feature">
                    <h3>Class Learning</h3>
                    <p>Join live or recorded classes with expert instructors to master new skills.</p>
                    <a href="/public-classes" class="btn">Join a Class</a>
                </div>
            </div>
            <div class="col-md-4 col-sm-6 mb-4">
                <div class="feature-card">
                    <img src="Images/flashcard.png" alt="Flashcard Learning Feature">
                    <h3>Flashcard Learning</h3>
                    <p>Memorize key concepts quickly with our interactive flashcard system.</p>
                    <a href="/card?action=choose" class="btn">Start Flashcards</a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Popular Classes Section -->
<section class="classes-section">
    <div class="container">
        <h2>Popular Classes</h2>
        <div class="row" id="popular-classes">
            <!-- Classes will be loaded dynamically via AJAX -->
        </div>
    </div>
</section>

<jsp:include page="footer.jsp"></jsp:include>

<script>
    // Load popular classes via AJAX
    $(document).ready(function() {
        $.ajax({
            url: "/popular-classes",
            type: "GET",
            dataType: "json",
            success: function(data) {
                let html = "";

                console.log(data);

                data.forEach(cls => {
                    html += `
                        <div class="col-md-4 col-sm-6 mb-4">
                            <div class="class-card">
                                <div class="class-card-body">
                                    <span class="badge">Popular</span>
                                    <h3><i class="fas fa-book-open"></i>  ${cls.className}</h3>
                                    <p>${cls.subjectName}</p>
                                    <a href="/class-enroll?class-id=${cls.id}" class="btn">Learn More</a>
                                </div>
                            </div>
                        </div>
                    `;
                });
                $("#popular-classes").html(html);
            },
            error: function() {
                $("#popular-classes").html('<p class="text-center text-danger">Error loading classes.</p>');
            }
        });
    });
</script>
</body>
</html>