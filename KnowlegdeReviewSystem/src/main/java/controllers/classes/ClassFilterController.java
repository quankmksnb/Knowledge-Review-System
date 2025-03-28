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
import models.Class;
import models.ClassStatus;
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
@WebServlet(name = "ClassFilterController", urlPatterns = {"/class_management/search"})
public class ClassFilterController extends HttpServlet {
    private final ClassService classService = new ClassService();
    private final SubjectService subjectService = new SubjectService();
    private final UserService userService = new UserService();
    private final SettingService settingService = new SettingService();


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Nhận tham số lọc từ request
        String searchQuery = request.getParameter("searchClassFilter");
        String semesterFilter = request.getParameter("semesterFilter");
        String domainFilter = request.getParameter("domainFilter");
        String statusFilter = request.getParameter("statusFilter");

        // Chuyển đổi dữ liệu từ String sang Integer
        Integer semesterId = (semesterFilter != null && !semesterFilter.isEmpty()) ? Integer.parseInt(semesterFilter) : null;
        Integer domainId = (domainFilter != null && !domainFilter.isEmpty()) ? Integer.parseInt(domainFilter) : null;
        String status = (statusFilter != null && !statusFilter.isEmpty()) ? statusFilter : null;

        // Lọc danh sách lớp học theo các tiêu chí
        List<Class> classList = classService.searchClasses(searchQuery, semesterId, domainId, status);

        // Ánh xạ SubjectCode, Domain và Manager Name
        Map<Integer, String> subjectCodeMap = new HashMap<>();
        Map<Integer, String> domainMap = new HashMap<>();
        Map<Integer, String> managerUsernameMap = new HashMap<>();

        for (Class cls : classList) {
            // Subject Code Mapping
            if (!subjectCodeMap.containsKey(cls.getSubjectId())) {
                String subjectCode = subjectService.getSubjectCodeById(cls.getSubjectId());
                subjectCodeMap.put(cls.getSubjectId(), subjectCode);
            }

            // Domain Mapping
            if (!domainMap.containsKey(cls.getSubjectId())) {
                String domain = subjectService.getDomain(cls.getSubjectId());
                domainMap.put(cls.getSubjectId(), domain);
            }

            // Manager Username Mapping
            if (!managerUsernameMap.containsKey(cls.getManagerId())) {
                String managerUsername = userService.getManagerUsername(cls.getManagerId());
                managerUsernameMap.put(cls.getManagerId(), managerUsername);
            }
        }

        // Gửi dữ liệu về JSP dưới dạng HTML
        PrintWriter out = response.getWriter();
        for (Class cls : classList) {
            String statusBadge = "<span class='badge bg-secondary'>" + cls.getStatus() + "</span>";
            if ("Public".equals(cls.getStatus().toString())) {
                statusBadge = "<span class='badge bg-success'>" + cls.getStatus() + "</span>";
            } else if ("Private".equals(cls.getStatus().toString())) {
                statusBadge = "<span class='badge bg-info'>" + cls.getStatus() + "</span>";
            } else if ("Cancelled".equals(cls.getStatus().toString())) {
                statusBadge = "<span class='badge bg-danger'>" + cls.getStatus() + "</span>";
            }

            // Xử lý các nút chỉnh sửa và icon khóa/mở khóa
            String editButton = "<a href='class_update_management?classId=" + cls.getId() + "' class='btn btn-sm action-btn' title='Edit'>" +
                    "<i class='bi bi-pencil-square fs-5'></i>" +
                    "</a>";

            // Toggle lock icon (quản lý trạng thái khóa/mở khóa)
            String lockIcon = "<a href='javascript:void(0);' class='btn btn-sm action-btn' title='Toggle Status' onclick='toggleStatus(" + cls.getId() + ")'>" +
                    "<i id='lock-icon-" + cls.getId() + "' class='bi " +
                    (cls.getStatus() == ClassStatus.Private ? "bi-lock-fill text-info" : "bi-unlock-fill text-success") +
                    " fs-5'></i>" +
                    "</a>";

            out.println("<tr>\n" +
                    "   <td>" + cls.getCode() + "</td>\n" +
                    "   <td>" + cls.getClassName() + "</td>\n" +
                    "   <td>" + domainMap.get(cls.getSubjectId()) + "</td>\n" +
                    "   <td>" + subjectCodeMap.get(cls.getSubjectId()) + "</td>\n" +
                    "   <td>" + managerUsernameMap.get(cls.getManagerId()) + "</td>\n" +
                    "   <td>" + statusBadge + "</td>\n" +
                    "   <td>\n" +
                    editButton + lockIcon +
                    "   </td>\n" +
                    "</tr>");
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
