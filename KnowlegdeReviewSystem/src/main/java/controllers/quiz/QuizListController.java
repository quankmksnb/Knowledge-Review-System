package controllers.quiz;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

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
@WebServlet(name = "QuizListController", urlPatterns = {"/my_quiz"})
public class QuizListController extends HttpServlet {

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


        // Lấy danh sách subject mà user đã enroll vào
        List<Subject> enrolledSubjects = classService.getEnrolledSubjectsByUserId(user.getId());

        // Lấy danh sách subject_id từ các subject đã enroll
        List<Integer> enrolledSubjectIds = new ArrayList<>();
        for (Subject subject : enrolledSubjects) {
            enrolledSubjectIds.add(subject.getId());
        }

        // Lấy danh sách bài học từ các subject mà user đã enroll vào
        List<Lesson> lessons = lessonService.getLessonsByEnrolledSubjects(enrolledSubjectIds);

        // Map quizId → lesson.title
        Map<Integer, String> quizLessonTitleMap = new HashMap<>();
        List<Quiz> quizList = quizService.findByUserId(user.getId());

        // Pagination setup
        int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        int itemsPerPage = 6;  // Số quiz mỗi trang
        int totalItems = quizList.size();
        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
        int startIndex = (currentPage - 1) * itemsPerPage;
        int endIndex = Math.min(startIndex + itemsPerPage, totalItems);

        // Lấy danh sách quiz cho trang hiện tại
        List<Quiz> paginatedQuizList = quizList.subList(startIndex, endIndex);

        for (Quiz quiz : paginatedQuizList) {
            String lessonTitle = lessonService.getLessonTitleByQuizId(quiz.getId());
            quizLessonTitleMap.put(quiz.getId(), lessonTitle);
        }

        // Lấy dữ liệu cho dropdown (các subject đã enroll vào)
        List<Lesson> lessonList = lessonService.findAll();

        // Gửi về JSP
        request.setAttribute("quizList", paginatedQuizList);
        request.setAttribute("quizLessonTitleMap", quizLessonTitleMap);
        request.setAttribute("enrolledSubjects", enrolledSubjects); // Thêm danh sách subjects đã enroll
        request.setAttribute("lessons", lessons); // Thêm danh sách bài học
        request.setAttribute("lessonList", lessonList);
        request.setAttribute("currentPage", currentPage); // Truyền currentPage về JSP
        request.setAttribute("totalPages", totalPages);  // Truyền totalPages về JSP

        request.getRequestDispatcher("WEB-INF/Quiz/quizList.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createQuiz(request, response, user);
        } else {
            response.sendRedirect("my_quiz");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private List<Question> getRandomQuestions(List<Question> questions, int numOfQuestions) {
        Collections.shuffle(questions); // Xáo trộn danh sách câu hỏi
        return questions.subList(0, Math.min(numOfQuestions, questions.size()));  // Lấy số câu hỏi ngẫu nhiên
    }

    private void createQuiz(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        int subjectId = Integer.parseInt(request.getParameter("subject"));
        int userId = user.getId();
        int numOfQuestions = Integer.parseInt(request.getParameter("numOfQuestions"));
        int lessonId = Integer.parseInt(request.getParameter("lesson"));
        String quizName = request.getParameter("quizName");

        // Tạo quiz mới
        Quiz newQuiz = new Quiz();
        newQuiz.setSubjectId(subjectId);
        newQuiz.setUserId(userId);
        newQuiz.setNumOfQuestions(numOfQuestions);
        newQuiz.setStatus(QuizStatus.Unfinished);
        newQuiz.setQuizName(quizName);
        int quizId = quizService.create(newQuiz);  // Lấy quizId vừa tạo

        // Liên kết với bài học
        quizService.addQuizLesson(quizId, lessonId);

        // Lấy câu hỏi từ lesson
        List<Question> questions = quizService.getQuestionsByLessonId(lessonId);
        List<Question> randomQuestions = getRandomQuestions(questions, numOfQuestions);

        // Thêm câu hỏi vào quiz
        for (Question question : randomQuestions) {
            quizService.addQuizQuestion(quizId, user.getId(), question.getId());
        }

        request.getSession().setAttribute("message", "Quiz created successfully");
        response.sendRedirect("my_quiz");
    }


}
