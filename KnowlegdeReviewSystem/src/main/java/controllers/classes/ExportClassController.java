package controllers.classes;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Class;
import models.Setting;
import models.SettingType;
import models.Subject;
import models.User;
import models.dao.ClassDAO;
import models.dao.SettingDAO;
import models.dao.SubjectDAO;
import models.dao.UserDAO;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * @author Admin
 */
@WebServlet(name = "ExportClassController", urlPatterns = {"/class_management/export"})
public class ExportClassController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ExportClassController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ExportClassController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=Class_Data.xlsx");

        Workbook workbook = new XSSFWorkbook(); // Tạo workbook Excel mới
        ClassDAO classDAO = new ClassDAO();
        SettingDAO settingDAO = new SettingDAO();
        SubjectDAO subjectDAO = new SubjectDAO();
        UserDAO userDAO = new UserDAO();

        // Lấy tất cả các học kỳ từ cơ sở dữ liệu
        List<Setting> semesters = settingDAO.findAllBySemester();

        // Lấy danh sách môn học, người quản lý, và domain
        Map<Integer, String> subjectMap = subjectDAO.findAll().stream()
                .collect(Collectors.toMap(Subject::getId, Subject::getCode));
        Map<Integer, String> managerMap = userDAO.findAll().stream()
                .collect(Collectors.toMap(User::getId, User::getUsername));
        Map<Integer, String> domainMap = settingDAO.findAllByType(SettingType.Category).stream()
                .collect(Collectors.toMap(Setting::getId, Setting::getTitle));

        // Tạo một sheet cho từng học kỳ
        for (Setting semester : semesters) {
            Sheet sheet = workbook.createSheet(semester.getTitle());  // Tạo sheet cho học kỳ
            createSheetHeader(sheet);  // Tạo header cho sheet

            // Lọc các lớp học thuộc học kỳ hiện tại
            List<models.Class> classes = classDAO.findBySemesterId(semester.getId());

            // Thêm danh sách lớp vào sheet tương ứng
            int rowNum = 1;
            for (Class cls : classes) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(cls.getCode());
                row.createCell(1).setCellValue(cls.getClassName());
                row.createCell(2).setCellValue(domainMap.getOrDefault(classDAO.getDomainIdBySubjectId(cls.getSubjectId()), "Unknown Domain"));
                row.createCell(3).setCellValue(subjectMap.getOrDefault(cls.getSubjectId(), "Unknown Subject"));
                row.createCell(4).setCellValue(managerMap.getOrDefault(cls.getManagerId(), "Unknown Manager"));
                row.createCell(5).setCellValue(cls.getStatus().name());  // Trả về dạng text của Enum
            }
        }

        // Xuất dữ liệu Excel ra response
        ServletOutputStream outputStream = response.getOutputStream();
        workbook.write(outputStream);  // Ghi file Excel vào luồng output
        workbook.close();  // Đóng workbook
        outputStream.close();  // Đóng output stream
    }

    // Tạo header cho mỗi sheet
    private void createSheetHeader(Sheet sheet) {
        Row headerRow = sheet.createRow(0);  // Tạo dòng đầu tiên cho header
        String[] columns = {"Class Code", "Class Name", "Domain", "Subject", "Manager", "Status"};

        // Tạo các cột trong header
        for (int i = 0; i < columns.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(columns[i]);
            cell.setCellStyle(getHeaderCellStyle(sheet.getWorkbook()));  // Thêm style cho header
        }
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
