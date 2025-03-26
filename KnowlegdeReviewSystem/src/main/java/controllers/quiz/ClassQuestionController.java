package controllers.quiz;

import com.google.gson.Gson;
import controllers.HomeServlet;
import controllers.WebManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.AnswerOption;
import models.Question;
import models.Subject;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet(name = "ClassQuestionController", urlPatterns = {"/quiz-questions", "/take-quiz", "/take-exam"})
public class ClassQuestionController extends HttpServlet {

    Logger LOGGER = Logger.getLogger(ClassQuestionController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        LOGGER.info(path);

        switch (path) {
            case "/quiz-questions":
                getQuizQuestions(request, response);
                break;

            case "/take-quiz":
                request.getRequestDispatcher("WEB-INF/Web/takeQuiz.jsp").forward(request, response);
                break;

            case "/take-exam":
                request.getRequestDispatcher("WEB-INF/Web/takeExam.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Optionally handle POST requests (e.g., for submitting quiz answers)
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        response.getWriter().write("{\"error\": \"POST method not supported\"}");
    }

    private void getQuizQuestions(HttpServletRequest request, HttpServletResponse response) throws IOException {
// Set the response content type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Get the lesson_id parameter from the request
        String lessonIdParam = request.getParameter("lesson_id");
        if (lessonIdParam == null || lessonIdParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"lesson_id parameter is required\"}");
            return;
        }

        int lessonId;
        try {
            lessonId = Integer.parseInt(lessonIdParam);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid lesson_id format\"}");
            return;
        }

        try {
            // Fetch questions and their answer options using QuestionDAO
            List<Question> questions = WebManager.getInstance().getQuestionDAO().findByLessonId(lessonId);

            // Convert the questions to JSON
            JSONArray questionsArray = new JSONArray();
            for (Question question : questions) {
                JSONObject questionObj = new JSONObject();
                questionObj.put("id", question.getId());
                questionObj.put("content", question.getContent());

                // Add answer options
                JSONArray optionsArray = new JSONArray();
                for (AnswerOption option : question.getOptions()) {
                    JSONObject optionObj = new JSONObject();
                    optionObj.put("id", option.getId());
                    optionObj.put("content", option.getContent());
                    optionObj.put("is_answer", option.isAnswer());
                    optionsArray.put(optionObj);
                }
                questionObj.put("options", optionsArray);

                questionsArray.put(questionObj);
            }

            // Write the JSON response
            response.getWriter().write(questionsArray.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Error fetching questions: " + e.getMessage() + "\"}");
        }
    }

    private void takeQuiz(HttpServletRequest request, HttpServletResponse response) throws IOException {

    }
}
