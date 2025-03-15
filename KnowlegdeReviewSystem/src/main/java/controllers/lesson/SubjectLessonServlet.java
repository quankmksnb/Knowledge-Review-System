package controllers.lesson;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import controllers.dal.LessonDAO;
import models.Lesson;

@WebServlet(name = "SubjectLessonServlet", value = "/subjectLesson")
public class SubjectLessonServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LessonDAO lessonDAO = new LessonDAO();

        if (request.getParameter("textSearch") != null) {
            String textSearch = request.getParameter("textSearch");
            List<Lesson> lessonList = lessonDAO.getLessonsByTitle(textSearch);
            request.setAttribute("lesson", lessonList);
            request.getRequestDispatcher("WEB-INF/subject_lesson.jsp").forward(request, response);
            return;
        }

        List<Lesson> lessonList = lessonDAO.getAllLessons();
        if (request.getParameter("message") != null) {
            request.setAttribute("message", request.getParameter("message"));
        }

        if (request.getParameter("action") != null) {
            if (request.getParameter("action").equals("delete")) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean checkDelete = lessonDAO.deleteLesson(id);
                if (checkDelete) {
                    response.sendRedirect("subjectLesson?deleted=success");
                    return;

                } else {
                    response.sendRedirect("subjectLesson?deleted=error");
                    return;
                }
            } else if (request.getParameter("action").equals("edit")) {
                int id = Integer.parseInt(request.getParameter("id"));
                Lesson lesson = lessonDAO.getLessonById(id);

                if (lesson == null) {
                    response.sendRedirect("subjectLesson?messageedit=lesson_not_found");
                    return;
                }

                request.setAttribute("lesson", lesson);
                request.getRequestDispatcher("WEB-INF/edit_lesson.jsp").forward(request, response);
                return;
            }

        }

        request.setAttribute("lessonList", lessonList);
        request.getRequestDispatcher("WEB-INF/subject_lesson.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int userId = 1;

        if ("add".equals(action)) {
            int subjectId = Integer.parseInt(request.getParameter("subject_id"));
            String lessonName = request.getParameter("lesson_name");
            String description = request.getParameter("description");

            LessonDAO lessonDAO = new LessonDAO();
            boolean success = lessonDAO.addLesson(userId, subjectId, lessonName, description);

            if (success) {
                response.sendRedirect("subjectLesson?message=success");
            } else {
                response.sendRedirect("subjectLesson?message=error");
            }
        } else if ("edit".equals(action)) {
            int lessonId = Integer.parseInt(request.getParameter("lesson_id"));
            int subjectId = Integer.parseInt(request.getParameter("subject_id"));
            String lessonName = request.getParameter("lesson_name");
            String description = request.getParameter("description");

            LessonDAO lessonDAO = new LessonDAO();
            boolean success = lessonDAO.updateLesson(lessonId, userId, subjectId, lessonName, description);

            if (success) {
                response.sendRedirect("subjectLesson?message=edit_success");
            } else {
                response.sendRedirect("subjectLesson?message=edit_error");
            }
        }
    }

}
