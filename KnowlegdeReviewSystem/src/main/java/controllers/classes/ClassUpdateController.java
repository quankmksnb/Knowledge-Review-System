package controllers.classes;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;

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
import services.dataaccess.ClassService;
import services.dataaccess.SettingService;
import services.dataaccess.SubjectService;
import services.dataaccess.UserService;

/**
 * @author Admin
 */
@WebServlet(name = "ClassUpdateController", urlPatterns = {"/class_update_management"})
public class ClassUpdateController extends HttpServlet {
    private final SettingService settingService = new SettingService();
    private final SubjectService subjectService = new SubjectService();
    private final ClassService classService = new ClassService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int clasID = Integer.parseInt(request.getParameter("classId"));
        List<Setting> domainList = settingService.findAllByType(SettingType.Category);
        List<Subject> subjectList = subjectService.findAll();
        Class oldClass = classService.findById(clasID);
        String oldDomain = subjectService.getDomain(oldClass.getSubjectId());
        String oldManager = userService.getManagerUsername(oldClass.getManagerId());
        List<ClassStatus> statusOptions = Arrays.asList(ClassStatus.values());
        List<User> approvedStudents = classService.getApprovedStudents(clasID);


        request.setAttribute("domainList", domainList);
        request.setAttribute("subjectList", subjectList);
        request.setAttribute("oldClass", oldClass);
        request.setAttribute("oldDomain", oldDomain);
        request.setAttribute("oldManager", oldManager);
        request.setAttribute("statusOptions", statusOptions);
        request.setAttribute("approvedStudents", approvedStudents);
        request.getRequestDispatcher("WEB-INF/Class/classUpdate.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SubjectDAO subjectDAO = new SubjectDAO();
        String classId = request.getParameter("classId");
        String code = request.getParameter("code");
        String subject = request.getParameter("subject");
        String teacher = request.getParameter("teacher");
        String status = request.getParameter("status");

        String className = subjectDAO.getSubjectCodeById(Integer.parseInt(subject)) + "_" + code;

        UserDAO userDAO = new UserDAO();
        int teacherId = userDAO.getIdByUsername(teacher);

        // Convert status thành Enum
        ClassStatus classStatus = ClassStatus.valueOf(status);

        // Tạo đối tượng Class và set giá trị mới
        Class updatedClass = new Class();
        updatedClass.setId(Integer.parseInt(classId));
        updatedClass.setClassName(className);
        updatedClass.setCode(code);
        updatedClass.setSubjectId(Integer.parseInt(subject));
        updatedClass.setManagerId(teacherId);
        updatedClass.setStatus(classStatus);

        ClassDAO classDAO = new ClassDAO();
        classDAO.update(updatedClass);

        request.getSession().setAttribute("message", "Class updated successfully");
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
