package controllers.term;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.DTOConfig;
import models.Lesson;
import models.Term;
import models.User;
import services.dataaccess.ConfigService;
import services.dataaccess.LessonService;
import services.dataaccess.SubjectService;
import services.dataaccess.TermService;
import services.dataaccess.TermDomainService;
import java.io.IOException;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import models.dao.DTOSubject;

@WebServlet(name = "Term", value = "/term")
public class TermController extends HttpServlet {
    private TermService termService = new TermService();
    private SubjectService subjectService = new SubjectService();
    private LessonService lessonService = new LessonService();
    private ConfigService configService = new ConfigService();
    private TermDomainService termDomainService = new TermDomainService();



    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        if (user == null || (user.getRoleId() != 1 && user.getRoleId() != 5)) {
            request.getRequestDispatcher("WEB-INF/Web/error.jsp").forward(request, response);
        }
        switch (action) {
            case "list":
                listTerm(request, response);
                break;
            case "add":
                addTerm(request, response);
                break;
            case "update":
                updateTerm(request, response);
                break;
            case "changeStatus":
                changeStatus(request, response);
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
            String search = request.getParameter("subjectName");
            String domain = request.getParameter("domain");
            List<DTOSubject> list = subjectService.findAlls(search, domain);
            Map<Integer, String> domainMap = subjectService.getDomains();
            request.setAttribute("map", domainMap);
            request.setAttribute("list", list);
            request.getRequestDispatcher("WEB-INF/TermManagement/listsubjectterm.jsp").forward(request, response);
        } else {
            HttpSession session = request.getSession();
            int id = Integer.parseInt(request.getParameter("subjectId"));
            session.setAttribute("subjectId", id);
            response.sendRedirect("term?action=list");
        }
    }

    private void listTerm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int subjectId = (Integer) session.getAttribute("subjectId");

        List<Term> terms;
        if (request.getParameter("lessonId") != null) {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            terms = termService.getTermsByLessonId(lessonId);
        } else if (request.getParameter("search") != null) {
            terms = termService.getTermsByContent(subjectId, request.getParameter("search"));
        } else {
            terms = termService.getTermsBySubjectId(subjectId);
        }

        List<Lesson> lessons = lessonService.findAllLessonsInSubject(subjectId);
        Hashtable<Integer, String> termDomainConfigMap = termService.getTermDomainConfigHashtable();
        List<DTOConfig> configs = configService.findDomainBySubjectId(subjectId);

        request.setAttribute("configs", configs);
        request.setAttribute("termDomainConfigMap", termDomainConfigMap);
        request.setAttribute("lessons", lessons);
        request.setAttribute("terms", terms);
        request.getRequestDispatcher("WEB-INF/TermManagement/listterm.jsp").forward(request, response);
    }

    private void addTerm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String status = request.getParameter("status");
            int configId = Integer.parseInt(request.getParameter("configId"));

            Term newTerm = new Term(0, lessonId, title, content, status);
            int termId = termService.createTerm(newTerm);

            if (termId != -1) {
                termDomainService.deleteByTermId(termId);
                termDomainService.addTermDomain(termId, configId);
                session.setAttribute("successMessage", "Term created successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to create term.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid input data.");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
        }

        response.sendRedirect("term?action=list&status=success");
    }

    private void updateTerm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (request.getParameter("submit") == null) {
            int id = Integer.parseInt(request.getParameter("id"));
            Term term = termService.getTermsByTermId(id);
            int subjectId = (Integer) session.getAttribute("subjectId");
            List<DTOConfig> configs = configService.findDomainBySubjectId(subjectId);

            request.setAttribute("term", term);
            request.setAttribute("configs", configs);
            request.getRequestDispatcher("WEB-INF/TermManagement/updateterm.jsp").forward(request, response);
        } else {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                int lessonId = Integer.parseInt(request.getParameter("lessonId"));
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                String status = request.getParameter("status");
                int configId = Integer.parseInt(request.getParameter("configId"));

                Term updatedTerm = new Term(id, lessonId, title, content, status);
                int result = termService.updateTerm(updatedTerm);

                if (result > 0) {
                    termDomainService.deleteByTermId(id);
                    termDomainService.addTermDomain(id, configId);
                    session.setAttribute("successMessage", "Term updated successfully!");
                } else {
                    session.setAttribute("errorMessage", "Failed to update term.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid input data.");
            } catch (Exception e) {
                session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            }

            response.sendRedirect("term?action=list&status=success");
        }
    }

    private void changeStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String status = request.getParameter("status");
        int id = Integer.parseInt(request.getParameter("id"));

        if (status != null) {
            if (status.equals("Active")) {
                termService.changeTermStatus(id, "Inactive");
            } else {
                termService.changeTermStatus(id, "Active");
            }
        }
        response.sendRedirect("term?action=list&status=success");
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        processRequest(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        processRequest(request, response);
    }

    public void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Not implemented
    }
}