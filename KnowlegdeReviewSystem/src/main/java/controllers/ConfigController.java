package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Config;
import models.DTOConfig;
import models.SettingType;
import models.Subject;
import models.dao.ConfigDAO;
import models.dao.SettingDAO;


import java.io.IOException;
import java.io.PrintWriter;

import java.util.List;
import java.util.Map;

@WebServlet(name = "Config", value = "/config")
public class ConfigController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        ConfigDAO configDAO = new ConfigDAO();
        SettingDAO settingDAO = new SettingDAO();
        Subject subject = (Subject) session.getAttribute("subject");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            DTOConfig dtoConfig = configDAO.findConfigBySubjectId(subject.getId());
            request.setAttribute("dtoConfig", dtoConfig);
            request.setAttribute("settingTypes", settingDAO.findAllByType(SettingType.Config));
            request.getRequestDispatcher("WEB-INF/SubjectManagement/configsubject.jsp").forward(request, response);
        }
        if (action != null && action.equals("create")) {
            int subjectId = subject.getId();
            int typeId = Integer.parseInt(request.getParameter("typeId"));
            String description = request.getParameter("description");
            Config config = new Config(0, subjectId, typeId, description);
            configDAO.create(config);
            response.sendRedirect("config?status=success");
        }
        if (action != null && action.equals("update")) {
            int id = Integer.parseInt(request.getParameter("id"));
            int typeId = Integer.parseInt(request.getParameter("typeId"));
            String description = request.getParameter("description");
            Config config = new Config(id, 0, typeId, description);
            configDAO.update(config);
            response.sendRedirect("config?status=success");
        }





    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        processRequest(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        processRequest(request, response);
    }

    public void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {

    }


}

