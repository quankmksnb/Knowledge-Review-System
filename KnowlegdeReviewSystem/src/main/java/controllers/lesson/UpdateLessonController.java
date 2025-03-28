package controllers.lesson;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Config;
import models.Lesson;
import models.dao.ConfigDAO;
import models.dao.LessonDAO;
import services.dataaccess.ConfigService;
import services.dataaccess.LessonService;

/**
 * @author Admin
 */
@WebServlet(name = "UpdateLessonController", urlPatterns = {"/update_lesson"})
public class UpdateLessonController extends HttpServlet {
    private LessonService lessonService = new LessonService();
    private ConfigService configService = new ConfigService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("id"));

            Lesson lesson = lessonService.getLessonById(lessonId);

            // Get list of Chapters for the subject
            int subjectId = lesson.getSubjectId();

            List<Config> chapterList = configService.getChaptersBySubject(subjectId);

            // Get current chapter ID for the lesson
            int currentChapterId = configService.getChapterIdByLessonId(lessonId);

            // Set attributes
            request.setAttribute("lesson", lesson);
            request.setAttribute("chapterList", chapterList);
            request.setAttribute("currentChapterId", currentChapterId);

            // Forward to JSP
            request.getRequestDispatcher("WEB-INF/SubjectManagement/updateLesson.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid lesson ID");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int chapterId = Integer.parseInt(request.getParameter("chapterId"));
            String lessonVideo = request.getParameter("videoUrl");


            boolean success = lessonService.updateLessonWithChapter(lessonId,  lessonService.getLessonById(lessonId).getSubjectId(), title, description, chapterId, lessonVideo);

            if (success) {
                response.sendRedirect("lesson_list?subjectId=" + lessonService.getLessonById(lessonId).getSubjectId());
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating lesson");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error while updating lesson");
        }

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
