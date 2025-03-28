package controllers.user;

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
import models.Setting;
import models.User;
import models.UserStatus;
import models.dao.SettingDAO;
import models.dao.UserDAO;
import services.dataaccess.SettingService;
import services.dataaccess.UserService;

/**
 * @author Admin
 */
@WebServlet(name = "UserFilterController", urlPatterns = {"/user/search"})
public class UserFilterController extends HttpServlet {
    private final UserService userService = new UserService();
    private final SettingService settingService = new SettingService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String contentSearch = request.getParameter("search_fullname");
        String roleFilter = request.getParameter("roleFilter");
        String statusFilter = request.getParameter("statusFilter");

        List<User> list = userService.searchUsers(contentSearch,
                roleFilter != null && !roleFilter.isEmpty() ? Integer.parseInt(roleFilter) : null,
                statusFilter != null && !statusFilter.isEmpty() ? UserStatus.valueOf(statusFilter) : null);

        Map<Integer, String> roleMap = new HashMap<>();

        for (User user : list) {
            if (!roleMap.containsKey(user.getRoleId())) {
                Setting role = settingService.findById(user.getRoleId());
                if (role != null) {
                    roleMap.put(user.getRoleId(), role.getTitle());
                } else {
                    roleMap.put(user.getRoleId(), "Unknown");
                }
            }
        }

        PrintWriter out = response.getWriter();

        for (User o : list) {
            String statusClass = "warning"; // Mặc định là NotVerified
            if (o.getStatus() != null) {
                UserStatus status = o.getStatus();
                if (status == UserStatus.Active) {
                    statusClass = "success";
                } else if (status == UserStatus.Deactivated) {
                    statusClass = "danger";
                }
            }
            out.println("<tr>\n" +
                    "                            <td>" + o.getId() + "</td>\n" +
                    "                            <td>" + o.getFullName() + "</td>\n" +
                    "                            <td>" + o.getUsername() + "</td>\n" +
                    "                            <td>" + o.getEmail() + "</td>\n" +
                    "                            <td>" + roleMap.get(o.getRoleId()) + "</td>\n" +
                    "                            <td><span class='badge bg-" + statusClass + "'>" + o.getStatus() + "</span></td>\n" +
                    "                            <td>\n" +
                    "                                <a href='user_update?id=" + o.getId() + "' class='btn btn-sm action-btn' title='Edit'>\n" +
                    "                                   <i class='bi bi-pencil-square fs-5'></i>\n" +
                    "                                </a>\n" +
                    "                                <a href='javascript:void(0);' class='btn btn-sm action-btn' title='Toggle Status' onclick='toggleStatus(" + o.getId() + ")'>\n" +
                    "                                   <i id='lock-icon-" + o.getId() + "' class='bi " + (o.getStatus() == UserStatus.Deactivated ? "bi-lock-fill text-danger" : "bi-unlock-fill text-success") + " fs-5'></i>\n" +
                    "                                </a>\n" +
                    "                            </td>\n" +
                    "                        </tr>");
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
