package controllers.lesson;
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
import models.Lesson;
import models.dao.LessonDAO;
import services.dataaccess.LessonService;

/**
 *
 * @author Admin
 */
@WebServlet(name="LessonListController", urlPatterns={"/lesson_list"})
public class LessonListController extends HttpServlet {
    private LessonService lessonService = new LessonService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get subjectId from URL
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));

            List<Lesson> lessons = lessonService.getLessonsBySubject(subjectId);

            // Pagination logic
            int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            int itemsPerPage = 8;  // Define number of lessons per page
            int totalItems = lessons.size();
            int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);

            int startIndex = (currentPage - 1) * itemsPerPage;
            int endIndex = Math.min(startIndex + itemsPerPage, totalItems);

            List<Lesson> paginatedLessons = lessons.subList(startIndex, endIndex);

            Map<Integer, String> lessonChapters = new HashMap<>();
            for (Lesson lesson : paginatedLessons) {
                String chapterName = lessonService.getChapterNameByLessonId(lesson.getId());
                lessonChapters.put(lesson.getId(), chapterName);
            }

            // Set attributes for pagination and lessons
            request.setAttribute("lessons", paginatedLessons);
            request.setAttribute("lessonChapters", lessonChapters);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("subjectId", subjectId);

            request.getRequestDispatcher("WEB-INF/SubjectManagement/getlesson.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid subject ID");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
