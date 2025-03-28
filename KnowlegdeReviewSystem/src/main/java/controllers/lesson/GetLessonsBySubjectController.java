package controllers.lesson;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Lesson;
import models.dao.LessonDAO;
import services.dataaccess.LessonService;

/**
 * @author Admin
 */
@WebServlet(name = "GetLessonsBySubjectController", urlPatterns = {"/getLessonsBySubject"})
public class GetLessonsBySubjectController extends HttpServlet {
    private LessonService lessonService = new LessonService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));


        // Lấy danh sách bài học cho subjectId
        List<Lesson> lessons = lessonService.getLessonsBySubject(subjectId);

        // Trả về dữ liệu dưới dạng JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(new Gson().toJson(lessons)); // Chuyển đổi danh sách Lesson thành JSON
        out.flush();
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
