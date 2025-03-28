package controllers.lesson;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Config;
import models.User;
import models.dao.ConfigDAO;
import models.dao.LessonDAO;
import services.dataaccess.ConfigService;
import services.dataaccess.LessonService;

/**
 * @author Admin
 */
@WebServlet(name = "CreateLessonController", urlPatterns = {"/create_lesson"})
public class CreateLessonController extends HttpServlet {
    private ConfigService configService = new ConfigService();
    private LessonService lessonService = new LessonService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the subjectId from the request
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));


        List<Config> chapterList = configService.getChaptersBySubject(subjectId);

        // Set the chapter list as a request attribute
        request.setAttribute("chapterList", chapterList);
        request.getRequestDispatcher("WEB-INF/SubjectManagement/createLesson.jsp").forward(request, response);

    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            // Lấy thông tin từ form
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String videoUrl = request.getParameter("videoUrl");
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            int chapterId = Integer.parseInt(request.getParameter("chapterId"));



            boolean result = lessonService.addLesson1(title, description, videoUrl, subjectId, chapterId, user.getId());

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
