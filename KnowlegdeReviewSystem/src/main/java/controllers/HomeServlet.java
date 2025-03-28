package controllers;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.*;
import models.Class;
import org.json.JSONObject;
import services.dataaccess.ClassService;
import services.dataaccess.SubjectService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home",
        "/getSubjects",
        "/searchSubjects",
        "/admin",
        "/public-classes",
        "/class-enroll",
        "/getMyClasses",
        "/getAllClasses",
        "/searchClasses",
        "/getClassDetailsEnroll",
        "/enrollClass",
        "/popular-classes",
        "/classInfo",
        "/my-class",
        "/error"})
public class HomeServlet extends HttpServlet {

    Logger LOGGER = Logger.getLogger(HomeServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        LOGGER.info(path);

        switch (path) {
            case "/home":
                request.getRequestDispatcher("WEB-INF/Web/home.jsp").forward(request, response);
                break;

            case "/getSubjects":
                getSubjects(request, response);
                break;

            case "/searchSubjects":
                searchSubject(request, response);
                break;

            case "/admin":
                request.getRequestDispatcher("WEB-INF/Admin/dashboardAdmin.jsp").forward(request, response);
                break;
            case "/public-classes":
                request.getRequestDispatcher("WEB-INF/Web/publicClass.jsp").forward(request, response);
                break;
            case "/class-enroll":
                request.getRequestDispatcher("WEB-INF/Web/enroll.jsp").forward(request, response);
                break;
            case "/getAllClasses":
                getClasses(request, response);
                break;
            case "/searchClasses":
                searchClass(request, response);
                break;
            case "/getClassDetailsEnroll":
                getClassDetailsEnroll(request, response);
                break;
            case "/getMyClasses":
                getMyClass(request, response);
                break;

            case "/popular-classes":
                getPopularClasses(request, response);
                break;

            case "/error":
                request.getRequestDispatcher("WEB-INF/Web/error.jsp").forward(request, response);
                break;

            case "/my-class":
                request.getRequestDispatcher("WEB-INF/Web/index.jsp").forward(request, response);
                break;
            default:
                request.getRequestDispatcher("WEB-INF/Web/home.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        LOGGER.info(path);

        switch (path) {
            case "/enrollClass":
                enrollClass(request, response);
                break;

        }
    }

    private void getSubjects(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        SubjectService subjectService = new SubjectService();

        // Mock subject data (replace with database call)
        List<Subject> subjects = subjectService.findAll();

        // Convert to JSON
        String json = new Gson().toJson(subjects);

        // Send JSON response
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }

    private void searchSubject(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        SubjectService subjectService = new SubjectService();
        String keyword = request.getParameter("query");
        List<Subject> subjects = subjectService.searchSubjects(keyword, 5); // Limit to 5 results

        Gson gson = new Gson();
        String json = gson.toJson(subjects);
        response.getWriter().write(json);
    }

    private void getClasses(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        ClassService classService = new ClassService();

        // Fetch class data from database
        List<Class> classes = classService.findAllPublicClasses();

        // Convert to JSON
        String json = new Gson().toJson(classes);

        // Send JSON response
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }

    private void searchClass(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        ClassService classService = new ClassService();
        String keyword = request.getParameter("query");
        List<Class> classes = classService.searchClasses(keyword, 5); // Limit to 5 results

        Gson gson = new Gson();
        String json = gson.toJson(classes);
        response.getWriter().write(json);
    }

    private void getMyClass(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        System.out.println(user);

        // Fetch class data from database
        List<Class> classes = new ArrayList<>();
        ClassService classService = new ClassService();

        if(user == null){
            classes = classService.findAllPublicClasses();
        } else {
            LOGGER.warning(user.getId().toString());
            classes = classService.findClassesByStudentId(user.getId());
        }

        // Convert to JSON
        String json = new Gson().toJson(classes);

        // Send JSON response
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }

    private void getClassDetailsEnroll(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int classId = Integer.parseInt(request.getParameter("id"));

        Gson gson = new Gson();
        JsonObject jsonResponse = new JsonObject();

        if (user != null) {
            boolean isStudentInClass = WebManager.getInstance().getClassDAO().isStudentInClass(user.getId(), classId);

            if (isStudentInClass) {
                LOGGER.info("Student " + user.getUsername() + " already in class");

                ClassStudentStatus status = WebManager.getInstance().getClassDAO().getStudentStatusInClass(user.getId(), classId);

                if (status == ClassStudentStatus.Unapproved) {
                    jsonResponse.addProperty("enrollmentStatus", "Pending");
                } else {
                    jsonResponse.addProperty("enrollmentStatus", "Enrolled");
                    jsonResponse.addProperty("redirectUrl", "/class-details?class-id=" + classId);
                }
            } else {
                jsonResponse.addProperty("enrollmentStatus", "Not Enrolled");
            }
        } else {
            jsonResponse.addProperty("enrollmentStatus", "Guest");
        }


        ClassService classService = new ClassService();

        Class _class = classService.findById(classId);
        LOGGER.info(_class.getStatus().toString());

        jsonResponse.addProperty("className", _class.getClassName());
        jsonResponse.addProperty("code", _class.getCode());
        jsonResponse.addProperty("subjectName", _class.getSubjectName());
        jsonResponse.addProperty("managerName", _class.getManagerName());
        jsonResponse.addProperty("description", _class.getDescription());
        jsonResponse.addProperty("status", _class.getStatus().toString());

        response.getWriter().write(gson.toJson(jsonResponse));
    }

    private void enrollClass(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        JSONObject jsonResponse = new JSONObject();

        // Check if the user is logged in
        if (session == null || session.getAttribute("user") == null) {

            LOGGER.warning("User is not logged in");

            jsonResponse.put("error", "User not logged in");
            jsonResponse.put("redirectUrl", "/login");
            response.getWriter().write(jsonResponse.toString());
            return;
        }

        User user = (User) session.getAttribute("user");


        ClassService classService = new ClassService();

        try {
            int classId = Integer.parseInt(request.getParameter("id"));

            // Enroll the student into the class
            classService.enrollStudent(user.getId(), classId);
            jsonResponse.put("success", "Enrollment successful");
            response.getWriter().write(jsonResponse.toString());

        } catch (NumberFormatException e) {
            jsonResponse.put("error", "Invalid class ID");
            response.getWriter().write(jsonResponse.toString());
        } catch (Exception e) {
            jsonResponse.put("error", "Failed to enroll in class");
            response.getWriter().write(jsonResponse.toString());
        }
    }

    private void getPopularClasses (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

        ClassService classService = new ClassService();

        // Mock data (replace with actual database query)
        List<Class> classes = classService.findAllPublicClasses();

        List<Class> popularClasses = new ArrayList<>();
        if (classes != null && !classes.isEmpty()) {
            // Take the first 3 classes (or fewer if the list has less than 3)
            int limit = Math.min(classes.size(), 3);
            popularClasses = classes.subList(0, limit);
        }

            Gson gson = new Gson();
            response.getWriter().write(gson.toJson(popularClasses));
    }
}
