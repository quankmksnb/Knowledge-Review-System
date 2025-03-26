package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.*;
import models.dao.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

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
            case "choose":
                chooseSubject(request, response);
                break;
            default:
                chooseSubject(request, response);
                break;
        }
    }

    private void chooseSubject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getParameter("subjectId") == null) {


            SubjectDAO subjectDAO = new SubjectDAO();
            String sql = "SELECT subject.id, subject.code, setting.title, subject.name, " +
                    "subject.description, subject.modified_at, subject.status " +
                    "FROM subject " +
                    "INNER JOIN setting ON subject.domain_id = setting.id " +
                    "WHERE setting.type = 'Category'";
            List<DTOSubject> list = subjectDAO.findAlls(sql);
            request.setAttribute("list", list);
            request.getRequestDispatcher("WEB-INF/QuestionManagement/listactivesubject.jsp").forward(request, response);
        }
        else {
            HttpSession session = request.getSession();

            int id = Integer.parseInt(request.getParameter("subjectId"));
            session.setAttribute("subjectId", id);

            response.sendRedirect("question?action=list");
        }
    }

    private void listQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LessonDAO lessonDAO = new LessonDAO();
        ConfigDAO configDAO = new ConfigDAO();
        SubjectDAO subjectDAO = new SubjectDAO();
        HttpSession session = request.getSession();
        int subjectId = (Integer) session.getAttribute("subjectId");
        String subjectName = subjectDAO.getSubjectNameById(subjectId);

        List<DTOConfig> configs = configDAO.findDomainBySubjectId(subjectId);
        List<Question> questions = WebManager.getInstance().getQuestionDAO().findBySubjectId(subjectId);
        List<Lesson> lessons = lessonDAO.findAllLessonsInSubject(subjectId);
        request.setAttribute("subjectName", subjectName);
        request.setAttribute("configs", configs);
        request.setAttribute("questions", questions);
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
        SubjectDAO subjectDAO = new SubjectDAO();
        ConfigDAO configDAO = new ConfigDAO();
        QuestionConfigDAO questionConfigDAO = new QuestionConfigDAO();
        HttpSession session = request.getSession();
        int subjectId = (Integer) session.getAttribute("subjectId");
        LessonDAO lessonDAO = new LessonDAO();
        if (request.getParameter("submit") == null) {
            List<Lesson> lessons = lessonDAO.findAllLessonsInSubject(subjectId);
            List<DTOConfig> configs = configDAO.findDomainBySubjectId(subjectId);
            String subjectName = subjectDAO.getSubjectNameById(subjectId);
            request.setAttribute("subjectName", subjectName);
            request.setAttribute("configs", configs);
            request.setAttribute("lessons", lessons);
            request.getRequestDispatcher("WEB-INF/QuestionManagement/addquestion.jsp").forward(request, response);
        }
        else {
            try {

                int lessonId = Integer.parseInt(request.getParameter("lessonId"));
                String content = request.getParameter("content");

                if (content != null && !content.trim().isEmpty()) {
                    Question question = new Question();
                    question.setSubjectId(subjectId);
                    question.setLessonId(lessonId); // Using questionId as lessonId based on the model
                    question.setContent(content);
                    question.setStatus("Active");
                    int questionId = questionDAO.create(question);
                    String[] answers = request.getParameterValues("answers[]");
                    String[] correctAnswersIndices = request.getParameterValues("correctAnswers[]");
                    String configId = request.getParameter("configId");

                    questionConfigDAO.create(questionId, Integer.parseInt(configId));

                    List<AnswerOption> answerList = new ArrayList<>();
                    for (int i = 0; i < correctAnswersIndices.length; i++) {
                        System.out.println(correctAnswersIndices[i]);
                    }
                    Set<String> correctIndicesSet = new HashSet<>(Arrays.asList(correctAnswersIndices));

                    for (int i = 0; i < answers.length; i++) {
                        String answerContent = answers[i];
                        boolean isCorrect = correctIndicesSet.contains(String.valueOf(i));

                        AnswerOption answer = new AnswerOption(0, questionId, answerContent, isCorrect);
                        answerList.add(answer);
                    }
                    //HttpSession session = request.getSession();
                    session.setAttribute("successMessage", "Question created successfully!");
                    session.setAttribute("newAnswers", answerList);
                    response.sendRedirect("answer?action=addAnswer");
                    return;
                } else {
                    request.setAttribute("errorMessage", "Question content cannot be empty!");
                }

            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid subject or lesson selection!");
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error creating question: " + e.getMessage());
            }

            listQuestions(request, response);
        }

    }
    private void updateQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        QuestionDAO questionDAO = new QuestionDAO();
        ConfigDAO configDAO = new ConfigDAO();
        AnswerOptionDAO answerDAO = new AnswerOptionDAO();
        LessonDAO lessonDAO = new LessonDAO();
        QuestionConfigDAO questionConfigDAO = new QuestionConfigDAO();
        HttpSession session = request.getSession();
        int subjectId = (Integer) session.getAttribute("subjectId");
        try {
            String submit = request.getParameter("submit");
            if (submit == null) {
                Question question = questionDAO.findById(Integer.parseInt(request.getParameter("id")));
                List<AnswerOption> answers = answerDAO.findAnswersByQuestionId(question.getId());
                List<Lesson> lessons = lessonDAO.findAll();
                List<DTOConfig> configs = configDAO.findDomainBySubjectId(subjectId);
                request.setAttribute("configs", configs);
                request.setAttribute("question", question);
                request.setAttribute("answers", answers);
                request.setAttribute("lessons", lessons);
                request.getRequestDispatcher("WEB-INF/QuestionManagement/questiondetail.jsp").forward(request, response);
            }
            else {
                int id = Integer.parseInt(request.getParameter("id"));
                int lessonId = Integer.parseInt(request.getParameter("lessonId"));
                String content = request.getParameter("content");
                String configId = request.getParameter("configId");
                Question question = new Question(id, subjectId, lessonId, content, "Active", "Chapter");
                questionConfigDAO.deleteByQuestionId(id);
                questionConfigDAO.create(id, Integer.parseInt(configId));
                questionDAO.update(question);
                List<AnswerOption> answers = answerDAO.findAnswersByQuestionId(question.getId());
                session.setAttribute("successMessage", "Question created successfully!");
                session.setAttribute("answers", answers);
                response.sendRedirect("answer?action=update");
                return;
            }
            request.setAttribute("successMessage", "Question updated successfully!");
            listQuestions(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input. Please check your data.");
            listQuestions(request, response);
        }
        catch (Exception e) {
            request.setAttribute("errorMessage", "Error updating question: " + e.getMessage());
            listQuestions(request, response);
        }
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

