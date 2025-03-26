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
import models.dao.ConfigDAO;
import models.dao.LessonDAO;

/**
 * @author Admin
 */
@WebServlet(name = "CreateLessonController", urlPatterns = {"/create_lesson"})
public class CreateLessonController extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the subjectId from the request
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));

        // Get the list of chapters for the subject
        ConfigDAO configDAO = new ConfigDAO();
        List<Config> chapterList = configDAO.getChaptersBySubject(subjectId);

        // Set the chapter list as a request attribute
        request.setAttribute("chapterList", chapterList);
        request.getRequestDispatcher("WEB-INF/SubjectManagement/createLesson.jsp").forward(request, response);

    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin từ form
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String videoUrl = request.getParameter("videoUrl");
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            int chapterId = Integer.parseInt(request.getParameter("chapterId"));

            // Tạo đối tượng Lesson và lưu vào cơ sở dữ liệu
            LessonDAO lessonDAO = new LessonDAO();
            boolean result = lessonDAO.addLesson1(title, description, videoUrl, subjectId, chapterId);

            // Redirect lại trang danh sách bài học sau khi thêm mới
            if (result) {
                response.sendRedirect("lesson_list?subjectId=" + subjectId);
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create lesson.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input.");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
