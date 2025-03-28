package controllers.class_student;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Class;
import models.User;
import models.dao.ClassDAO;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import services.dataaccess.ClassService;

/**
 * @author Admin
 */
@WebServlet(name = "ExportStudentOfClassController", urlPatterns = {"/exportStudents"})
public class ExportStudentOfClassController extends HttpServlet {
    private final ClassService classService = new ClassService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ExportStudentOfClassController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ExportStudentOfClassController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy classId từ request
        int classId = Integer.parseInt(request.getParameter("classId"));

        // Lấy danh sách học sinh đã được phê duyệt từ ClassDAO
        Class cls = classService.findById(classId);
        List<User> approvedStudents = classService.getApprovedStudents(classId);

        // Thiết lập kiểu nội dung và tên file Excel
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=Class " + cls.getClassName() + ".xlsx");

        // Tạo Workbook và Sheet mới
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Students");

        // Tạo dòng tiêu đề
        Row headerRow = sheet.createRow(0);
        String[] columns = {"ID", "Full Name", "Email"};
        for (int i = 0; i < columns.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(columns[i]);
            cell.setCellStyle(getHeaderCellStyle(workbook));  // Hàm giúp in đậm dòng đầu
        }

        // Thêm dữ liệu sinh viên vào file Excel
        int rowNum = 1;
        for (User student : approvedStudents) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(student.getId());
            row.createCell(1).setCellValue(student.getFullName());
            row.createCell(2).setCellValue(student.getEmail());
        }

        // Ghi nội dung Excel vào response OutputStream
        ServletOutputStream outputStream = response.getOutputStream();
        workbook.write(outputStream);
        workbook.close();
        outputStream.close();
    }

    // Hàm hỗ trợ tạo style cho header (in đậm)
    private CellStyle getHeaderCellStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        style.setFont(font);
        return style;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
