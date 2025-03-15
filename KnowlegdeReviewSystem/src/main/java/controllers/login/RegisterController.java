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

import java.io.IOException;

@WebServlet(name = "RegisterController", urlPatterns = {"/register", "/check-username", "/check-email"})
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.getRequestDispatcher("WEB-INF/Web/register.jsp").forward(request, response);
        HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            response.sendRedirect("home");  // Redirect to login page (or home page)
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        }
    }

    private void handleRegularRegistration(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Parse JSON data from the request body
        StringBuilder jsonBuilder = new StringBuilder();
        String line;
        while ((line = request.getReader().readLine()) != null) {
            jsonBuilder.append(line);
        }
        String json = jsonBuilder.toString();

        String email = null;
        String username = null;
        String password = null;
        String fullname = null;

        try {
            JsonObject jsonObject = JsonParser.parseString(json).getAsJsonObject();

            email = jsonObject.get("email").getAsString();
            username = jsonObject.get("username").getAsString();
            password = jsonObject.get("password").getAsString();
            fullname = jsonObject.get("fullname").getAsString();
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Invalid request data.");
            return;
        }

        // Validate input (e.g., check if email/username already exists)
        UserDAO userDAO = WebManager.getInstance().getUserDAO();
        if (userDAO.findByUsernameOrEmail(username) != null || userDAO.findByUsernameOrEmail(email) != null) {
            System.out.println("Username or email already exists.");
            sendErrorResponse(response, "Username or email already exists.");
            return;
        }

        System.out.println("Start Creating User");

        // Hash the password
        String hashedPassword = StringEncoder.encodePassword(password);

        // Create a new user
        User user = new User();
        user.setEmail(email);
        user.setUsername(username);
        user.setFullName(fullname);
        user.setPasswordHash(hashedPassword);
        user.setRoleId(3); // Default role (e.g., 2 for regular user)
        user.setStatus(UserStatus.NotVerified); // Set status to active

        //System.out.println(user);

        // Save the user to the database
        userDAO.register(user);

        // Send success response
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", true);
        response.setContentType("application/json");
        response.getWriter().write(jsonResponse.toString());
    }

    private void checkUsername(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Parse JSON data from the request body
        StringBuilder jsonBuilder = new StringBuilder();
        String line;
        while ((line = request.getReader().readLine()) != null) {
            jsonBuilder.append(line);
        }
        String json = jsonBuilder.toString();

        String username = null;

        try {
            JsonObject jsonObject = JsonParser.parseString(json).getAsJsonObject();
            username = jsonObject.get("username").getAsString();
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Invalid request data.");
            return;
        }

        boolean exists = checkUserInDatabase(response, username);

        // Send success response
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("exists", exists);
        response.setContentType("application/json");
        response.getWriter().write(jsonResponse.toString());
    }

    private boolean checkUserInDatabase(HttpServletResponse response, String username) throws IOException {
        // Validate input (e.g., check if email/username already exists)
        return (WebManager.getInstance().getUserDAO().findByUsernameOrEmail(username) != null);
    }


    private void checkEmail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Parse JSON data from the request body
        StringBuilder jsonBuilder = new StringBuilder();
        String line;
        while ((line = request.getReader().readLine()) != null) {
            jsonBuilder.append(line);
        }
        String json = jsonBuilder.toString();

        String email = null;

        try {
            JsonObject jsonObject = JsonParser.parseString(json).getAsJsonObject();
            email = jsonObject.get("email").getAsString();
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Invalid request data.");
            return;
        }

        boolean exists = checkUserInDatabase(response, email);

        // Send success response
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("exists", exists);
        response.setContentType("application/json");
        response.getWriter().write(jsonResponse.toString());
    }

    private void sendErrorResponse(HttpServletResponse response, String errorMessage) throws IOException {
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("error", errorMessage);
        response.setContentType("application/json");
        response.getWriter().write(jsonResponse.toString());
    }
}