package controllers.subject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Subject;
import models.User;
import models.dao.DTOSubject;
import services.dataaccess.SubjectService;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

@WebServlet(name = "Subject", value = "/subject")
public class SubjectController extends HttpServlet {
    private SubjectService subjectService = new SubjectService();


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || (user.getRoleId() != 1 && user.getRoleId() != 5)) {
            request.getRequestDispatcher("WEB-INF/Web/error.jsp").forward(request, response);
        }
        String action = request.getParameter("action");
        System.out.println(action);

        if (action == null) {
            list(request, response);
        } else {
            switch (action) {
                case "create":
                    create(request, response);
                    break;
                case "update":
                    update(request, response);
                    break;
                case "delete":
                    delete(request, response);
                    break;
                case "changeStatus":
                    changeStatus(request, response);
                    break;

                default:
                    list(request, response);
            }
        }
    }

    private void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String domain = request.getParameter("domain");
        String status = request.getParameter("status");

        List<DTOSubject> subjects = subjectService.findAlls(search, domain);

        Map<Integer, String> domainMap = subjectService.getDomains();

        request.setAttribute("map", domainMap);
        request.setAttribute("size", subjects.size());
        request.setAttribute("subjects", subjects);

        if (status != null) {
            request.setAttribute("status", status);
        }

        request.getRequestDispatcher("WEB-INF/SubjectManagement/listsubject.jsp").forward(request, response);
    }

    private void create(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Subject subject = new Subject();
        subject.setSubjectName(request.getParameter("name"));
        subject.setCode(request.getParameter("code"));
        subject.setDescription(request.getParameter("description"));
        subject.setDomainId(Integer.parseInt(request.getParameter("domain")));
        subject.setCategoryId(5);
        subject.setStatus(request.getParameter("status").equals("Active"));

        subjectService.create(subject);
        response.sendRedirect("subject?status=success");
    }

    private void update(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getParameter("submit") == null) {
            int id = Integer.parseInt(request.getParameter("id"));

            Map<Integer, String> domainMap = subjectService.getDomains();
            Subject subject = subjectService.findById(id);

            request.setAttribute("map", domainMap);
            request.setAttribute("subject", subject);

            HttpSession session = request.getSession();
            session.setAttribute("subject", subject);

            request.getRequestDispatcher("WEB-INF/SubjectManagement/updatesubject.jsp").forward(request, response);
        } else {
            Subject subject = new Subject();
            subject.setId(Integer.parseInt(request.getParameter("id")));
            subject.setSubjectName(request.getParameter("name"));
            subject.setCode(request.getParameter("code"));
            subject.setDescription(request.getParameter("description"));
            subject.setDomainId(Integer.parseInt(request.getParameter("domain")));
            subject.setModifiedAt(new Date(System.currentTimeMillis()));
            subject.setStatus(request.getParameter("status").equals("Active"));

            subjectService.update(subject);
            subjectService.save(subject, "modified");

            response.sendRedirect("subject?status=success");
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Subject subject = subjectService.findById(id);
        subjectService.delete(subject);
        response.sendRedirect("subject?status=success");
    }

    private void changeStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Subject subject = subjectService.findById(id);

        subjectService.save(subject, subject.isStatus() ? "inactive" : "active");
        subjectService.changeStatus(subject);

        response.sendRedirect("subject?status=success");
    }



    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        processRequest(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        processRequest(request, response);
    }
}