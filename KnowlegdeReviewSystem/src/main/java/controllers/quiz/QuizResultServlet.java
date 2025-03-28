package controllers.quiz;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.*;
import models.dao.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/quiz_result")
public class QuizResultServlet extends HttpServlet {
    private QuizDAO quizDAO;
    private models.dao.QuizQuestionDAO quizQuestionDAO;
    private QuestionDAO questionDAO;
    private QuizResultDAO quizResultDAO;
    private QuizAnswerDAO quizAnswerDAO;

    @Override
    public void init() throws ServletException {
        quizDAO = new QuizDAO();
        quizQuestionDAO = new models.dao.QuizQuestionDAO();
        questionDAO = new QuestionDAO();
        quizResultDAO = new QuizResultDAO();
        quizAnswerDAO = new QuizAnswerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int quizId;
        try {
            quizId = Integer.parseInt(request.getParameter("quizId"));
        } catch (NumberFormatException e) {
            response.sendRedirect("/my_quiz");
            return;
        }

        User user = (User) request.getSession(false).getAttribute("user");
        if (user == null) {
            response.sendRedirect("/login");
            return;
        }
        int userId = user.getId();

        // Fetch the quiz
        Quiz quiz = quizDAO.findById(quizId);
        if (quiz == null || quiz.getStatus() != QuizStatus.Completed) {
            response.sendRedirect("/my_quiz");
            return;
        }

        // Fetch the quiz result
        QuizResult quizResult = quizResultDAO.findByQuizIdAndUserId(quizId, userId);
        if (quizResult == null) {
            response.sendRedirect("/my_quiz");
            return;
        }

        // Fetch the quiz questions
        List<QuizQuestion> quizQuestions = quizQuestionDAO.findByQuizId(quizId);
        List<Integer> questionIds = quizQuestions.stream()
                .map(QuizQuestion::getQuestionId)
                .collect(Collectors.toList());

        // Fetch all questions in one query (optimization)
        Map<Integer, Question> questionMap = questionDAO.findByIds(questionIds);

        // Fetch the user's answers and handle null values
        List<QuizAnswer> quizAnswers = quizAnswerDAO.findByQuizIdAndUserId(quizId, userId);
        int correctAnswer = 0;
        for (QuizAnswer quizAnswer : quizAnswers) {
            if(quizAnswer.isCorrect()) ++correctAnswer;
        }
//
//        // Prepare the question reviews
//        List<QuestionReview> questionReviews = new ArrayList<>();
//        for (QuizQuestion quizQuestion : quizQuestions) {
//            int questionId = quizQuestion.getQuestionId();
//            Question question = questionMap.get(questionId);
//            if (question == null) {
//                continue;
//            }
//
//            // Get options and check for null
//            List<AnswerOption> options = question.getOptions();
//            if (options == null) {
//                continue;
//            }
//
//            // Find the correct answer
//            AnswerOption correctAnswer = options.stream()
//                    .filter(AnswerOption::isAnswer)
//                    .findFirst()
//                    .orElse(null);
//
//            // Find the user's answer
//            Integer answerOptionId = userAnswerMap.getOrDefault(questionId, null);
//            AnswerOption userAnswer = null;
//            if (answerOptionId != null && answerOptionId != 0) {
//                userAnswer = options.stream()
//                        .filter(option -> option.getId() == answerOptionId)
//                        .findFirst()
//                        .orElse(null);
//            }
//
//            // Create a QuestionReview object
//            QuestionReview review = new QuestionReview(question, userAnswer, correctAnswer);
//            questionReviews.add(review);
//        }

//        System.out.println(questionReviews.size());

        // Set attributes for the JSP
        request.setAttribute("quiz", quiz);
        request.setAttribute("quizResult", quizResult);
        request.setAttribute("totalQuestion", questionMap.size());
        request.setAttribute("correctAnswer", correctAnswer);
        request.setAttribute("wrongAnswer", questionMap.size() - correctAnswer);
//        request.setAttribute("questionReviews", questionReviews);

        // Forward to the result page
        request.getRequestDispatcher("/WEB-INF/Quiz/quizResult.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}