package controllers.class_student;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Class;
import models.User;
import models.dao.ClassDAO;
import models.dao.UserDAO;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * @author Admin
 */
@WebServlet(name = "ClassStudentDetailController", urlPatterns = {"/class_student_detail"})
@MultipartConfig
public class ClassStudentDetailController extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int classId = Integer.parseInt(request.getParameter("classId"));

        ClassDAO classDAO = new ClassDAO();
        Class clazz = classDAO.findById(classId);
        List<User> approvedStudents = classDAO.getApprovedStudents(classId);
        List<User> unapprovedStudents = classDAO.getUnapprovedStudents(classId);

        request.setAttribute("oldClassId", classId);
        request.setAttribute("clazz", clazz);
        request.setAttribute("approvedStudents", approvedStudents);
        request.setAttribute("pendingStudents", unapprovedStudents);

        request.getRequestDispatcher("WEB-INF/ClassStudent/classStudentDetail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String classIdStr = request.getParameter("classId");
        HttpSession session = request.getSession();

        if (classIdStr == null || classIdStr.isEmpty()) {
            session.setAttribute("messageError", "Class ID is missing!");
            response.sendRedirect("class_student_detail");
            return;
        }

        int classId = Integer.parseInt(classIdStr);
        ClassDAO classDAO = new ClassDAO();
        UserDAO userDAO = new UserDAO();

        if ("addStudent".equals(action)) {
            // Thêm sinh viên bằng email nhập thủ công
            String emailInput = request.getParameter("email");
            User student = userDAO.findByEmail(emailInput);

            if (student != null) {
                boolean success = classDAO.addStudentToClass(classId, student.getId());
                session.setAttribute("message", success ? "Student added successfully!" : "Student is already in this class.");
            } else {
                session.setAttribute("messageError", "Student email not found!");
            }

        } else if ("importStudents".equals(action)) {
            // Import sinh viên từ file Excel
            Part filePart = request.getPart("file");

            if (filePart == null || filePart.getSize() == 0) {
                session.setAttribute("messageError", "No file uploaded!");
                response.sendRedirect("class_student_detail?classId=" + classId);
                return;
            }

            List<String> importedEmails = new ArrayList<>();
            try (InputStream fileContent = filePart.getInputStream();
                 Workbook workbook = new XSSFWorkbook(fileContent)) {

                Sheet sheet = workbook.getSheetAt(0);
                for (Row row : sheet) {
                    if (row.getRowNum() == 0) continue; // Bỏ qua tiêu đề

                    String emailExcel = "";
                    if (row.getCell(0) != null) {
                        emailExcel = row.getCell(0).getStringCellValue().trim();
                    }

                    if (!emailExcel.isEmpty() && !importedEmails.contains(emailExcel)) {
                        importedEmails.add(emailExcel);
                    }
                }

                int addedCount = 0;
                for (String emailExcel : importedEmails) {
                    User student = userDAO.findByEmail(emailExcel);
                    if (student != null) {
                        boolean added = classDAO.addStudentToClass(classId, student.getId());
                        if (added) addedCount++;
                    }
                }

                session.setAttribute("message", addedCount + " students imported successfully!");

            } catch (Exception e) {
                session.setAttribute("messageError", "Error reading file! Make sure it's a valid Excel file.");
                e.printStackTrace();
            }
        }

        response.sendRedirect("class_student_detail?classId=" + classId);
    }




    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
