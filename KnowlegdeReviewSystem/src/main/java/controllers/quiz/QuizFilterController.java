package controllers.quiz;

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
import jakarta.servlet.http.HttpSession;
import models.Lesson;
import models.Quiz;
import models.Subject;
import models.User;
import models.dao.LessonDAO;
import models.dao.QuizDAO;
import models.dao.SubjectDAO;
import services.dataaccess.LessonService;
import services.dataaccess.QuizService;
import services.dataaccess.SubjectService;

/**
 * @author Admin
 */
@WebServlet(name = "QuizFilterController", urlPatterns = {"/my_quiz/filter"})
public class QuizFilterController extends HttpServlet {
    private final QuizService quizService = new QuizService();
    private final LessonService lessonService = new LessonService();
    private final SubjectService subjectService = new SubjectService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet QuizFilterController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet QuizFilterController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy các tham số lọc từ request
        String subjectIdStr = request.getParameter("subjectId");
        String lessonIdStr = request.getParameter("lessonId");
        String status = request.getParameter("status");
        String quizName = request.getParameter("quizName");

        Integer subjectId = (subjectIdStr != null && !subjectIdStr.isEmpty()) ? Integer.parseInt(subjectIdStr) : null;
        Integer lessonId = (lessonIdStr != null && !lessonIdStr.isEmpty()) ? Integer.parseInt(lessonIdStr) : null;


        List<Quiz> filteredQuizzes = quizService.filterQuizzes(user.getId(), subjectId, lessonId, status, quizName);

        List<Lesson> lessons = lessonService.getLessonsByUserId(user.getId());

        List<Subject> subjects = subjectService.getSubjectsByUserId(user.getId());

        // Tạo map để chứa quizId → lessonId và quizId → lessonTitle
        Map<Integer, String> quizLessonTitleMap = new HashMap<>();
        Map<Integer, Integer> quizLessonIdMap = new HashMap<>();

        for (Quiz quiz : filteredQuizzes) {
            String lessonTitle = lessonService.getLessonTitleByQuizId(quiz.getId());
            quizLessonTitleMap.put(quiz.getId(), lessonTitle);

            Integer lessonIdFromMap = lessonService.getLessonIdByQuizId(quiz.getId());
            quizLessonIdMap.put(quiz.getId(), lessonIdFromMap);
        }

        // Trả về dữ liệu đã lọc dưới dạng HTML chỉ có phần <tbody> của bảng
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // Cung cấp HTML cho phần nội dung của bảng
        for (Quiz quiz : filteredQuizzes) {
            String lessonTitle = quizLessonTitleMap.get(quiz.getId());
            Integer lessonId1 = quizLessonIdMap.get(quiz.getId());

            // Cập nhật phần class dựa trên trạng thái quiz
            String badgeClass;
            if ("Completed".equals(quiz.getStatus().toString())) {
                badgeClass = "bg-success";
            } else if ("Unfinished".equals(quiz.getStatus().toString())) {
                badgeClass = "bg-secondary";
            } else {
                badgeClass = "bg-warning";
            }

            out.println("<tr>");
            out.println("<td>" + quiz.getQuizName() + "</td>");
            out.println("<td>" + lessonTitle + "</td>");
            out.println("<td>" + quiz.getNumOfQuestions() + "</td>");
            out.println("<td>");
            out.println("<span class='badge " + badgeClass + "'>" + quiz.getStatus() + "</span>");
            out.println("</td>");

            // Kiểm tra trạng thái và hiển thị các nút tương ứng
            out.println("<td>");
            if ("Completed".equals(quiz.getStatus().toString())) {
                out.println("<a href='quiz_result?id=" + quiz.getId() + "' class='btn btn-sm btn-success' title='Review Quiz'>" +
                        "<i class='bi bi-file-earmark-text-fill'></i> Review Quiz</a>");
            } else {
                out.println("<a href='take_quiz?quizId=" + quiz.getId() + "' class='btn btn-sm btn-primary' title='Start Quiz'>" +
                        "<i class='bi bi-play-circle-fill'></i> Start</a>");

                out.println("<a href='quiz_detail?quizId=" + quiz.getId() + "' class='btn btn-sm btn-primary' title='Quiz Detail'>" +
                        "<i class='bi bi-pencil-square'></i> Details</a>");

            }
            out.println("</td>");
            out.println("</tr>");
        }

    }


    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
