package controllers.question;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.*;
import models.dao.DTOSubject;
import services.dataaccess.*;

import java.io.IOException;
import java.util.*;

@WebServlet(name = "Question", value = "/question")
public class QuestionController extends HttpServlet {
    private QuestionService questionService = new QuestionService();
    private SubjectService subjectService = new SubjectService();
    private LessonService lessonService = new LessonService();
    private QuestionConfigService questionConfigService = new QuestionConfigService();
    private AnswerOptionService answerOptionService = new AnswerOptionService();
    private ConfigService configService = new ConfigService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        if (user == null || (user.getRoleId() != 1 && user.getRoleId() != 5)) {
            request.getRequestDispatcher("WEB-INF/Web/error.jsp").forward(request, response);
        }
        String action = request.getParameter("action");
        if (action == null && request.getParameter("page") != null) {
            action = "list";
        }

        if (action == null) {
            action = "choose";
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
            case "filter":
                filterQuestions(request, response);
                break;
            case "choose":
                chooseSubject(request, response);
                break;
            case "changeStatus":
                changeStatus(request, response);
                break;
            default:
                listQuestions(request, response);
                break;
        }
    }

    private void changeStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String statusParam = request.getParameter("status");
        System.out.println(statusParam);

        int id = Integer.parseInt(idParam);
        String status = statusParam.equals("active") ? "inactive" : "active";
        questionService.changeStatus(id, status);

        request.getSession().setAttribute("successMessage", "Question status changed successfully!");
        response.sendRedirect("question?action=list");
    }

    private void chooseSubject(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (request.getParameter("subjectId") == null) {
            String search = request.getParameter("subjectName");
            String domain = request.getParameter("domain");
            List<DTOSubject> list = subjectService.findAlls(search, domain);
            Map<Integer, String> domainMap = subjectService.getDomains();
            request.setAttribute("map", domainMap);
            request.setAttribute("list", list);
            request.getRequestDispatcher("WEB-INF/QuestionManagement/listactivesubject.jsp").forward(request, response);
        } else {
            int id = Integer.parseInt(request.getParameter("subjectId"));
            session.setAttribute("subjectId", id);
            response.sendRedirect("question?action=list");
        }
    }

    private void listQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int subjectId = (Integer) session.getAttribute("subjectId");
        String subjectName = subjectService.getSubjectNameById(subjectId);

        List<DTOConfig> configs = configService.findDomainBySubjectId(subjectId);
        List<Question> questions = questionService.findBySubjectId(subjectId);
        List<Lesson> lessons = lessonService.findAllLessonsInSubject(subjectId);

        if (request.getParameter("lessonId") != null) {
            if (!request.getParameter("lessonId").equals("all")) {
                questions = questionService.findByLessonId(Integer.parseInt(request.getParameter("lessonId")));
            }
        }
        else if (request.getParameter("content") != null) {
            questions = questionService.findByQuestionContent(request.getParameter("content"));
        }

        request.setAttribute("subjectName", subjectName);
        request.setAttribute("configs", configs);
        request.setAttribute("questions", questions);
        request.setAttribute("lessons", lessons);

        request.getRequestDispatcher("WEB-INF/QuestionManagement/listquestion.jsp").forward(request, response);
    }

    private void filterQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String lessonId = request.getParameter("lessonId");
        response.sendRedirect("question?action=list&lessonId="+ lessonId);
    }

    private void createQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int subjectId = (Integer) session.getAttribute("subjectId");

        if (request.getParameter("submit") == null) {
            List<Lesson> lessons = lessonService.findAllLessonsInSubject(subjectId);
            List<DTOConfig> configs = configService.findDomainBySubjectId(subjectId);
            String subjectName = subjectService.getSubjectNameById(subjectId);

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
                    question.setLessonId(lessonId);
                    question.setContent(content);
                    question.setStatus("Active");
                    int questionId = questionService.create(question);

                    String[] answers = request.getParameterValues("answers[]");
                    String[] correctAnswersIndices = request.getParameterValues("correctAnswers[]");
                    String configId = request.getParameter("configId");

                    questionConfigService.create(questionId, Integer.parseInt(configId));

                    List<AnswerOption> answerList = new ArrayList<>();
                    Set<String> correctIndicesSet = new HashSet<>(Arrays.asList(correctAnswersIndices));

                    for (int i = 0; i < answers.length; i++) {
                        String answerContent = answers[i];
                        boolean isCorrect = correctIndicesSet.contains(String.valueOf(i));

                        AnswerOption answer = new AnswerOption(0, questionId, answerContent, isCorrect);
                        answerList.add(answer);
                    }

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
        HttpSession session = request.getSession();
        int subjectId = (Integer) session.getAttribute("subjectId");

        try {
            String submit = request.getParameter("submit");
            if (submit == null) {
                Question question = questionService.findById(Integer.parseInt(request.getParameter("id")));
                List<AnswerOption> answers = answerOptionService.findAnswersByQuestionId(question.getId());
                List<Lesson> lessons = lessonService.findAll();
                List<DTOConfig> configs = configService.findDomainBySubjectId(subjectId);

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
                String[] answers = request.getParameterValues("answers[]");
                String[] correctAnswersIndices = request.getParameterValues("correctAnswers[]");
                Question question = new Question(id, subjectId, lessonId, content, "Active", "Chapter");
                List<AnswerOption> answerList = new ArrayList<>();
                Set<String> correctIndicesSet = new HashSet<>(Arrays.asList(correctAnswersIndices));

                for (int i = 0; i < answers.length; i++) {
                    String answerContent = answers[i];
                    boolean isCorrect = correctIndicesSet.contains(String.valueOf(i));

                    AnswerOption answer = new AnswerOption(0, question.getId(), answerContent, isCorrect);
                    answerList.add(answer);
                }
                questionConfigService.deleteByQuestionId(id);
                questionConfigService.create(id, Integer.parseInt(configId));

                questionService.update(question);

                session.setAttribute("successMessage", "Question updated successfully!");
                session.setAttribute("answers", answerList);
                response.sendRedirect("answer?action=update&questionId=" + question.getId());
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

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        processRequest(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        processRequest(request, response);
    }

    public void doPut(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
    }
}