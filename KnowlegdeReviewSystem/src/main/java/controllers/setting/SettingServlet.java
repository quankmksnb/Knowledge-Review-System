/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers.setting;

import controllers.HomeServlet;
import controllers.dal.SettingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import jakarta.servlet.http.HttpSession;
import models.Setting;
import models.SettingType;
import models.User;
import org.json.JSONObject;

@WebServlet(name = "SettingServlet", urlPatterns = {"/setting", "/add-setting", "/update-setting", "/delete-setting", "/get-setting"})

public class SettingServlet extends HttpServlet {

    Logger LOGGER = Logger.getLogger(SettingServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        if (request.getParameter("typeFilter") != null) {
//            String typeFilter = request.getParameter("typeFilter");
//            List<Setting> settingsTpye = dao.getSettingsByType(typeFilter);
//            request.setAttribute("settingList", settingsTpye);
//            request.getRequestDispatcher("WEB-INF/settings.jsp").forward(request, response);
//            return;
//        }

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if(user == null || user.getRoleId() != 1){
            response.sendRedirect("/error");
            return;
        }

        String path = request.getServletPath();

        LOGGER.info(path);

        switch (path) {
            case "/setting":
                getSettings(request, response);
                break;

            case "/get-setting":
                getSetting(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String path = request.getServletPath();

        LOGGER.info(path);

        switch (path) {
            case "/add-setting":
                addSetting(request, response);
                break;

            case "/update-setting":
                updateSetting(request, response);
                break;

            case "/delete-setting":
                break;
        }
    }

    private void updateSetting(HttpServletRequest request, HttpServletResponse response) throws IOException {
        SettingDAO dao = new SettingDAO();

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        SettingType type = SettingType.valueOf(request.getParameter("type"));

        Setting setting = dao.getSettingById(id);

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        setting.setType(type);
        setting.setTitle(title);
        setting.setModifiedBy(user.getId());

        boolean isUpdated = dao.updateSetting(setting);

        // Create JSON response
        JSONObject jsonResponse = new JSONObject();
        if (isUpdated) {
            jsonResponse.put("success", true);
            jsonResponse.put("settingId", setting.getId());
            jsonResponse.put("settingTitle", setting.getTitle());
            jsonResponse.put("settingType", setting.getType());
            jsonResponse.put("message", "Setting updated successfully!");
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Failed to update setting.");
        }

        // Set response content type and write the JSON response
        response.setContentType("application/json");
        response.getWriter().write(jsonResponse.toString());
//        request.getSession().setAttribute("message", "Setting Updated successfully");
//        response.sendRedirect("setting");
    }

    private void getSettings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SettingDAO dao = new SettingDAO();

        List<Setting> settings = dao.getAllSettings();

        SettingType[] settingTypes = SettingType.values();
        request.setAttribute("settingTypes", settingTypes);
        request.setAttribute("settings", settings);
        request.getRequestDispatcher("WEB-INF/settinglist.jsp").forward(request, response);
    }

    private void addSetting(HttpServletRequest request, HttpServletResponse response) throws IOException {
        SettingDAO dao = new SettingDAO();

        String title = request.getParameter("title");
        SettingType type = SettingType.valueOf(request.getParameter("type"));

        Setting newSetting = new Setting();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        newSetting.setType(type);
        newSetting.setTitle(title);
        newSetting.setCreatedBy(user.getId());
        newSetting.setModifiedBy(user.getId());

        dao.addSetting(newSetting);

        request.getSession().setAttribute("message", "Setting created successfully");
        response.sendRedirect("setting");

    }

    private void getSetting(HttpServletRequest request, HttpServletResponse response){
        SettingDAO dao = new SettingDAO();

        int id = Integer.parseInt(request.getParameter("id"));

        Setting setting = dao.getSettingById(id);

        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("settingId", setting.getId());
        jsonResponse.put("settingTitle", setting.getTitle());
        jsonResponse.put("settingType", setting.getType());

        response.setContentType("application/json");

        try {
            response.getWriter().write(jsonResponse.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
