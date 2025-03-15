package controllers;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import jakarta.mail.Session;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.*;
import models.Class;
import models.dao.LessonDAO;
import models.dao.QuestionDAO;
import org.json.JSONObject;

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
        "/class-details",
        "/class-enroll",
        "/getMyClasses",
        "/getAllClasses",
        "/searchClasses",
        "/getClassDetailsEnroll",
        "/enrollClass",
        "/classInfo"})
public class HomeServlet extends HttpServlet {

    Logger LOGGER = Logger.getLogger(HomeServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        LOGGER.info(path);

        switch (path) {
            case "/home":
                request.getRequestDispatcher("WEB-INF/Web/index.jsp").forward(request, response);
                break;

            case "/getSubjects":
                getSubjects(request, response);
                break;

            case "/searchSubjects":
                searchSubject(request, response);
                break;

            case "/admin":
                request.getRequestDispatcher("WEB-INF/Admin/homeAdmin.jsp").forward(request, response);
                break;
            case "/public-classes":
                request.getRequestDispatcher("WEB-INF/Web/publicClass.jsp").forward(request, response);
                break;
            case "/class-details":
                request.getRequestDispatcher("WEB-INF/Web/classDetails.jsp").forward(request, response);
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
            case "/classInfo":
                getClass(request, response);
                break;
            case "/getMyClasses":
                getMyClass(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        LOGGER.info(path);

        switch (path) {
            case "/enrollClass":
                enrolClass(request, response);
                break;

        }
    }

    private void getSubjects(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Mock subject data (replace with database call)
        List<Subject> subjects = WebManager.getInstance().getSubjectDAO().findAll();

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

        String keyword = request.getParameter("query");
        List<Subject> subjects = WebManager.getInstance().getSubjectDAO().searchSubjects(keyword, 5); // Limit to 5 results

        Gson gson = new Gson();
        String json = gson.toJson(subjects);
        response.getWriter().write(json);
    }

    private void getClasses(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Fetch class data from database
        List<Class> classes = WebManager.getInstance().getClassDAO().findAll();

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

        String keyword = request.getParameter("query");
        List<Class> classes = WebManager.getInstance().getClassDAO().searchClasses(keyword, 5); // Limit to 5 results

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

        if(user == null){
            classes = WebManager.getInstance().getClassDAO().findAll();
        } else {
            LOGGER.warning(user.getId().toString());
            classes = WebManager.getInstance().getClassDAO().findClassesByStudentId(user.getId());
        }

        // Convert to JSON
        String json = new Gson().toJson(classes);

        // Send JSON response
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }

    private void getClass(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Gson gson = new Gson();
        JsonObject jsonResponse = new JsonObject();
        JsonArray lessonsArray = new JsonArray(); // JSON array to store lessons

        int classId = Integer.parseInt(request.getParameter("class_id"));

        Class _class = WebManager.getInstance().getClassDAO().findById(classId);

        List<Lesson> lessons = WebManager.getInstance().getLessonDAO().findAllLessonsInSubject(_class.getSubjectId());

        //String json = new Gson().toJson(lessons);

        jsonResponse.addProperty("className", _class.getClassName());
        jsonResponse.addProperty("classCode", _class.getCode());
        jsonResponse.addProperty("subjectName", _class.getSubjectName());

        // Convert lessons to JSON array
        for (Lesson lesson : lessons) {
            JsonObject lessonJson = new JsonObject();
            lessonJson.addProperty("lessonId", lesson.getId());
            lessonJson.addProperty("title", lesson.getTitle());
            lessonJson.addProperty("description", lesson.getDescription());

            JsonArray questionsArray = new JsonArray();

            List<Question> questions = WebManager.getInstance().getQuestionDAO().findByLessonId(lesson.getId());

            // Convert lessons to JSON array
            for (Question question : questions) {
                JsonObject questionJson = new JsonObject();
                questionJson.addProperty("id", question.getId());
                questionJson.addProperty("content", question.getContent());
                questionsArray.add(questionJson);
            }

            lessonJson.add("questions", questionsArray);

            lessonsArray.add(lessonJson);
        }

        jsonResponse.add("lessons", lessonsArray); // Add lessons array

        LOGGER.info(gson.toJson(jsonResponse));

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(jsonResponse));
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

        Class _class = WebManager.getInstance().getClassDAO().findById(classId);
        LOGGER.info(_class.getStatus().toString());

        jsonResponse.addProperty("className", _class.getClassName());
        jsonResponse.addProperty("code", _class.getCode());
        jsonResponse.addProperty("subjectName", _class.getSubjectName());
        jsonResponse.addProperty("managerName", _class.getManagerName());
        jsonResponse.addProperty("status", _class.getStatus().toString());

        response.getWriter().write(gson.toJson(jsonResponse));
    }

    private void enrolClass(HttpServletRequest request, HttpServletResponse response) throws IOException {
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

        try {
            int classId = Integer.parseInt(request.getParameter("id"));

            // Enroll the student into the class
            WebManager.getInstance().getClassDAO().enrollStudent(user.getId(), classId);
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

}
