<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <style>
        /* Ensure the full height of the page */
        html {
            height: 100%;
        }

        body {
            margin: 0; /* Reset default margins */
            min-height: 100%; /* Ensure body takes full height */
            display: flex; /* Use Flexbox */
            flex-direction: column; /* Stack children vertically */
        }

        /* Wrapper will grow to fill available space */
        .wrapper {
            flex: 1 0 auto; /* Allows wrapper to grow and push footer down */
            display: flex; /* Ensure footer stays within flex context */
            flex-direction: column; /* Stack content and footer */
        }

        footer {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: #ffffff;
            text-align: center;
            padding: 10px 0;
            font-size: 14px;
            font-family: 'Arial', sans-serif;
            box-shadow: 0 -4px 15px rgba(0, 0, 0, 0.2);
            flex-shrink: 0; /* Prevents footer from shrinking */
        }

        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .footer-container p {
            margin-bottom: 5px;
            font-weight: 300;
            letter-spacing: 0.5px;
        }

        .footer-container nav a {
            color: #ffffff;
            text-decoration: none;
            margin: 0 10px;
            font-weight: 500;
            transition: color 0.3s ease, transform 0.3s ease;
        }

        .footer-container nav a:hover {
            color: #f1c40f;
            text-decoration: none;
            transform: translateY(-2px);
        }

        .footer-container nav a:not(:last-child)::after {
            content: '|';
            color: rgba(255, 255, 255, 0.5);
            margin-left: 10px;
            pointer-events: none;
        }

        /* Footer */
        footer {
            background: #2c3e50;
            color: white;
            padding: 40px 0;
            text-align: center;
        }

        footer a {
            color: #00c4ff;
            text-decoration: none;
            margin: 0 10px;
        }

        footer a:hover {
            text-decoration: underline;
        }

        footer p {
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <footer>
        <div class="footer-container">
            <p>© 2025 LearnEase. All rights reserved.</p>
            <nav>
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Contact Us</a>
            </nav>
        </div>
    </footer>
</body>
</html>