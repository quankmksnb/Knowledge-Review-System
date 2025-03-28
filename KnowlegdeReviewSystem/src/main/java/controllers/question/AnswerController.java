package controllers.question;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.AnswerOption;
import models.User;
import services.dataaccess.AnswerOptionService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "Answer", value = "/answer")
public class AnswerController extends HttpServlet {
    private AnswerOptionService answerOptionService = new AnswerOptionService();



    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        if (user == null || (user.getRoleId() != 1 && user.getRoleId() != 5)) {
            request.getRequestDispatcher("WEB-INF/Web/error.jsp").forward(request, response);
        }
        switch (action) {
            case "view":
                viewAnswers(request, response);
                break;
            case "addAnswer":
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
    }

    private void addAnswer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<AnswerOption> answers = (List<AnswerOption>) session.getAttribute("newAnswers");

        if (answers != null && !answers.isEmpty()) {
            try {
                for (AnswerOption answer : answers) {
                    answerOptionService.create(answer);
                }
                session.removeAttribute("newAnswers");
                session.setAttribute("successMessage", "Question created successfully!");
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error adding answers: " + e.getMessage());
            }
        }
        response.sendRedirect("question?action=list");
    }

    private void updateAnswer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<AnswerOption> answers = (List<AnswerOption>) session.getAttribute("answers");
        int questionId = Integer.parseInt(request.getParameter("questionId"));
        answerOptionService.deleteByQuestionId(questionId);
        System.out.println(answers.size());
        if (answers != null && !answers.isEmpty()) {
            try {
                for (AnswerOption answer : answers) {
                    int affect = answerOptionService.create(answer);
                    System.out.println(affect);
                }
                session.removeAttribute("answers");
                session.setAttribute("successMessage", "Question updated successfully!");
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error updating answers: " + e.getMessage());
            }
        }
        response.sendRedirect("question?action=list");
    }

    private void deleteAnswer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            AnswerOption answer = answerOptionService.findById(id);

            if (answer != null) {
                answerOptionService.delete(answer);
                request.setAttribute("successMessage", "Answer deleted successfully!");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error deleting answer: " + e.getMessage());
        }

        response.sendRedirect("answer");
    }

    private void addMultipleAnswers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            int count = Integer.parseInt(request.getParameter("count"));

            for (int i = 1; i <= count; i++) {
                String content = request.getParameter("content" + i);
                boolean isCorrect = "true".equals(request.getParameter("isCorrect" + i));

                if (content != null && !content.trim().isEmpty()) {
                    AnswerOption answer = new AnswerOption(0, questionId, content, isCorrect);
                    answerOptionService.create(answer);
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