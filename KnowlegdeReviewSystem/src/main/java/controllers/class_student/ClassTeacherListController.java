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
import models.Setting;
import models.User;
import models.dao.ClassDAO;
import models.dao.SettingDAO;
import models.dao.SubjectDAO;

/**
 * @author Admin
 */
@WebServlet(name = "ClassTeacherListController", urlPatterns = {"/class_teacher"})
public class ClassTeacherListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect("login");
            return;
        }

        ClassDAO classDAO = new ClassDAO();
        SubjectDAO subjectDAO = new SubjectDAO();
        SettingDAO settingDAO = new SettingDAO();

        List<Setting> semesters = settingDAO.findAllBySemester();
        int defaultSemesterId = (semesters.isEmpty()) ? -1 : semesters.get(0).getId();

        String semesterParam = request.getParameter("semesterId");
        int selectedSemesterId = (semesterParam != null) ? Integer.parseInt(semesterParam) : defaultSemesterId;

        List<Class> teacherClasses = classDAO.findByManagerId(user.getId(), selectedSemesterId);

        Map<Integer, String> subjectCodeMap = new HashMap<>();
        Map<Integer, String> subjectNameMap = new HashMap<>();

        for (Class cls : teacherClasses) {
            subjectCodeMap.put(cls.getId(), subjectDAO.getSubjectCodeById(cls.getSubjectId()));
            subjectNameMap.put(cls.getId(), subjectDAO.getSubjectNameById(cls.getSubjectId()));
        }


        request.setAttribute("teacherClasses", teacherClasses);
        request.setAttribute("subjectCodeMap", subjectCodeMap);
        request.setAttribute("subjectNameMap", subjectNameMap);
        request.setAttribute("semesters", semesters);
        request.setAttribute("selectedSemesterId", selectedSemesterId);

        request.getRequestDispatcher("WEB-INF/ClassStudent/classTeacherList.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
