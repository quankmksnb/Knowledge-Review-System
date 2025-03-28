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
import services.dataaccess.ClassService;
import services.dataaccess.SettingService;
import services.dataaccess.SubjectService;

/**
 * @author Admin
 */
@WebServlet(name = "ClassTeacherListController", urlPatterns = {"/class_teacher"})
public class ClassTeacherListController extends HttpServlet {
    private final ClassService classService = new ClassService();
    private final SubjectService subjectService = new SubjectService();
    private final SettingService settingService = new SettingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect("/error");
            return;
        }

        List<Setting> semesters = settingService.findAllBySemester();
        int defaultSemesterId = (semesters.isEmpty()) ? -1 : semesters.get(0).getId();

        String semesterParam = request.getParameter("semesterId");
        int selectedSemesterId = (semesterParam != null) ? Integer.parseInt(semesterParam) : defaultSemesterId;

        List<Class> teacherClasses = classService.findByManagerId(user.getId(), selectedSemesterId);

        Map<Integer, String> subjectCodeMap = new HashMap<>();
        Map<Integer, String> subjectNameMap = new HashMap<>();

        for (Class cls : teacherClasses) {
            subjectCodeMap.put(cls.getId(), subjectService.getSubjectCodeById(cls.getSubjectId()));
            subjectNameMap.put(cls.getId(), subjectService.getSubjectNameById(cls.getSubjectId()));
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
