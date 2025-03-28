package controllers.classes;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.ClassStatus;
import models.dao.ClassDAO;
import services.dataaccess.ClassService;

/**
 * @author Admin
 */
@WebServlet(name = "ToggleClassStatusController", urlPatterns = {"/class_management/toggleStatus"})
public class ToggleClassStatusController extends HttpServlet {
    private final ClassService classService = new ClassService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            int classId = Integer.parseInt(request.getParameter("classId"));
            ClassStatus newStatus = classService.toggleClassStatus(classId);

            String statusClass = getStatusClass(newStatus);

            out.print("{\"newStatus\": \"" + newStatus + "\", \"statusClass\": \"" + statusClass + "\"}");
            request.getSession().setAttribute("message", "Change status successfully");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private String getStatusClass(ClassStatus status) {
        switch (status) {
            case Public:
                return "success";
            case Private:
                return "info";
            default:
                return "secondary";
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
