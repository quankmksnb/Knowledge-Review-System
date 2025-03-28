package controllers;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import services.StringEncoder;
import services.dataaccess.UserService;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet(name = "ProfileServlet", urlPatterns = {
        "/profile",
        "/save-profile",
        "/change-password",
        "/get-password"
})
public class ProfileServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ProfileServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        // Use request.getSession(false) to avoid creating a new session if none exists
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Debug: Log the user (consider using a logger in production)
        System.out.println("User: " + user);

        // Redirect to login if user is not authenticated
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return; // Stop further processing after redirect
        }

        // Process the request if user is authenticated
        switch (path) {
            case "/profile":
                request.getRequestDispatcher("WEB-INF/Web/profile.jsp").forward(request, response);
                break;
            case "/get-password":
                verifyCurrentPassword(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        // Use request.getSession(false) to avoid creating a new session if none exists
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Debug: Log the user (consider using a logger in production)
        System.out.println("User: " + user);

        // Redirect to login if user is not authenticated
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return; // Stop further processing after redirect
        }

        switch (path) {
            case "/save-profile":
                saveProfile(request, response);
                break;
            case "/change-password":
                changePassword(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void verifyCurrentPassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        Gson gson = new Gson();

        try {
            boolean isValid = StringEncoder.matches(currentPassword, user.getPasswordHash());
            response.getWriter().write(gson.toJson(new PasswordResponse(isValid)));
        } catch (Exception e) {
            LOGGER.severe("Error verifying password: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(new PasswordResponse(false)));
        }
    }

    private void saveProfile(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        String fullName = request.getParameter("fullName");

        try {
            // Input validation
            if (fullName == null || fullName.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Full name cannot be empty");
                return;
            }

            // Update user object
            user.setFullName(fullName.trim());
            UserService userService = new UserService();
            userService.update(user);

            // Here you would typically update the database
            // Example: userDAO.update(user);

            // Update session
            session.setAttribute("user", user);
            response.getWriter().write(new Gson().toJson(new SuccessResponse("Profile updated successfully")));

        } catch (Exception e) {
            LOGGER.severe("Error saving profile: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Failed to update profile: " + e.getMessage());
        }
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        try {
            // Input validation
            if (currentPassword == null || newPassword == null || confirmPassword == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "All password fields are required");
                return;
            }

            // Verify current password
            if (!StringEncoder.matches(currentPassword, user.getPasswordHash())) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Current password is incorrect");
                return;
            }

            // Validate new password
            if (!newPassword.equals(confirmPassword)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "New passwords do not match");
                return;
            }

            if (newPassword.length() < 8) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "New password must be at least 8 characters long");
                return;
            }

            // Update password
            String newPasswordHash = StringEncoder.encodePassword(newPassword);
            user.setPasswordHash(newPasswordHash);
            UserService userService = new UserService();
            userService.update(user);

            // Here you would typically update the database
            // Example: userDAO.update(user);

            // Update session
            session.setAttribute("user", user);

            response.getWriter().write(new Gson().toJson(new SuccessResponse("Password changed successfully")));
        } catch (Exception e) {
            LOGGER.severe("Error changing password: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Failed to change password: " + e.getMessage());
        }
    }

    // Response classes
    private static class PasswordResponse {
        boolean valid;

        PasswordResponse(boolean valid) {
            this.valid = valid;
        }
    }

    private static class SuccessResponse {
        String message;

        SuccessResponse(String message) {
            this.message = message;
        }
    }
}