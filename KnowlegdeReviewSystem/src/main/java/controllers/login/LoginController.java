package controllers.login;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import controllers.WebManager;
import services.StringEncoder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;
import models.UserStatus;
import models.dao.UserDAO;
import services.GoogleAuthService;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "LoginController", urlPatterns = {"/login","/logout", "/google-login"})   // "/login"
public class LoginController extends HttpServlet {

    // Handle GET request for login page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        HttpSession session = request.getSession();
        if(session.getAttribute("user") != null) {
            response.sendRedirect("home");  // Redirect to login page (or home page)
        }

        switch(path) {
            case "/login":
                request.getRequestDispatcher("WEB-INF/Web/login.jsp").forward(request, response);
                break;
            case "/logout":
                if (session != null) {
                    session.invalidate();  // Logs the user out by invalidating the session
                }

                break;
        }
    }

    // Handle POST request for login form submission
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Read JSON data from the request body
        StringBuilder jsonBuilder = new StringBuilder();
        String line;
        try {
            while ((line = request.getReader().readLine()) != null) {
                jsonBuilder.append(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error reading request data.");
            return;
        }

        String json = jsonBuilder.toString();
        String usernameOrEmail = null;
        String password = null;
        boolean rememberMe = false;
        String action = null;
        String idToken = null;


        try {
            // Parse JSON data
            action = JsonParser.parseString(json).getAsJsonObject().get("action").getAsString();
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Invalid request data.");
            return;
        }

        if ("google-login".equals(action)) {
            try {
                // Parse JSON data
                idToken = JsonParser.parseString(json).getAsJsonObject().get("id_token").getAsString();
            } catch (Exception e) {
                e.printStackTrace();
                sendErrorResponse(response, "Invalid request data.");
                return;
            }

            handleGoogleSignIn(request, response, idToken);
        } else {
            try {
                // Parse JSON data
                usernameOrEmail = JsonParser.parseString(json).getAsJsonObject().get("usernameOrEmail").getAsString();
                password = JsonParser.parseString(json).getAsJsonObject().get("password").getAsString();
                rememberMe = JsonParser.parseString(json).getAsJsonObject().get("remember_me").getAsBoolean();
            } catch (Exception e) {
                e.printStackTrace();
                sendErrorResponse(response, "Invalid request data.");
                return;
            }

            try {
                login(request, response, usernameOrEmail, password, rememberMe);
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                sendErrorResponse(response, "An error occurred during login.");
            }
        }
    }

    // Main login function for regular login
    private void login(HttpServletRequest request, HttpServletResponse response, String usernameOrEmail, String password, boolean rememberMe)
            throws IOException, SQLException, ClassNotFoundException {

        UserDAO userDAO = WebManager.getInstance().getUserDAO();
        User user = userDAO.findByUsernameOrEmail(usernameOrEmail);

        if (user == null) {
            sendErrorResponse(response, "Invalid username or email.");
            return;
        }

        // Validate password (use a password hashing library like BCrypt)
        if (!StringEncoder.matches(password, user.getPasswordHash())) {
            sendErrorResponse(response, "Invalid password.");
            return;
        }

        // Create session after successful login
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("role", user.getRoleId()); // Assuming roleId is part of the User object

        // Handle 'Remember Me' functionality
        if (rememberMe) {
            Cookie usernameCookie = new Cookie("userC", user.getUsername());
            Cookie passwordCookie = new Cookie("passC", user.getPasswordHash());
            usernameCookie.setMaxAge(7 * 24 * 60 * 60); // 1 week
            passwordCookie.setMaxAge(7 * 24 * 60 * 60); // 1 week
            response.addCookie(usernameCookie);
            response.addCookie(passwordCookie);
        } else {
            clearCookies(request, response);
        }

        // Send success response
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", true);

        if (user.getStatus().equals(UserStatus.NotVerified)) {
            jsonResponse.addProperty("redirectUrl", "verify-account");
        } else {
            jsonResponse.addProperty("redirectUrl", (user.getRoleId() == 3 || user.getRoleId() == 2) ? "/home" : "/admin");
        }
        response.setContentType("application/json");
        response.getWriter().write(jsonResponse.toString());
    }

    private void handleGoogleSignIn(HttpServletRequest request, HttpServletResponse response, String idToken) throws IOException, ServletException {
        //System.out.println(idToken);

        if (idToken == null || idToken.isEmpty()) {
            sendErrorResponse(response, "Google login failed.");
            return;
        }

        try {
            // Verify the ID token using GoogleAuthService
            GoogleIdToken.Payload googleIdToken = GoogleAuthService.verifyToken(idToken);
            if (googleIdToken == null) {
                sendErrorResponse(response, "Invalid Google ID Token.");
                return;
            }

            // Extract user info from the token
            String email = googleIdToken.getEmail();
            String googleId = googleIdToken.getSubject();

            UserDAO userDAO = WebManager.getInstance().getUserDAO();
            User user = userDAO.findByUsernameOrEmail(email);

            // If the user does not exist, create a new one
            if (user == null) {
                user = new User();
                user.setEmail(email);
                user.setFullName(email);
                user.setUsername(email); // Use email as username
                user.setPasswordHash(googleId); // Use Google ID as password hash
                user.setRoleId(3); // Default role (e.g., 2 for regular user)
                user.setStatus(UserStatus.Active); // Set status to active
                userDAO.register(user); // Save the user to the database
            }

            user = userDAO.findByUsernameOrEmail(email);

            // Log the user in
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRoleId());

            // Send success response
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", true);

            if (user.getStatus().equals(UserStatus.NotVerified)) {
                jsonResponse.addProperty("redirectUrl", "/verify-account");
            } else {
                jsonResponse.addProperty("redirectUrl", (user.getRoleId() == 3) ? "/home" : "/admin");
            }
            response.setContentType("application/json");
            response.getWriter().write(jsonResponse.toString());

        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "An error occurred during Google login.");
        }
    }

    // Utility function to clear cookies
    private void clearCookies(HttpServletRequest request, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("userC") || cookie.getName().equals("passC")) {
                    cookie.setMaxAge(0); // Set the max age to 0 to delete the cookie
                    response.addCookie(cookie);
                }
            }
        }
    }

    // Utility function to send error response
    private void sendErrorResponse(HttpServletResponse response, String errorMessage) throws IOException {
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("error", errorMessage);
        response.setContentType("application/json");
        response.getWriter().write(jsonResponse.toString());
    }

}