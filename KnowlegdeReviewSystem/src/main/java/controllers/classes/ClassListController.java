package controllers.classes;

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
import models.*;
import models.Class;
import models.dao.ClassDAO;
import models.dao.SettingDAO;
import models.dao.SubjectDAO;
import models.dao.UserDAO;

/**
 * @author Admin
 */
@WebServlet(name = "ClassListController", urlPatterns = {"/class_management"})
public class ClassListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ClassDAO classDAO = new ClassDAO();
        SubjectDAO subjectDAO = new SubjectDAO();
        UserDAO userDAO = new UserDAO();
        SettingDAO settingDAO = new SettingDAO();

        List<Setting> semesterList = settingDAO.findAllBySemester();
        List<Setting> domainList = settingDAO.findAllByType(SettingType.Category);
        List<Subject> subjectList = subjectDAO.findAll();

        Integer latestSemesterId = classDAO.getLatestSemesterId();
        // Lấy danh sách các lớp học theo semester tạo muộn nhất được mặc định
        List<Class> classList = classDAO.searchClasses(null, latestSemesterId, null, null);

        // Tạo các map để lưu thông tin ánh xạ
        Map<Integer, String> subjectCodeMap = new HashMap<>();
        Map<Integer, String> domainMap = new HashMap<>();
        Map<Integer, String> managerUsernameMap = new HashMap<>();

        // Ánh xạ SubjectCode, Domain và Manager
        for (Class cls : classList) {
            // Subject Code
            if (!subjectCodeMap.containsKey(cls.getSubjectId())) {
                String subjectCode = subjectDAO.getSubjectCodeById(cls.getSubjectId());
                subjectCodeMap.put(cls.getSubjectId(), subjectCode);
            }

            // Domain
            if (!domainMap.containsKey(cls.getSubjectId())) {
                String domain = subjectDAO.getDomain(cls.getSubjectId());
                domainMap.put(cls.getSubjectId(), domain);
            }

            // Manager Username
            if (!managerUsernameMap.containsKey(cls.getManagerId())) {
                String managerUsername = userDAO.getManagerUsername(cls.getManagerId());
                managerUsernameMap.put(cls.getManagerId(), managerUsername);
            }
        }

        // Truyền các map vào request
        request.setAttribute("classList", classList);
        request.setAttribute("subjectCodeMap", subjectCodeMap);
        request.setAttribute("domainMap", domainMap);
        request.setAttribute("managerUsernameMap", managerUsernameMap);
        request.setAttribute("semesterList", semesterList);
        request.setAttribute("domainList", domainList);
        request.setAttribute("subjectList", subjectList);
        request.getRequestDispatcher("WEB-INF/Class/classList.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        UserDAO userDAO = new UserDAO();
        SubjectDAO subjectDAO = new SubjectDAO();

        String code = request.getParameter("code");
        int subjectId = Integer.parseInt(request.getParameter("subject"));
        int managerId = userDAO.getIdByUsername(request.getParameter("manager"));
        int semesterId = Integer.parseInt(request.getParameter("semester"));
        String status = request.getParameter("status");
        String className = subjectDAO.getSubjectCodeById(subjectId) + "_" + code;

        Class newClass = new Class();
        newClass.setCode(code);
        newClass.setClassName(className);
        newClass.setSubjectId(subjectId);
        newClass.setManagerId(managerId);
        newClass.setSemesterId(semesterId);
        newClass.setStatus(ClassStatus.valueOf(status));

        ClassDAO classDAO = new ClassDAO();
        classDAO.create(newClass);

        request.getSession().setAttribute("message", "Class created successfully");
        response.sendRedirect("class_management");
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
