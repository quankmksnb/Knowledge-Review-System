package controllers.user;

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
import models.Setting;
import models.SettingType;
import models.User;
import models.dao.SettingDAO;
import models.dao.UserDAO;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import services.dataaccess.SettingService;
import services.dataaccess.UserService;

/**
 * @author Admin
 */
@WebServlet(name = "ExportUserController", urlPatterns = {"/user/export"})
public class ExportUserController extends HttpServlet {
    private final UserService userService = new UserService();
    private final SettingService settingService = new SettingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=User_Data.xlsx");   // set tên file tải xuống là User_Data

        Workbook workbook = new XSSFWorkbook(); // workbook là tệp trong excel
        Sheet sheet = workbook.createSheet("List User");    // tạo sheet trong excel tên là List User
        Row headerRow = sheet.createRow(0); // dòng đầu tiên

        String[] columns = {"ID", "Full Name", "Username", "Email", "Role", "Status"};
        for (int i = 0; i < columns.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(columns[i]);  // set cho hàng đầu tiên với các cột từ 0 để set value
            cell.setCellStyle(getHeaderCellStyle(workbook)); // Hàm giúp in đậm dòng đầu
        }

        List<User> userListAll = userService.findAll();
        List<Setting> roles = settingService.findAllByType(SettingType.Role);

        // Ánh xạ roleId -> roleName
        Map<Integer, String> roleMap = roles.stream()
                .collect(Collectors.toMap(Setting::getId, Setting::getTitle));

        int rowNum = 1;
        for (User user : userListAll) {
            Row row = sheet.createRow(rowNum);  // từ cột thứ 2 sau cột header
            row.createCell(0).setCellValue(user.getId());
            row.createCell(1).setCellValue(user.getFullName());
            row.createCell(2).setCellValue(user.getUsername());
            row.createCell(3).setCellValue(user.getEmail());
            row.createCell(4).setCellValue(roleMap.getOrDefault(user.getRoleId(), "Unknown")); // Lấy tên Role
            row.createCell(5).setCellValue(user.getStatus().name()); // Trả về dạng text từ Enum

            rowNum++;
        }

        ServletOutputStream outputStream = response.getOutputStream();
        workbook.write(outputStream);   //  Ghi toàn bộ dữ liệu file Excel vào luồng phản hồi.
        workbook.close();   // Đóng workbook để giải phóng tài nguyên.
        outputStream.close();   //  Đóng luồng xuất dữ liệu.
    }

    // function hỗ trợ làm in đậm
    private CellStyle getHeaderCellStyle(Workbook workbook) {
        CellStyle headerCellStyle = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true); // font chữ Bold
        headerCellStyle.setFont(font);
        return headerCellStyle;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
