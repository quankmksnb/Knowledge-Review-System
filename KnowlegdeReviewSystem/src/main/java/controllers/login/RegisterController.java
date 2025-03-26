//package controllers.login;
//
//import com.google.gson.JsonObject;
//import com.google.gson.JsonParser;
//import controllers.WebManager;
//import services.StringEncoder;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import models.User;
//import models.UserStatus;
//import models.dao.UserDAO;
//
//import java.io.IOException;
//
//@WebServlet(name = "RegisterController", urlPatterns = {"/register", "/check-username", "/check-email"})
//public class RegisterController extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//
//        request.getRequestDispatcher("WEB-INF/Web/register.jsp").forward(request, response);
//        HttpSession session = request.getSession();
//        if (session.getAttribute("user") != null) {
//            response.sendRedirect("home");  // Redirect to login page (or home page)
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String path = request.getServletPath();
//
//        switch (path) {
//            case "/register":
//                handleRegularRegistration(request, response);
//                break;
//            case "/check-username":
//                checkUsername(request, response);
//                break;
//            case "/check-email":
//                checkEmail(request, response);
//                break;
//        }
//    }
//
//    private void handleRegularRegistration(HttpServletRequest request, HttpServletResponse response) throws IOException {
//        // Parse JSON data from the request body
//        StringBuilder jsonBuilder = new StringBuilder();
//        String line;
//        while ((line = request.getReader().readLine()) != null) {
//            jsonBuilder.append(line);
//        }
//        String json = jsonBuilder.toString();
//
//        String email = null;
//        String username = null;
//        String password = null;
//        String fullname = null;
//
//        try {
//            JsonObject jsonObject = JsonParser.parseString(json).getAsJsonObject();
//
//            email = jsonObject.get("email").getAsString();
//            username = jsonObject.get("username").getAsString();
//            password = jsonObject.get("password").getAsString();
//            fullname = jsonObject.get("fullname").getAsString();
//        } catch (Exception e) {
//            e.printStackTrace();
//            sendErrorResponse(response, "Invalid request data.");
//            return;
//        }
//
//        // Validate input (e.g., check if email/username already exists)
//        UserDAO userDAO = WebManager.getInstance().getUserDAO();
//        if (userDAO.findByUsernameOrEmail(username) != null || userDAO.findByUsernameOrEmail(email) != null) {
//            System.out.println("Username or email already exists.");
//            sendErrorResponse(response, "Username or email already exists.");
//            return;
//        }
//
//        System.out.println("Start Creating User");
//
//        // Hash the password
//        String hashedPassword = StringEncoder.encodePassword(password);
//
//        // Create a new user
//        User user = new User();
//        user.setEmail(email);
//        user.setUsername(username);
//        user.setFullName(fullname);
//        user.setPasswordHash(hashedPassword);
//        user.setRoleId(3); // Default role (e.g., 2 for regular user)
//        user.setStatus(UserStatus.NotVerified); // Set status to active
//
//        //System.out.println(user);
//
//        // Save the user to the database
//        userDAO.register(user);
//
//        // Send success response
//        JsonObject jsonResponse = new JsonObject();
//        jsonResponse.addProperty("success", true);
//        response.setContentType("application/json");
//        response.getWriter().write(jsonResponse.toString());
//    }
//
//    private void checkUsername(HttpServletRequest request, HttpServletResponse response) throws IOException {
//        response.setContentType("application/json");
//        response.setCharacterEncoding("UTF-8");
//
//        // Parse JSON data from the request body
//        StringBuilder jsonBuilder = new StringBuilder();
//        String line;
//        while ((line = request.getReader().readLine()) != null) {
//            jsonBuilder.append(line);
//        }
//        String json = jsonBuilder.toString();
//
//        String username = null;
//
//        try {
//            JsonObject jsonObject = JsonParser.parseString(json).getAsJsonObject();
//            username = jsonObject.get("username").getAsString();
//        } catch (Exception e) {
//            e.printStackTrace();
//            sendErrorResponse(response, "Invalid request data.");
//            return;
//        }
//
//        boolean exists = checkUserInDatabase(response, username);
//
//        // Send success response
//        JsonObject jsonResponse = new JsonObject();
//        jsonResponse.addProperty("exists", exists);
//        response.setContentType("application/json");
//        response.getWriter().write(jsonResponse.toString());
//    }
//
//    private boolean checkUserInDatabase(HttpServletResponse response, String username) throws IOException {
//        // Validate input (e.g., check if email/username already exists)
//        return (WebManager.getInstance().getUserDAO().findByUsernameOrEmail(username) != null);
//    }
//
//
//    private void checkEmail(HttpServletRequest request, HttpServletResponse response) throws IOException {
//        response.setContentType("application/json");
//        response.setCharacterEncoding("UTF-8");
//
//        // Parse JSON data from the request body
//        StringBuilder jsonBuilder = new StringBuilder();
//        String line;
//        while ((line = request.getReader().readLine()) != null) {
//            jsonBuilder.append(line);
//        }
//        String json = jsonBuilder.toString();
//
//        String email = null;
//
//        try {
//            JsonObject jsonObject = JsonParser.parseString(json).getAsJsonObject();
//            email = jsonObject.get("email").getAsString();
//        } catch (Exception e) {
//            e.printStackTrace();
//            sendErrorResponse(response, "Invalid request data.");
//            return;
//        }
//
//        boolean exists = checkUserInDatabase(response, email);
//
//        // Send success response
//        JsonObject jsonResponse = new JsonObject();
//        jsonResponse.addProperty("exists", exists);
//        response.setContentType("application/json");
//        response.getWriter().write(jsonResponse.toString());
//    }
//
//    private void sendErrorResponse(HttpServletResponse response, String errorMessage) throws IOException {
//        JsonObject jsonResponse = new JsonObject();
//        jsonResponse.addProperty("success", false);
//        jsonResponse.addProperty("error", errorMessage);
//        response.setContentType("application/json");
//        response.getWriter().write(jsonResponse.toString());
//    }
//}

package controllers.login;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import controllers.WebManager;
import services.StringEncoder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import models.UserStatus;
import models.dao.UserDAO;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet(name = "RegisterController", urlPatterns = {"/register", "/check-username", "/check-email"})
public class RegisterController extends HttpServlet {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
    private static final int MIN_USERNAME_LENGTH = 8;
    private static final int MIN_FULLNAME_LENGTH = 2;
    private static final int MIN_PASSWORD_LENGTH = 8;
    private static final int MAX_PASSWORD_LENGTH = 32;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("home");
            return;
        }
        request.getRequestDispatcher("WEB-INF/Web/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();
        switch (path) {
            case "/register":
                handleRegularRegistration(request, response);
                break;
            case "/check-username":
                checkUsername(request, response);
                break;
            case "/check-email":
                checkEmail(request, response);
                break;
            default:
                sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, "Invalid endpoint");
        }
    }

    private void handleRegularRegistration(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JsonObject jsonObject = parseJsonRequest(request, response);
        if (jsonObject == null) return;

        String email = jsonObject.has("email") ? jsonObject.get("email").getAsString() : null;
        String username = jsonObject.has("username") ? jsonObject.get("username").getAsString() : null;
        String password = jsonObject.has("password") ? jsonObject.get("password").getAsString() : null;
        String fullname = jsonObject.has("fullname") ? jsonObject.get("fullname").getAsString() : null;

        // Input validation
        if (!validateInputs(response, email, username, password, fullname)) return;

        UserDAO userDAO = WebManager.getInstance().getUserDAO();

        // Check for existing user
        if (userDAO.findByUsernameOrEmail(username) != null) {
            sendErrorResponse(response, HttpServletResponse.SC_CONFLICT, "Username already exists");
            return;
        }
        if (userDAO.findByUsernameOrEmail(email) != null) {
            sendErrorResponse(response, HttpServletResponse.SC_CONFLICT, "Email already exists");
            return;
        }

        // Create and save user
        try {
            User user = createUser(email, username, password, fullname);
            userDAO.register(user);

            JsonObject successResponse = new JsonObject();
            successResponse.addProperty("success", true);
            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write(successResponse.toString());
        } catch (Exception e) {
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Registration failed: " + e.getMessage());
        }
    }

    private void checkUsername(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JsonObject jsonObject = parseJsonRequest(request, response);
        if (jsonObject == null) return;

        String username = jsonObject.has("username") ? jsonObject.get("username").getAsString() : null;
        if (username == null || username.trim().length() < MIN_USERNAME_LENGTH) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Username must be at least " + MIN_USERNAME_LENGTH + " characters");
            return;
        }

        boolean exists = WebManager.getInstance().getUserDAO().findByUsernameOrEmail(username) != null;
        sendCheckResponse(response, exists);
    }

    private void checkEmail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JsonObject jsonObject = parseJsonRequest(request, response);
        if (jsonObject == null) return;

        String email = jsonObject.has("email") ? jsonObject.get("email").getAsString() : null;
        if (email == null || !EMAIL_PATTERN.matcher(email).matches()) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid email format");
            return;
        }

        boolean exists = WebManager.getInstance().getUserDAO().findByUsernameOrEmail(email) != null;
        sendCheckResponse(response, exists);
    }

    private JsonObject parseJsonRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (BufferedReader reader = request.getReader()) {
            StringBuilder jsonBuilder = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonBuilder.append(line);
            }
            return JsonParser.parseString(jsonBuilder.toString()).getAsJsonObject();
        } catch (Exception e) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid JSON data");
            return null;
        }
    }

    private boolean validateInputs(HttpServletResponse response, String email, String username,
                                   String password, String fullname) throws IOException {
        if (email == null || !EMAIL_PATTERN.matcher(email).matches()) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid email format");
            return false;
        }
        if (username == null || username.trim().length() < MIN_USERNAME_LENGTH) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Username must be at least " + MIN_USERNAME_LENGTH + " characters");
            return false;
        }
        if (fullname == null || fullname.trim().length() < MIN_FULLNAME_LENGTH) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Full name must be at least " + MIN_FULLNAME_LENGTH + " characters");
            return false;
        }
        if (!isValidPassword(password)) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Password must be " + MIN_PASSWORD_LENGTH + "-" + MAX_PASSWORD_LENGTH +
                            " characters and contain at least one uppercase letter and one number");
            return false;
        }
        return true;
    }

    private boolean isValidPassword(String password) {
        if (password == null || password.length() < MIN_PASSWORD_LENGTH || password.length() > MAX_PASSWORD_LENGTH) {
            return false;
        }
        return Pattern.compile("[A-Z]").matcher(password).find() &&
                Pattern.compile("\\d").matcher(password).find();
    }

    private User createUser(String email, String username, String password, String fullname) {
        User user = new User();
        user.setEmail(email.trim());
        user.setUsername(username.trim());
        user.setFullName(fullname.trim());
        user.setPasswordHash(StringEncoder.encodePassword(password));
        user.setRoleId(3); // Default role
        user.setStatus(UserStatus.NotVerified);
        return user;
    }

    private void sendCheckResponse(HttpServletResponse response, boolean exists) throws IOException {
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("exists", exists);
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(jsonResponse.toString());
    }

    private void sendErrorResponse(HttpServletResponse response, int status, String errorMessage) throws IOException {
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("error", errorMessage);
        response.setStatus(status);
        response.getWriter().write(jsonResponse.toString());
    }
}