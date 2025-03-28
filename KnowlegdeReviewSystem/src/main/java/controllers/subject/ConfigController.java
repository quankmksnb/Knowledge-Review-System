package controllers.subject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.*;
import services.dataaccess.ConfigService;
import services.dataaccess.SettingService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "Config", value = "/config")
public class ConfigController extends HttpServlet {

    private ConfigService configService = new ConfigService();
    private SettingService settingService = new SettingService();


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Subject subject = (Subject) session.getAttribute("subject");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        User user = (User) session.getAttribute("user");

        if (user == null || (user.getRoleId() != 1 && user.getRoleId() != 5)) {
            request.getRequestDispatcher("WEB-INF/Web/error.jsp").forward(request, response);
        }
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listConfigs(request, response, subject);
                break;
            case "create":
                createConfig(request, response, subject);
                break;
            case "update":
                updateConfig(request, response);
                break;
            case "changeStatus":
                changeConfigStatus(request, response);
                break;
            default:
                listConfigs(request, response, subject);
                break;
        }
    }

    private void listConfigs(HttpServletRequest request, HttpServletResponse response, Subject subject)
            throws ServletException, IOException {
        List<DTOConfig> list = configService.findConfigBySubjectId(subject.getId());
        request.setAttribute("dtoConfigList", list);
        request.setAttribute("settingTypes", settingService.findAllByType(SettingType.Config)); // Sử dụng SettingService
        request.getRequestDispatcher("WEB-INF/SubjectManagement/configsubject.jsp").forward(request, response);
    }

    private void createConfig(HttpServletRequest request, HttpServletResponse response, Subject subject)
            throws ServletException, IOException {
        int subjectId = subject.getId();
        int typeId = Integer.parseInt(request.getParameter("typeId"));
        String description = request.getParameter("description");
        Config config = new Config(0, subjectId, typeId, description);
        configService.create(config);
        response.sendRedirect("config?status=success");
    }

    private void updateConfig(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getParameter("submit") == null) {
            int id = Integer.parseInt(request.getParameter("id"));
            Config config = configService.findById(id);
            request.setAttribute("config", config);
            request.setAttribute("settingTypes", settingService.findAllByType(SettingType.Config));
            request.getRequestDispatcher("WEB-INF/SubjectManagement/updateconfig.jsp").forward(request, response);
        } else {
            int id = Integer.parseInt(request.getParameter("id"));
            int typeId = Integer.parseInt(request.getParameter("typeId"));
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            Config config = new Config(id, 0, typeId, description);
            config.setStatus(status);
            configService.update(config);
            response.sendRedirect("config?status=success");
        }
    }

    private void changeConfigStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        if (status != null) {
            if (status.equals("Active")) {
                configService.changeStatus(id, "Inactive");
            } else {
                configService.changeStatus(id, "Active");
            }
        }
        response.sendRedirect("config?status=success");
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        processRequest(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        processRequest(request, response);
    }


}