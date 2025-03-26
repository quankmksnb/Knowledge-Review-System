package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Lesson;
import models.Subject;
import models.Term;
import models.User;
import models.dao.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;
import java.util.Map;

@WebServlet(name = "Card", value = "/card")
public class CardController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String action = request.getParameter("action");
            if (action == null) {
                action = "list";
            }

            switch (action) {
                case "list":
                    listCard(request, response);
                    break;
                case "add":
                    addCard(request, response);
                    break;
                case "user":
                    listCardOfUser(request, response);
                case "delete":
                    deleteCard(request, response);
                    break;
                case "filter":
                    filterCard(request, response);
                    break;
                case "choose":
                    chooseSubject(request, response);
                    break;
                default:
                    chooseSubject(request, response);
                    break;
            }
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
            request.getRequestDispatcher("WEB-INF/CardManagement/listsubjectcard.jsp").forward(request, response);
        }
        else {
            HttpSession session = request.getSession();

            int id = Integer.parseInt(request.getParameter("subjectId"));
            session.setAttribute("subjectId", id);

            response.sendRedirect("card?action=list");
        }
    }
    private void listCard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int subjectId = (Integer) session.getAttribute("subjectId");
        TermDAO termDAO = new TermDAO();
        List<Term> terms = termDAO.getTermsBySubjectId(subjectId);
        if (request.getParameter("lessonId") != null) {
            terms = termDAO.getTermsByLessonId(Integer.parseInt(request.getParameter("lessonId")));
        }
        LessonDAO lessonDAO = new LessonDAO();
        List<Lesson> lessons = lessonDAO.findAllLessonsInSubject(subjectId);
        request.setAttribute("lessons", lessons);
        request.setAttribute("terms", terms);
        request.getRequestDispatcher("WEB-INF/CardManagement/listcard.jsp").forward(request, response);
    }
    private void addCard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        CardDAO cardDAO = new CardDAO();
        TermDAO termDAO = new TermDAO();
        if (user == null) {
            response.sendRedirect("login");
        }
        else {
            int userId = user.getId();
            int termId = Integer.parseInt(request.getParameter("termId"));
            cardDAO.add(userId, termId);
            response.sendRedirect("card?action=list");
        }
    }

    private void filterCard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
    private void listCardOfUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        TermDAO termDAO = new TermDAO();
        if (user == null) {
            response.sendRedirect("login");
        }

        else{
            int userId = user.getId();
            SubjectDAO subjectDAO = new SubjectDAO();
            String sql = "SELECT subject.id, subject.code, setting.title, subject.name, " +
                    "subject.description, subject.modified_at, subject.status " +
                    "FROM subject " +
                    "INNER JOIN setting ON subject.domain_id = setting.id " +
                    "WHERE setting.type = 'Category'";
            List<Term> terms = termDAO.getTermsByUserId(userId);
            if (request.getParameter("lessonId") != null) {
                terms = termDAO.getTermsByUserIdBySubjectId(Integer.parseInt(request.getParameter("lessonId")), userId);
            }
            List<DTOSubject> subjects = subjectDAO.findAlls(sql);
            LessonDAO lessonDAO = new LessonDAO();
            List<Lesson> lessons = lessonDAO.findAll();
            request.setAttribute("lessons", lessons);
            request.setAttribute("subjects", subjects);
            request.setAttribute("terms", terms);
            request.getRequestDispatcher("WEB-INF/CardManagement/mycard.jsp").forward(request, response);
        }
    }

    private void deleteCard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int termId = Integer.parseInt(request.getParameter("termId"));
        CardDAO cardDAO = new CardDAO();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        cardDAO.delete(user.getId(), termId);
        response.sendRedirect("card?action=user");
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

