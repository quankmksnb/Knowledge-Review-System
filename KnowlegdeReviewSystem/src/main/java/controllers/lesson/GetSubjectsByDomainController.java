package controllers.subject;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Subject;
import models.dao.SubjectDAO;

/**
 * @author Admin
 */
@WebServlet(name = "GetSubjectsByDomainController", urlPatterns = {"/getSubjectsByDomain"})
public class GetSubjectsByDomainController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String domainIdStr = request.getParameter("domainId");
        SubjectDAO subjectDAO = new SubjectDAO();

        List<Subject> subjects;
        if (domainIdStr == null || domainIdStr.isEmpty()) {
            subjects = subjectDAO.findAll(); // Lấy tất cả nếu không có domain
        } else {
            int domainId = Integer.parseInt(domainIdStr);
            subjects = subjectDAO.findByDomain(domainId);
        }

        PrintWriter out = response.getWriter();
        for (Subject subject : subjects) {
            out.println("<option value='" + subject.getId() + "' data-domain='" + subject.getDomainId() + "'>" + subject.getCode() + "</option>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}


