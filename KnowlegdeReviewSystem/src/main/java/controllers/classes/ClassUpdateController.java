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

/**
 * @author Admin
 */
@WebServlet(name = "ClassUpdateController", urlPatterns = {"/class_update_management"})
public class ClassUpdateController extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SettingDAO settingDAO = new SettingDAO();
        SubjectDAO subjectDAO = new SubjectDAO();
        ClassDAO classDAO = new ClassDAO();
        UserDAO userDAO = new UserDAO();

        int clasID = Integer.parseInt(request.getParameter("classId"));
        List<Setting> domainList = settingDAO.findAllByType(SettingType.Category);
        List<Subject> subjectList = subjectDAO.findAll();
        Class oldClass = classDAO.findById(clasID);
        String oldDomain = subjectDAO.getDomain(oldClass.getSubjectId());
        String oldManager = userDAO.getManagerUsername(oldClass.getManagerId());
        List<ClassStatus> statusOptions = Arrays.asList(ClassStatus.values());
        List<User> approvedStudents = classDAO.getApprovedStudents(clasID);


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
        String manager = request.getParameter("manager");
        String status = request.getParameter("status");

        String className = subjectDAO.getSubjectCodeById(Integer.parseInt(subject)) + "_" + code;

        UserDAO userDAO = new UserDAO();
        int managerId = userDAO.getIdByUsername(manager);

        // Convert status thành Enum
        ClassStatus classStatus = ClassStatus.valueOf(status);

        // Tạo đối tượng Class và set giá trị mới
        Class updatedClass = new Class();
        updatedClass.setId(Integer.parseInt(classId));
        updatedClass.setClassName(className);
        updatedClass.setCode(code);
        updatedClass.setSubjectId(Integer.parseInt(subject));
        updatedClass.setManagerId(managerId);
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
