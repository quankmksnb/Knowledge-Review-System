package controllers.quiz;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.*;
import models.dao.QuestionDAO;
import models.dao.QuizDAO;
import models.dao.QuizResultDAO;
import models.dao.QuizAnswerDAO; // Added import for QuizAnswerDAO

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/take_quiz")
public class TakeQuizServlet extends HttpServlet {
    private QuizDAO quizDAO;
    private models.dao.QuizQuestionDAO quizQuestionDAO;
    private QuestionDAO questionDAO;
    private QuizResultDAO quizResultDAO;
    private QuizAnswerDAO quizAnswerDAO; // Added QuizAnswerDAO

    @Override
    public void init() throws ServletException {
        quizDAO = new QuizDAO();
        quizQuestionDAO = new models.dao.QuizQuestionDAO();
        questionDAO = new QuestionDAO();
        quizResultDAO = new QuizResultDAO();
        quizAnswerDAO = new QuizAnswerDAO(); // Initialize QuizAnswerDAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int quizId = Integer.parseInt(request.getParameter("quizId"));
        User user = (User) request.getSession(false).getAttribute("user");
        int userId = user.getId();
        Quiz quiz = quizDAO.findById(quizId);

        if (quiz == null || quiz.getStatus() != QuizStatus.Unfinished) {
            response.sendRedirect("/my_quiz");
            return;
        }

        List<Question> lstQuestions = new ArrayList<>();
        List<QuizQuestion> quizQuestions = quizQuestionDAO.findByQuizId(quizId);
        for (QuizQuestion quizQuestion : quizQuestions) {
            Question question = questionDAO.findById(quizQuestion.getQuestionId());
            lstQuestions.add(question);
        }

        request.setAttribute("quiz", quiz);
        request.setAttribute("quizQuestions", lstQuestions);
        request.setAttribute("userId", userId);
        request.getRequestDispatcher("WEB-INF/Quiz/takeQuiz.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int quizId = Integer.parseInt(request.getParameter("quizId"));
        int userId = Integer.parseInt(request.getParameter("userId"));

        // Fetch quiz questions
        List<QuizQuestion> quizQuestions = quizQuestionDAO.findByQuizId(quizId);

        // Variables for grade calculation
        int totalQuestions = quizQuestions.size();
        int correctAnswers = 0;

        // Process each question and save answers
        for (QuizQuestion quizQuestion : quizQuestions) {
            int questionId = quizQuestion.getQuestionId();
            String selectedAnswerIdStr = request.getParameter("answer_" + questionId);
            Integer answerOptionId = null; // Use Integer to allow null for unanswered questions
            boolean isCorrect = false;

            if (selectedAnswerIdStr != null) {
                answerOptionId = Integer.parseInt(selectedAnswerIdStr);
                Question question = questionDAO.findById(questionId);
                AnswerOption correctAnswer = question.getOptions().stream()
                        .filter(AnswerOption::isAnswer)
                        .findFirst()
                        .orElse(null);
                if (correctAnswer != null && correctAnswer.getId() == answerOptionId) {
                    isCorrect = true;
                    correctAnswers++;
                }
            }

            QuizAnswer quizAnswer = new QuizAnswer(quizId, userId, questionId, answerOptionId, isCorrect);
            quizAnswerDAO.create(quizAnswer);
        }

        // Calculate grade
        double grade = (double) correctAnswers / totalQuestions * 10;

        // Save quiz result
        QuizResult quizResult = new QuizResult();
        quizResult.setQuizId(quizId);
        quizResult.setUserId(userId);
        quizResult.setGrade(grade);
        quizResultDAO.create(quizResult);

        // Update quiz status
        Quiz quiz = quizDAO.findById(quizId);
        quiz.setStatus(QuizStatus.Completed);
        quizDAO.update(quiz);

        // Set attributes for result page
        request.setAttribute("quiz", quiz);
        request.setAttribute("quizResult", quizResult);

        // Forward to result page
        response.sendRedirect("/quiz_result?quizId=" + quizId);
    }
}