package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Lesson;
import models.Question;
import models.Subject;
import models.dao.LessonDAO;
import models.dao.QuestionDAO;
import models.dao.SubjectDAO;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "Question", value = "/question")
public class QuestionController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listQuestions(request, response);
                break;
            case "create":
                createQuestion(request, response);
                break;
            case "update":
                updateQuestion(request, response);
                break;
            case "delete":
                deleteQuestion(request, response);
                break;
            case "filter":
                filterQuestions(request, response);
                break;
            case "answer":
                answer(request, response);
                break;
            default:
                listQuestions(request, response);
                break;
        }
    }

    private void answer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        QuestionDAO questionDAO = new QuestionDAO();
        HttpSession session = request.getSession();
        Question question = questionDAO.findById(Integer.parseInt(request.getParameter("id")));
        session.setAttribute("question", question);
        response.sendRedirect("answer");
    }

    private void listQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        QuestionDAO questionDAO = new QuestionDAO();
        SubjectDAO subjectDAO = new SubjectDAO();
        LessonDAO lessonDAO = new LessonDAO();

        List<Question> questions = questionDAO.findAll();
        List<Subject> subjects = subjectDAO.findAll();
        List<Lesson> lessons = lessonDAO.findAll();

        request.setAttribute("questions", questions);
        request.setAttribute("subjects", subjects);
        request.setAttribute("lessons", lessons);

        request.getRequestDispatcher("WEB-INF/QuestionManagement/listquestion.jsp").forward(request, response);
    }

    private void filterQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int subjectId = 0;
        int lessonId = 0;
        QuestionDAO questionDAO = new QuestionDAO();
        SubjectDAO subjectDAO = new SubjectDAO();
        LessonDAO lessonDAO = new LessonDAO();
        List<Question> questions;

        try {
            if (request.getParameter("subjectId") != null && !request.getParameter("subjectId").isEmpty()) {
                subjectId = Integer.parseInt(request.getParameter("subjectId"));
            }

            if (request.getParameter("lessonId") != null && !request.getParameter("lessonId").isEmpty()) {
                lessonId = Integer.parseInt(request.getParameter("lessonId"));
            }

            if (subjectId > 0 && lessonId > 0) {
                // Filter by both subject and lesson
                questions = questionDAO.findByLessonId(lessonId);
            } else if (subjectId > 0) {
                // Filter by subject only
                questions = questionDAO.findBySubjectId(subjectId);
            } else {
                // No filter or invalid filter
                questions = questionDAO.findAll();
            }
        } catch (NumberFormatException e) {
            questions = questionDAO.findAll();
        }

        List<Subject> subjects = subjectDAO.findAll();
        List<Lesson> lessons = lessonDAO.findAll();

        request.setAttribute("questions", questions);
        request.setAttribute("subjects", subjects);
        request.setAttribute("lessons", lessons);
        request.setAttribute("selectedSubjectId", subjectId);
        request.setAttribute("selectedLessonId", lessonId);

        request.getRequestDispatcher("WEB-INF/QuestionManagement/listquestion.jsp").forward(request, response);
    }

    private void createQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        QuestionDAO questionDAO = new QuestionDAO();

        try {
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            String content = request.getParameter("content");

            if (content != null && !content.trim().isEmpty()) {
                Question question = new Question();
                question.setSubjectId(subjectId);
                question.setLessonid(lessonId); // Using questionId as lessonId based on the model
                question.setContent(content);

                questionDAO.create(question);
                request.setAttribute("successMessage", "Question created successfully!");
            } else {
                request.setAttribute("errorMessage", "Question content cannot be empty!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid subject or lesson selection!");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error creating question: " + e.getMessage());
        }

        // Redirect back to question list
        listQuestions(request, response);
    }

    private void updateQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        QuestionDAO questionDAO = new QuestionDAO();

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            String content = request.getParameter("content");

            if (content != null && !content.trim().isEmpty()) {
                Question question = new Question();
                question.setId(id);
                question.setSubjectId(subjectId);
                question.setLessonid(lessonId); // Using questionId as lessonId based on the model
                question.setContent(content);

                questionDAO.update(question);
                request.setAttribute("successMessage", "Question updated successfully!");
            } else {
                request.setAttribute("errorMessage", "Question content cannot be empty!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid question, subject, or lesson selection!");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error updating question: " + e.getMessage());
        }

        // Redirect back to question list
        listQuestions(request, response);
    }

    private void deleteQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        QuestionDAO questionDAO = new QuestionDAO();

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Question question = questionDAO.findById(id);

            if (question != null) {
                questionDAO.delete(question);
                request.setAttribute("successMessage", "Question deleted successfully!");
            } else {
                request.setAttribute("errorMessage", "Question not found!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid question ID!");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error deleting question: " + e.getMessage());
        }
    }


public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
    processRequest(request, response);
}

public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
    processRequest(request, response);
}

public void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {

}


}

