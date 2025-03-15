package controllers.login;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import controllers.WebManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import org.json.JSONObject;
import services.MailSender;
import services.StringEncoder;

import java.io.IOException;
import java.util.Random;
import java.util.logging.Logger;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password", "/sendResetCode", "/verifyResetCode", "/forgot-password-verify-code", "/reset-password"})
public class ForgotPasswordServlet extends HttpServlet {

    Logger LOGGER = Logger.getLogger(ForgotPasswordServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        System.out.println(path);
        LOGGER.info(path);

        HttpSession session = request.getSession(false);
        if (session.getAttribute("user") != null) {
            response.sendRedirect("home");  // Redirect to login page (or home page)
        }

        switch (path) {
            case "/forgot-password":
                request.getRequestDispatcher("WEB-INF/Web/forgotPassword.jsp").forward(request, response);
                break;

            case "/forgot-password-verify-code":
                request.getRequestDispatcher("WEB-INF/Web/forgotPassword2.jsp").forward(request, response);
                break;

            case "/reset-password":
                request.getRequestDispatcher("WEB-INF/Web/resetPassword.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        response.setContentType("application/json");
        JSONObject jsonResponse = new JSONObject();

        if ("/sendResetCode".equals(path)) {
//
//            // Read JSON data from the request body
//            StringBuilder jsonBuilder = new StringBuilder();
//            String line;
//            try {
//                while ((line = request.getReader().readLine()) != null) {
//                    jsonBuilder.append(line);
//                }
//            } catch (IOException e) {
//                e.printStackTrace();
//                sendErrorResponse(response, "Error reading request data.");
//                return;
//            }
//
//            String json = jsonBuilder.toString();
//            String email = null;
//
//            try {
//                // Parse JSON data
//                email = JsonParser.parseString(json).getAsJsonObject().get("email").getAsString();
//            } catch (Exception e) {
//                e.printStackTrace();
//                sendErrorResponse(response, "Invalid request data.");
//                return;
//            }
//            User user = WebManager.getInstance().getUserDAO().findByUsernameOrEmail(email);
//
//            if (WebManager.getInstance().getUserDAO().findByUsernameOrEmail(email) == null) {
//                sendErrorResponse(response, "Email not found");
//                return;
//            }
//
//
//            session.setAttribute("resetEmail", email);
//            sendVerificationCode(session, user);
//            jsonResponse.put("success", true);
//            jsonResponse.put("message", "Verification code sent to email.");
//            response.getWriter().write(jsonResponse.toString());
            sendResetCode(request, response);
        }

        if ("/verifyResetCode".equals(path)) {
//            String enteredCode = request.getParameter("code");
//
//            String storedCode = (String) session.getAttribute("verificationResetCode");
//
//            if (storedCode == null || !StringEncoder.matches(enteredCode, storedCode)) {
//                sendErrorResponse(response, "Invalid or expired verification code.");
//                return;
//            }
//
//            session.removeAttribute("verificationResetCode");
//            jsonResponse.put("success", true);
//            jsonResponse.put("message", "Verification successful. Proceed with password reset.");
//            response.getWriter().write(jsonResponse.toString());
            verifyResetCode(request, response);
        }

        if ("/reset-password".equals(path)) {
//            response.setContentType("application/json");
//
//            String newPassword = request.getParameter("password");
//            String email = (String) request.getSession().getAttribute("resetEmail"); // Email stored during verification
//
//            if (email == null || newPassword == null || newPassword.isEmpty()) {
//                jsonResponse.put("success", false);
//                jsonResponse.put("message", "Invalid request. Please provide a new password.");
//                response.getWriter().write(jsonResponse.toString());
//                return;
//            }
//
//            try {
//                // Fetch user by email
//                User user = WebManager.getInstance().getUserDAO().findByUsernameOrEmail(email);
//                if (user == null) {
//                    jsonResponse.put("success", false);
//                    jsonResponse.put("message", "User not found.");
//                    response.getWriter().write(jsonResponse.toString());
//                    return;
//                }
//
//                // Encode and set the new password
//                user.setPasswordHash(StringEncoder.encodePassword(newPassword));
//
//                // Update user password via DAO
//                WebManager.getInstance().getUserDAO().update(user);
//
//                // Clear the resetEmail session attribute
//                request.getSession().removeAttribute("resetEmail");
//
//                jsonResponse.put("success", true);
//                jsonResponse.put("message", "Password updated successfully.");
//            } catch (Exception e) {
//                e.printStackTrace();
//                jsonResponse.put("success", false);
//                jsonResponse.put("message", "Database error, please try again later.");
//            }
//
//            // Write the JSON response
//            response.getWriter().write(jsonResponse.toString());
            resetPassword(request, response);
        }

    }

    private void sendResetCode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        JSONObject jsonResponse = new JSONObject();

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
        String email = null;

        try {
            // Parse JSON data
            email = JsonParser.parseString(json).getAsJsonObject().get("email").getAsString();
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Invalid request data.");
            return;
        }
        User user = WebManager.getInstance().getUserDAO().findByUsernameOrEmail(email);

        if (WebManager.getInstance().getUserDAO().findByUsernameOrEmail(email) == null) {
            sendErrorResponse(response, "Email not found");
            return;
        }


        session.setAttribute("resetEmail", email);
        sendVerificationCode(session, user);
        jsonResponse.put("success", true);
        jsonResponse.put("message", "Verification code sent to email.");
        response.getWriter().write(jsonResponse.toString());
    }

    private void verifyResetCode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        JSONObject jsonResponse = new JSONObject();

        String enteredCode = request.getParameter("code");

        String storedCode = (String) session.getAttribute("verificationResetCode");

        if (storedCode == null || !StringEncoder.matches(enteredCode, storedCode)) {
            sendErrorResponse(response, "Invalid or expired verification code.");
            return;
        }

        session.removeAttribute("verificationResetCode");
        jsonResponse.put("success", true);
        jsonResponse.put("message", "Verification successful. Proceed with password reset.");
        response.getWriter().write(jsonResponse.toString());
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        response.setContentType("application/json");
        JSONObject jsonResponse = new JSONObject();

        String newPassword = request.getParameter("password");
        String email = (String) request.getSession().getAttribute("resetEmail"); // Email stored during verification

        if (email == null || newPassword == null || newPassword.isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Invalid request. Please provide a new password.");
            response.getWriter().write(jsonResponse.toString());
            return;
        }

        try {
            // Fetch user by email
            User user = WebManager.getInstance().getUserDAO().findByUsernameOrEmail(email);
            if (user == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "User not found.");
                response.getWriter().write(jsonResponse.toString());
                return;
            }

            // Encode and set the new password
            user.setPasswordHash(StringEncoder.encodePassword(newPassword));

            // Update user password via DAO
            WebManager.getInstance().getUserDAO().update(user);

            // Clear the resetEmail session attribute
            request.getSession().removeAttribute("resetEmail");

            jsonResponse.put("success", true);
            jsonResponse.put("message", "Password updated successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Database error, please try again later.");
        }

        // Write the JSON response
        response.getWriter().write(jsonResponse.toString());
    }

    private String generateVerificationCode() {
        Random random = new Random();
        return String.valueOf(100000 + random.nextInt(900000));
    }

    private void sendVerificationCode(HttpSession session, User user) {
        String verificationCode = generateVerificationCode();
        String subject = "[Knowledge Review System] Reset Password Code: " + verificationCode;
        String body = "<p>Hello " + user.getUsername() + ",</p>" +
                "<p>Please use the following code to reset your password:</p>" +
                "<h3>" + verificationCode + "</h3>" +
                "<p>If you did not request this, please ignore this message.</p>";

        MailSender.sendEmail(user.getEmail(), subject, body);
        session.setAttribute("verificationResetCode", StringEncoder.encodePassword(verificationCode));
    }

    private void sendErrorResponse(HttpServletResponse response, String errorMessage) throws IOException {
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("error", errorMessage);
        response.getWriter().write(jsonResponse.toString());
    }
}