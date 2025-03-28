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
import services.dataaccess.ClassService;
import services.dataaccess.SettingService;
import services.dataaccess.SubjectService;
import services.dataaccess.UserService;

/**
 * @author Admin
 */
@WebServlet(name = "ClassListController", urlPatterns = {"/class_management"})
public class ClassListController extends HttpServlet {
    private final ClassService classService = new ClassService();
    private final SubjectService subjectService = new SubjectService();
    private final UserService userService = new UserService();
    private final SettingService settingService = new SettingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Setting> semesterList = settingService.findAllBySemester();
        List<Setting> domainList = settingService.findAllByType(SettingType.Category);
        List<Subject> subjectList = subjectService.findAll();

        Integer latestSemesterId = classService.getLatestSemesterId();
        // Lấy danh sách các lớp học theo semester tạo muộn nhất được mặc định
        List<Class> classList = classService.searchClasses(null, latestSemesterId, null, null);

        // phân trang
        int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        int itemsPerPage = 8;  // Số lớp mỗi trang
        int totalItems = classList.size();
        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
        int startIndex = (currentPage - 1) * itemsPerPage;
        int endIndex = Math.min(startIndex + itemsPerPage, totalItems);

        // Lấy danh sách lớp cho trang hiện tại
        List<Class> paginatedClassList = classList.subList(startIndex, endIndex);

        // Tạo các map để lưu thông tin ánh xạ
        Map<Integer, String> subjectCodeMap = new HashMap<>();
        Map<Integer, String> domainMap = new HashMap<>();
        Map<Integer, String> managerUsernameMap = new HashMap<>();

        // Ánh xạ SubjectCode, Domain và Manager
        for (Class cls : paginatedClassList) { // Dùng paginatedClassList thay vì classList
            // Subject Code
            if (!subjectCodeMap.containsKey(cls.getSubjectId())) {
                String subjectCode = subjectService.getSubjectCodeById(cls.getSubjectId());
                subjectCodeMap.put(cls.getSubjectId(), subjectCode);
            }

            // Domain
            if (!domainMap.containsKey(cls.getSubjectId())) {
                String domain = subjectService.getDomain(cls.getSubjectId());
                domainMap.put(cls.getSubjectId(), domain);
            }

            // Manager Username
            if (!managerUsernameMap.containsKey(cls.getManagerId())) {
                String managerUsername = userService.getManagerUsername(cls.getManagerId());
                managerUsernameMap.put(cls.getManagerId(), managerUsername);
            }
        }

        // Truyền các map vào request
        request.setAttribute("classList", paginatedClassList); // Chuyển sang paginatedClassList
        request.setAttribute("subjectCodeMap", subjectCodeMap);
        request.setAttribute("domainMap", domainMap);
        request.setAttribute("managerUsernameMap", managerUsernameMap);
        request.setAttribute("semesterList", semesterList);
        request.setAttribute("domainList", domainList);
        request.setAttribute("subjectList", subjectList);
        request.setAttribute("currentPage", currentPage); // Truyền currentPage
        request.setAttribute("totalPages", totalPages);  // Truyền totalPages
        request.getRequestDispatcher("WEB-INF/Class/classList.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String code = request.getParameter("code");
        int subjectId = Integer.parseInt(request.getParameter("subject"));
        int managerId = userService.getIdByUsername(request.getParameter("manager"));
        int semesterId = Integer.parseInt(request.getParameter("semester"));
        String status = request.getParameter("status");
        String className = subjectService.getSubjectCodeById(subjectId) + "_" + code;

        Class newClass = new Class();
        newClass.setCode(code);
        newClass.setClassName(className);
        newClass.setSubjectId(subjectId);
        newClass.setManagerId(managerId);
        newClass.setSemesterId(semesterId);
        newClass.setStatus(ClassStatus.valueOf(status));

        ClassDAO classDAO = new ClassDAO();
        classDAO.create(newClass);
        classDAO.addStudentToClass(
                classDAO.getClassByCriteria(code,
                                subjectId,
                                managerId,
                                semesterId,
                                className)
                        .getId()
                , managerId);

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
