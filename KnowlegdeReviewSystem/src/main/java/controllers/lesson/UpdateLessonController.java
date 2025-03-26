package controllers.lesson;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Config;
import models.Lesson;
import models.dao.ConfigDAO;
import models.dao.LessonDAO;

/**
 * @author Admin
 */
@WebServlet(name = "UpdateLessonController", urlPatterns = {"/update_lesson"})
public class UpdateLessonController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateLessonController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateLessonController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("id"));

            // Get Lesson data
            LessonDAO lessonDAO = new LessonDAO();
            Lesson lesson = lessonDAO.getLessonById(lessonId);

            // Get list of Chapters for the subject
            int subjectId = lesson.getSubjectId();
            ConfigDAO configDAO = new ConfigDAO();
            List<Config> chapterList = configDAO.getChaptersBySubject(subjectId);

            // Get current chapter ID for the lesson
            int currentChapterId = configDAO.getChapterIdByLessonId(lessonId);

            // Set attributes
            request.setAttribute("lesson", lesson);
            request.setAttribute("chapterList", chapterList);
            request.setAttribute("currentChapterId", currentChapterId);

            // Forward to JSP
            request.getRequestDispatcher("WEB-INF/SubjectManagement/updateLesson.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid lesson ID");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int chapterId = Integer.parseInt(request.getParameter("chapterId"));

            LessonDAO lessonDAO = new LessonDAO();
            boolean success = lessonDAO.updateLessonWithChapter(lessonId,  lessonDAO.getLessonById(lessonId).getSubjectId(), title, description, chapterId);

            if (success) {
                response.sendRedirect("lesson_list?subjectId=" + lessonDAO.getLessonById(lessonId).getSubjectId());
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating lesson");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error while updating lesson");
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
