package controllers.login;

import java.io.IOException;
import java.util.Random;

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
import services.MailSender;
import org.json.JSONObject;

@WebServlet(name = "VerificationController", urlPatterns = {"/verify-account", "/resendCode", "/verifyCode"})
public class VerificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/verify-account".equals(path)) {
            HttpSession session = request.getSession();
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect("login");
                return;
            }
            sendVerificationCode(session, (User) session.getAttribute("user"));
            request.getRequestDispatcher("WEB-INF/Web/emailVerification.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        response.setContentType("application/json");
        JSONObject jsonResponse = new JSONObject();
        User user = (User) session.getAttribute("user");

        if (session == null || user == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Session expired. Please log in again.");
            response.getWriter().write(jsonResponse.toString());
            return;
        }

        user = WebManager.getInstance().getUserDAO().findByUsernameOrEmail(user.getUsername());

        System.out.println(user.toString());
        if ("/resendCode".equals(path)) {
            sendVerificationCode(session, (User) session.getAttribute("user"));
            jsonResponse.put("success", true);
            jsonResponse.put("message", "A new verification code has been sent.");
            response.getWriter().write(jsonResponse.toString());
        } else if ("/verifyCode".equals(path)) {

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
            String verificationCode = null;
            String storedCode = (String) session.getAttribute("verificationCode");

            try {
                // Parse JSON data
                verificationCode = JsonParser.parseString(json).getAsJsonObject().get("verificationCode").getAsString();
            } catch (Exception e) {
                e.printStackTrace();
                sendErrorResponse(response, "Invalid request data.");
                return;
            }

            if (storedCode != null && StringEncoder.matches(verificationCode, storedCode)) {
                user.setStatus(UserStatus.Active);
                WebManager.getInstance().getUserDAO().updateStatus(user);

                jsonResponse.put("success", true);
                jsonResponse.put("message", "Verification successful!");
                if (user.getRoleId() == 2 || user.getRoleId() == 3) {
                    jsonResponse.put("redirectUrl", "/home");
                } else if (user.getRoleId() == 4) {
                    jsonResponse.put("redirectUrl", "/class_management");
                } else {
                    jsonResponse.put("redirectUrl", "/admin");
                }
                response.getWriter().write(jsonResponse.toString());
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Invalid verification code.");
                response.getWriter().write(jsonResponse.toString());
            }
        }
    }

    private String generateVerificationCode() {
        Random random = new Random();
        return String.valueOf(100000 + random.nextInt(900000));
    }

    private void sendVerificationCode(HttpSession session, User user) {
        String verificationCode = generateVerificationCode();
        String subject = "[Knowledge Review System] Verification Code: " + verificationCode;
        String body = "<p>Hello " + user.getUsername() + ",</p>" +
                "<p>Please use the following code to verify your account:</p>" +
                "<h3>" + verificationCode + "</h3>" +
                "<p>If you did not request this, please ignore this message.</p>";

        MailSender.sendEmail(user.getEmail(), subject, body);
        session.setAttribute("verificationCode", StringEncoder.encodePassword(verificationCode));
    }

    private void sendErrorResponse(HttpServletResponse response, String errorMessage) throws IOException {
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("error", errorMessage);
        response.setContentType("application/json");
        response.getWriter().write(jsonResponse.toString());
    }
}