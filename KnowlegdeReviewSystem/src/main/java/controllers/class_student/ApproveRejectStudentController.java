package controllers.class_student;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.dao.ClassDAO;
import services.dataaccess.ClassService;

/**
 * @author Admin
 */
@WebServlet(name = "ApproveRejectStudentController", urlPatterns = {"/approve_reject_student"})
public class ApproveRejectStudentController extends HttpServlet {
    private final ClassService classService = new ClassService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ApproveRejectStudentController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ApproveRejectStudentController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        int classId = Integer.parseInt(request.getParameter("classId"));
        String action = request.getParameter("action");

        boolean success = false;
        String message = "";

        if ("approve".equals(action)) {
            success = classService.approveStudent(classId, studentId);
            message = success ? "Student approved successfully!" : "Failed to approve student.";
        } else if ("reject".equals(action)) {
            success = classService.rejectStudent(classId, studentId);
            message = success ? "Student removed successfully!" : "Failed to remove student.";
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": " + success + ", \"message\": \"" + message + "\"}");
        out.flush();
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
