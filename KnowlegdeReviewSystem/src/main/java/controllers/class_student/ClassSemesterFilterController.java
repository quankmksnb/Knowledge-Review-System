package controllers.class_student;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Class;
import models.User;
import models.dao.ClassDAO;
import models.dao.SubjectDAO;

/**
 *
 * @author Admin
 */
@WebServlet(name="ClassSemesterFilterController", urlPatterns={"/filter_class_by_semester"})
public class ClassSemesterFilterController  extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRoleId() != 2) { // Đảm bảo chỉ Teacher mới truy cập được
            response.sendRedirect("login");
            return;
        }

        String semesterIdStr = request.getParameter("semesterId");
        Integer semesterId = (semesterIdStr != null && !semesterIdStr.isEmpty()) ? Integer.parseInt(semesterIdStr) : null;

        ClassDAO classDAO = new ClassDAO();
        SubjectDAO subjectDAO = new SubjectDAO();

        // Lọc danh sách lớp theo học kỳ
        List<models.Class> filteredClasses = classDAO.findByManagerId(user.getId(), semesterId);

        Map<Integer, String> subjectCodeMap = new HashMap<>();
        Map<Integer, String> subjectNameMap = new HashMap<>();

        for (models.Class cls : filteredClasses) {
            String subjectCode = subjectDAO.getSubjectCodeById(cls.getSubjectId());
            String subjectName = subjectDAO.getSubjectNameById(cls.getSubjectId());

            subjectCodeMap.put(cls.getId(), subjectCode);
            subjectNameMap.put(cls.getId(), subjectName);
        }

        // Trả về HTML để cập nhật danh sách lớp
        PrintWriter out = response.getWriter();
        for (Class cls : filteredClasses) {
            out.println("<div class='card'>"
                    + "<h3>" + subjectCodeMap.get(cls.getId()) + "</h3>"
                    + "<h5>Class: " + cls.getCode() + "</h5>"
                    + "<p>" + subjectNameMap.get(cls.getId()) + "</p>"
                    + "<div style='display: flex; justify-content: space-between; margin-top: 10px;'>"
                    + "<a href='class_student_detail?classId=" + cls.getId() + "'>View Students</a>"
                    + "<a href='#'>View Details</a>"
                    + "</div>"
                    + "</div>");
        }
    }


    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
