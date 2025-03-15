package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Answer;
import models.Question;
import models.dao.AnswerDAO;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "Answer", value = "/answer")
public class AnswerController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        switch (action) {
            case "view":
                viewAnswers(request, response);
                break;
            case "add":
                addAnswer(request, response);
                break;
            case "update":
                updateAnswer(request, response);
                break;
            case "delete":
                deleteAnswer(request, response);
                break;
            case "addMultiple":
                addMultipleAnswers(request, response);
                break;
            default:
                viewAnswers(request, response);
                break;
        }
    }

    private void viewAnswers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Question question = (Question) session.getAttribute("question");

        if (question != null) {
            AnswerDAO answerDAO = new AnswerDAO();
            List<Answer> answers = answerDAO.findAnswersByQuestionId(question.getId());

            request.setAttribute("question", question);
            request.setAttribute("answers", answers);
        }

        request.getRequestDispatcher("WEB-INF/QuestionManagement/answer.jsp").forward(request, response);
    }

    private void addAnswer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AnswerDAO answerDAO = new AnswerDAO();

        try {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            String content = request.getParameter("content");
            boolean isCorrect = "true".equals(request.getParameter("isCorrect"));

            Answer answer = new Answer(0, questionId, content, isCorrect);
            answerDAO.create(answer);

            request.setAttribute("successMessage", "Answer added successfully!");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error adding answer: " + e.getMessage());
        }

        response.sendRedirect("answer");
    }

    private void updateAnswer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AnswerDAO answerDAO = new AnswerDAO();

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            String content = request.getParameter("content");
            boolean isCorrect = "true".equals(request.getParameter("isCorrect"));

            Answer answer = new Answer(id, questionId, content, isCorrect);
            answerDAO.update(answer);

            request.setAttribute("successMessage", "Answer updated successfully!");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error updating answer: " + e.getMessage());
        }

        response.sendRedirect("answer");
    }

    private void deleteAnswer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AnswerDAO answerDAO = new AnswerDAO();

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Answer answer = answerDAO.findById(id);

            if (answer != null) {
                answerDAO.delete(answer);
                request.setAttribute("successMessage", "Answer deleted successfully!");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error deleting answer: " + e.getMessage());
        }

        response.sendRedirect("answer");
    }

    private void addMultipleAnswers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AnswerDAO answerDAO = new AnswerDAO();

        try {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            int count = Integer.parseInt(request.getParameter("count"));

            for (int i = 1; i <= count; i++) {
                String content = request.getParameter("content" + i);
                boolean isCorrect = "true".equals(request.getParameter("isCorrect" + i));

                if (content != null && !content.trim().isEmpty()) {
                    Answer answer = new Answer(0, questionId, content, isCorrect);
                    answerDAO.create(answer);
                }
            }

            request.setAttribute("successMessage", "Answers added successfully!");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error adding answers: " + e.getMessage());
        }

        response.sendRedirect("answer");
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        processRequest(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        processRequest(request, response);
    }
}