package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Lesson;
import models.Subject;
import models.dao.DTOSubject;
import models.dao.LessonDAO;
import models.dao.SubjectDAO;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet(name = "Subject", value = "/subject")
public class SubjectController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String action = request.getParameter("action");

            System.out.println(action);

            SubjectDAO dao = new SubjectDAO();
            if (action == null) {
                String sql = "SELECT subject.id, subject.code, setting.title, subject.name, " +
                        "subject.description, subject.modified_at, subject.status " +
                        "FROM subject " +
                        "INNER JOIN setting ON subject.domain_id = setting.id " +
                        "WHERE setting.type = 'Category'";
                if (request.getParameter("search") != null) {
                    sql = "SELECT subject.id, subject.code, setting.title, subject.name, " +
                            "subject.description, subject.modified_at, subject.status " +
                            "FROM subject " +
                            "INNER JOIN setting ON subject.domain_id = setting.id " +
                            "WHERE setting.type = 'Category' and subject.name LIKE '%"+ request.getParameter("search") +"%'";
                }
                if (request.getParameter("domain") != null && !request.getParameter("domain").equals("all")) {
                    sql = "SELECT subject.id, subject.code, setting.title, subject.name, " +
                            "subject.description, subject.modified_at, subject.status " +
                            "FROM subject " +
                            "INNER JOIN setting ON subject.domain_id = setting.id " +
                            "WHERE setting.type = 'Category' and subject.domain_id = "+ request.getParameter("domain") ;
                }
                List<DTOSubject> subjects = dao.findAlls(sql);
                if (request.getParameter("status") != null) {
                    request.setAttribute("status", request.getParameter("status"));
                }
                Map<Integer, String> map = dao.getDomains();
                request.setAttribute("map", map);
                request.setAttribute("size", subjects.size());
                request.setAttribute("subjects", subjects);
//                System.out.println(subjects.size());
                request.getRequestDispatcher("WEB-INF/SubjectManagement/listsubject.jsp").forward(request, response);
            }
            else{
                if (action.equals("create")) {

                    Subject subject = new Subject();
                    subject.setSubjectName(request.getParameter("name"));
                    subject.setCode(request.getParameter("code"));
                    subject.setDescription(request.getParameter("description"));
                    subject.setDomainId(Integer.parseInt(request.getParameter("domain")));
                    subject.setCategoryId(5);
                    subject.setStatus((request.getParameter("status").equals("Active")) ? true : false);
                    dao.create(subject);

                    response.sendRedirect("subject?status=success");

                }
                if (action.equals("update")) {
                    if (request.getParameter("submit") == null){
                        int id = Integer.parseInt(request.getParameter("id"));
                        Map<Integer, String> map = dao.getDomains();
                        request.setAttribute("map", map);
                        request.setAttribute("subject", dao.findById(id));
                        HttpSession session = request.getSession();
                        session.setAttribute("subject", dao.findById(id));
                        session.setAttribute("subject", dao.findById(id));
                        request.getRequestDispatcher("WEB-INF/SubjectManagement/updatesubject.jsp").forward(request, response);
                    }
                    else {
                        Subject subject = new Subject();
                        subject.setId(Integer.parseInt(request.getParameter("id")));
                        subject.setSubjectName(request.getParameter("name"));
                        subject.setCode(request.getParameter("code"));
                        subject.setDescription(request.getParameter("description"));
                        subject.setDomainId(Integer.parseInt(request.getParameter("domain")));
//                        subject.setManagerId(2);
//                        subject.setCategoryId(4);
//                        subject.setModifiedBy(1);
                        subject.setModifiedAt(new Date(System.currentTimeMillis()));
                        subject.setStatus((request.getParameter("status").equals("Active")) ? true : false);
                        dao.update(subject);
                        dao.save(subject, "modified");
                        response.sendRedirect("subject?status=success");
                    }
                }
                if (action.equals("delete")) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Subject subject = dao.findById(id);
                    dao.delete(subject);
                    response.sendRedirect("subject?status=success");
                }
                if(action.equals("changeStatus")) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Subject subject = dao.findById(id);
                    if (subject.isStatus()) {
                        dao.save(subject, "inactive");
                    }
                    else {
                        dao.save(subject, "active");
                    }
                    dao.changeStatus(subject);

                    response.sendRedirect("subject?status=success");
                }
                if(action.equals("getLesson")) {
                    LessonDAO lessonDAO = new LessonDAO();
                    SubjectDAO subjectDAO = new SubjectDAO();
                    int id = Integer.parseInt(request.getParameter("id"));
                    List<Lesson> lessons = lessonDAO.findAllLessonsInSubject(id);
                    request.setAttribute("lessons", lessons);
                    request.setAttribute("subject", subjectDAO.findAll());
                    request.getRequestDispatcher("WEB-INF/SubjectManagement/getlesson.jsp").forward(request, response);
                }
            }
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

