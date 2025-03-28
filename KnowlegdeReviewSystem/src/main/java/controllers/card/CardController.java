package controllers.card;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Lesson;
import models.Term;
import models.User;
import models.dao.DTOSubject;
import services.dataaccess.CardService;
import services.dataaccess.LessonService;
import services.dataaccess.SubjectService;
import services.dataaccess.TermService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "Card", value = "/card")
public class CardController extends HttpServlet {

    private CardService cardService = new CardService();
    private TermService termService = new TermService();
    private LessonService lessonService = new LessonService();
    private SubjectService subjectService = new SubjectService();



    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        if (user == null ||  user.getRoleId() != 3) {
            request.getRequestDispatcher("WEB-INF/Web/error.jsp").forward(request, response);
        }
        if (action == null && request.getParameter("page") != null) {
            action = "list";
        }

        if (action == null) {
            action = "choose";
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
                break;
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

    private void chooseSubject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getParameter("subjectId") == null) {
            String search = request.getParameter("subjectName");
            String domain = request.getParameter("domain");
            List<DTOSubject> list = subjectService.findAlls(search, domain);
            Map<Integer, String> domainMap = subjectService.getDomains();
            request.setAttribute("map", domainMap);
            request.setAttribute("list", list);
            request.getRequestDispatcher("WEB-INF/CardManagement/listsubjectcard.jsp").forward(request, response);
        } else {
            HttpSession session = request.getSession();
            int id = Integer.parseInt(request.getParameter("subjectId"));
            session.setAttribute("subjectId", id);
            response.sendRedirect("card?action=list");
        }
    }

    private void listCard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int subjectId = (Integer) session.getAttribute("subjectId");
        List<Term> terms = termService.getTermsBySubjectId(subjectId);
        if (request.getParameter("lessonId") != null) {
            terms = termService.getTermsByLessonId(Integer.parseInt(request.getParameter("lessonId")));
        } else if (request.getParameter("content") != null) {
            terms = termService.getTermsByContent(subjectId, request.getParameter("content"));
        }
        List<Lesson> lessons = lessonService.findAllLessonsInSubject(subjectId);
        request.setAttribute("lessons", lessons);
        request.setAttribute("terms", terms);
        request.getRequestDispatcher("WEB-INF/CardManagement/listcard.jsp").forward(request, response);
    }

    private void addCard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
        } else {
            int userId = user.getId();
            int termId = Integer.parseInt(request.getParameter("termId"));
            cardService.add(userId, termId);
            response.sendRedirect("card?action=list&status=success");
        }
    }

    private void filterCard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    private void listCardOfUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
        } else {
            int userId = user.getId();
            List<Term> terms = termService.getTermsByUserId(userId);
            if (request.getParameter("lessonId") != null) {
                terms = termService.getTermsByUserIdBySubjectId(Integer.parseInt(request.getParameter("lessonId")), userId);
            } else if (request.getParameter("content") != null) {
                terms = termService.getTermsByUserIdByContent(userId, request.getParameter("content"));
            }
            List<DTOSubject> subjects = subjectService.findAlls(null, null); // Lấy danh sách subject
            List<Lesson> lessons = lessonService.findAll();
            request.setAttribute("lessons", lessons);
            request.setAttribute("subjects", subjects);
            request.setAttribute("terms", terms);
            request.getRequestDispatcher("WEB-INF/CardManagement/mycard.jsp").forward(request, response);
        }
    }

    private void deleteCard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int termId = Integer.parseInt(request.getParameter("termId"));
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        cardService.delete(user.getId(), termId);
        response.sendRedirect("card?action=user&status=success");
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