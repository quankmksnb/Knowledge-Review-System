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

/**
 *
 * @author Admin
 */
@WebServlet(name="LessonListController", urlPatterns={"/lesson_list"})
public class LessonListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Lấy subjectId từ URL
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));

            LessonDAO lessonDAO = new LessonDAO();
            List<Lesson> lessons = lessonDAO.getLessonsBySubject(subjectId);


            Map<Integer, String> lessonChapters = new HashMap<>();
            for (Lesson lesson : lessons) {
                String chapterName = lessonDAO.getChapterNameByLessonId(lesson.getId());
                lessonChapters.put(lesson.getId(), chapterName);
            }


            request.setAttribute("lessons", lessons);
            request.setAttribute("lessonChapters", lessonChapters);
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
