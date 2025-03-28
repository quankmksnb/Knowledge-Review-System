package controllers;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import models.dao.ClassDAO;
import models.dao.ClassInfo;
import services.dataaccess.ClassService;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet(name = "ClassServlet", urlPatterns = {
        "/class-details",
        "/class-info"})
public class ClassServlet extends HttpServlet {

    Logger LOGGER = Logger.getLogger(ClassServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        LOGGER.info(path);

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        ClassService classService = new ClassService();

        if (user == null) {
            response.sendRedirect("/login");
        }

        switch (path) {
            case "/class-details":

                int classId = Integer.parseInt(request.getParameter("class-id"));
                if (user.getRoleId() == 3 && !classService.isStudentApprovedInClass(user.getId(), classId)) {
                    response.sendRedirect("/error");
                    return;
                }

                getClassDetails(request, response);
                break;
            case "/class-info":
                getClassInfo(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        LOGGER.info(path);
        // Add POST logic if needed
    }

    private void getClassDetails(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {


        request.getRequestDispatcher("WEB-INF/Web/classDetails.jsp").forward(request, response);
    }

    private void getClassInfo(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Gson gson = new Gson();

        int classId;
        try {
            classId = Integer.parseInt(request.getParameter("class_id"));
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"error\": \"Invalid class_id\"}");
            return;
        }

        ClassService classService = new ClassService();
        ClassInfo classInfo = classService.getClassInfo(classId);

        if (classInfo == null) {
            response.getWriter().write("{\"error\": \"Class not found or database error\"}");
            return;
        }

        String jsonResponse = gson.toJson(classInfo);
        //LOGGER.info(jsonResponse);
        response.getWriter().write(jsonResponse);
    }
}