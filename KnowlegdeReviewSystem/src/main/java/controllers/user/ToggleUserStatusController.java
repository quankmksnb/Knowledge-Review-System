package controllers.user;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.UserStatus;
import models.dao.UserDAO;
import services.dataaccess.UserService;

/**
 * @author Admin
 */
@WebServlet(name = "ToggleUserStatusController", urlPatterns = {"/user/toggleStatus"})
public class ToggleUserStatusController extends HttpServlet {
    private final UserService userService = new UserService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            UserStatus newStatus = userService.toggleUserStatus(userId);

            // Kiểm tra trạng thái mới
            String statusClass;
            switch (newStatus) {
                case Active:
                    statusClass = "success";
                    break;
                case Deactivated:
                    statusClass = "danger";
                    break;
                case NotVerified:
                    statusClass = "warning";
                    break;
                default:
                    statusClass = "secondary"; // Trường hợp dự phòng
            }

            // Ghi log để kiểm tra trạng thái
            System.out.println("User ID: " + userId + " -> New Status: " + newStatus + " | Class: " + statusClass);

            // Trả về JSON object chứa thông tin trạng thái mới
            out.print("{\"newStatus\": \"" + newStatus + "\", \"statusClass\": \"" + statusClass + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
