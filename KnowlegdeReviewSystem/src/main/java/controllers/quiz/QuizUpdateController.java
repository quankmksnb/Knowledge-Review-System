package controllers.quiz;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.*;
import models.dao.ClassDAO;
import models.dao.LessonDAO;
import models.dao.QuizDAO;
import models.dao.SubjectDAO;
import services.dataaccess.ClassService;
import services.dataaccess.LessonService;
import services.dataaccess.QuizService;
import services.dataaccess.SubjectService;

/**
 * @author Admin
 */
@WebServlet(name = "QuizUpdateController", urlPatterns = {"/quiz_detail"})
public class QuizUpdateController extends HttpServlet {
    private final QuizService quizService = new QuizService();
    private final LessonService lessonService = new LessonService();
    private final SubjectService subjectService = new SubjectService();
    private final ClassService classService = new ClassService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy user từ session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        int quizId = Integer.parseInt(request.getParameter("id"));


        // Lấy thông tin quiz từ database
        Quiz quiz = quizService.findById(quizId);
        String lessonTitle = lessonService.getLessonTitleByQuizId(quizId);
        String subjectName = subjectService.getSubjectNameById(quiz.getSubjectId());

        // Lấy danh sách subjects và lessons để hiển thị trên dropdown
        List<Subject> enrolledSubjects = classService.getEnrolledSubjectsByUserId(user.getId());
        List<Lesson> lessons = lessonService.getLessonsBySubjectId(quiz.getSubjectId());
        int lessonId = lessonService.getLessonIdByQuizId(quizId);


        // Set attributes để hiển thị trên JSP
        request.setAttribute("quiz", quiz);
        request.setAttribute("subjectName", subjectName);
        request.setAttribute("lessonTitle", lessonTitle);
        request.setAttribute("enrolledSubjects", enrolledSubjects);
        request.setAttribute("lessons", lessons);
        request.setAttribute("lessonId", lessonId);

        request.getRequestDispatcher("WEB-INF/Quiz/quizUpdate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý việc update quiz
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy dữ liệu từ form
        int quizId = Integer.parseInt(request.getParameter("quizId"));
        String quizName = request.getParameter("quizName");
        int subjectId = Integer.parseInt(request.getParameter("subject"));
        int lessonId = Integer.parseInt(request.getParameter("lesson"));
        int numOfQuestions = Integer.parseInt(request.getParameter("numOfQuestions"));


        // Cập nhật quiz
        Quiz updatedQuiz = new Quiz();
        updatedQuiz.setId(quizId);
        updatedQuiz.setQuizName(quizName);
        updatedQuiz.setSubjectId(subjectId);
        updatedQuiz.setUserId(user.getId());
        updatedQuiz.setNumOfQuestions(numOfQuestions);
        updatedQuiz.setStatus(QuizStatus.Unfinished); // Set trạng thái là Unfinished
        quizService.update(updatedQuiz);

        // Cập nhật bảng quiz_lesson (liên kết lại quiz và lesson)
        quizService.updateQuizLesson(quizId, lessonId);

        // Cập nhật bảng quiz_question: Xóa câu hỏi cũ và thêm câu hỏi mới từ lesson
        quizService.deleteQuizQuestions(quizId); // Xóa các câu hỏi cũ trong quiz

        // Lấy câu hỏi mới từ lesson đã chọn
        List<Question> questions = quizService.getQuestionsByLessonId(lessonId);
        List<Question> randomQuestions = getRandomQuestions(questions, numOfQuestions);

        // Thêm các câu hỏi mới vào quiz
        for (Question question : randomQuestions) {
            quizService.addQuizQuestion(quizId, user.getId(), question.getId());
        }

        request.getSession().setAttribute("message", "Quiz updated successfully");
        response.sendRedirect("my_quiz");
    }

    @Override
    public String getServletInfo() {
        return "Quiz Update Controller";
    }

    // Hàm này lấy ra số lượng câu hỏi ngẫu nhiên từ danh sách câu hỏi
    private List<Question> getRandomQuestions(List<Question> questions, int numOfQuestions) {
        Collections.shuffle(questions); // Xáo trộn danh sách câu hỏi
        return questions.subList(0, Math.min(numOfQuestions, questions.size())); // Lấy số câu hỏi ngẫu nhiên
    }

}
