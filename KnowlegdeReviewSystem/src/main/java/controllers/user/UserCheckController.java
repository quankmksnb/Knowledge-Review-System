package controllers.user;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.dao.UserDAO;

/**
 * @author Admin
 */
@WebServlet(name = "UserCheckController", urlPatterns = {"/user/checkUserExists", "/user/checkManagerRole"})
public class UserCheckController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String manager = request.getParameter("manager");
        String path = request.getServletPath();
        UserDAO userDAO = new UserDAO();

        PrintWriter out = response.getWriter();

        if (email != null || username != null) {
            // Kiểm tra email và username đã tồn tại hay chưa
            boolean emailExists = email != null && userDAO.isEmailExists(email);
            boolean usernameExists = username != null && userDAO.isUsernameExists(username);

            if (emailExists) {
                out.println("<span class='text-danger'>Email already exists!</span>");
            } else {
                out.println(""); // Trả về chuỗi rỗng nếu không có lỗi
            }

            if (usernameExists) {
                out.println("<span class='text-danger'>Username already exists!</span>");
            } else {
                out.println(""); // Trả về chuỗi rỗng nếu không có lỗi
            }
        } else if (manager != null) {
            // Kiểm tra vai trò của người quản lý (manager)
            String role = userDAO.getRoleByUsername(manager);

            if ("Teacher".equalsIgnoreCase(role)) {
                out.println(""); // Không có lỗi, không cần thông báo
            } else {
                // Trả về thông báo lỗi nếu không phải giảng viên
                out.println("<span class='text-danger'>Manager must be a teacher.</span>");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
