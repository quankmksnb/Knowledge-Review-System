/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers.setting;

import controllers.dal.SettingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import models.Setting;

@WebServlet(name = "SettingServlet", value = "/setting")

public class SettingServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SettingDAO dao = new SettingDAO();
        
        if (request.getParameter("typeFilter") != null) {
            String typeFilter = request.getParameter("typeFilter");
            List<Setting> settingsTpye = dao.getSettingsByType(typeFilter);
            request.setAttribute("settingList", settingsTpye);
            request.getRequestDispatcher("WEB-INF/settings.jsp").forward(request, response);
            return;

        }
        
        
        List<Setting> settings = dao.getAllSettings();

        if (request.getParameter("action") != null) {
            String action = request.getParameter("action");
            if (action.equals("detail")) {
                int id = Integer.parseInt(request.getParameter("id"));
                Setting setting = dao.getSettingById(id);
                request.setAttribute("setting", setting);
                request.getRequestDispatcher("WEB-INF/detail_setting.jsp").forward(request, response);
                return;
            }
        }

        

        request.setAttribute("settingList", settings);
        request.getRequestDispatcher("WEB-INF/settings.jsp").forward(request, response);

    }
}
