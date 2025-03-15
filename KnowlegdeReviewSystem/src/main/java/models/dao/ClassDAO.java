package models.dao;

import jakarta.servlet.http.HttpServletRequest;
import models.*;
import models.Class;
import models.ClassStatus;
import models.ClassStudentStatus;
import models.DAO;
import services.DatabaseConnector;

import javax.xml.crypto.Data;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ClassDAO implements DAO<Class> {
    //region DAO
    //TODO: Implement logic for DAO

    Connection connection = DatabaseConnector.getConnection();
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    @Override
    public void create(Class aClass) {
        PreparedStatement ps = null;

        try {
            String sql = "INSERT INTO krsdb.class (code, class_name, subject_id, manager_id, semester_id, created_at, status) " +
                    "VALUES (?, ?, ?, ?, ?, now(), ?)";

            ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, aClass.getCode());
            ps.setString(2, aClass.getClassName());
            ps.setInt(3, aClass.getSubjectId());
            ps.setInt(4, aClass.getManagerId());
            ps.setInt(5, aClass.getSemesterId());
            ps.setString(6, aClass.getStatus().name()); // Lưu Enum dưới dạng chuỗi ("Public" hoặc "Private")

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        aClass.setId(generatedKeys.getInt(1)); // Lấy ID mới tạo
                    }
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error while creating new class", ex);
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error while closing PreparedStatement", ex);
            }
        }
    }

    @Override
    public void update(Class aClass) {
        PreparedStatement ps = null;
        try {
            String sql = "UPDATE krsdb.class " +
                    "SET class_name = ?, " +
                    "code = ?, " +
                    "subject_id = ?, " +
                    "manager_id = ?, " +
                    "status = ?, " +
                    "modified_at = NOW() " +
                    "WHERE id = ?";

            ps = connection.prepareStatement(sql);

            // Set các tham số từ đối tượng Class
            ps.setString(1, aClass.getClassName());
            ps.setString(2, aClass.getCode());
            ps.setInt(3, aClass.getSubjectId());
            ps.setInt(4, aClass.getManagerId());
            ps.setString(5, aClass.getStatus().toString());
            ps.setInt(6, aClass.getId());

            ps.executeUpdate();  // Thực hiện cập nhật vào cơ sở dữ liệu
            System.out.println("thành công");

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating class", ex);
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing prepared statement", ex);
            }
        }
    }

    @Override
    public void delete(Class aClass) {
        String sql = "DELETE FROM krsdb.class WHERE id = ?";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, aClass.getId());
            ps.executeUpdate();

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting class", ex);
        }
    }

    @Override
    public Class findById(int id) {

        PreparedStatement ps = null;
        ResultSet rs = null;
        Class aClass = null;

        try {
            String sql = "SELECT * FROM krsdb.class WHERE id = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                aClass = new Class();
                aClass.setId(rs.getInt("id"));
                aClass.setSubjectId(rs.getInt("subject_id"));
                aClass.setManagerId(rs.getInt("manager_id"));
                aClass.setSemesterId(rs.getInt("semester_id"));
                aClass.setClassName(rs.getString("class_name"));
                aClass.setCode(rs.getString("code"));
                aClass.setCreatedBy(rs.getInt("created_by"));
                aClass.setModifiedBy(rs.getInt("modified_by"));
                aClass.setCreatedAt(rs.getTimestamp("created_at"));
                aClass.setModifiedAt(rs.getTimestamp("modified_at"));
                aClass.setStatus(ClassStatus.valueOf(rs.getString("status")));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, null, ex);
            }
        }

        return aClass;
    }

    @Override
    public List<Class> findAll() {
        List<Class> classList = new ArrayList<>();
        String sql = "SELECT * FROM krsdb.class";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                classList.add(extractClassFromResultSet(rs));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching all classes", ex);
        }
        return classList;
    }

    private Class extractClassFromResultSet(ResultSet rs) throws SQLException {
        Class aClass = new Class();
        aClass.setId(rs.getInt("id"));
        aClass.setSubjectId(rs.getInt("subject_id"));
        aClass.setManagerId(rs.getInt("manager_id"));
        aClass.setClassName(rs.getString("class_name"));
        aClass.setCode(rs.getString("code"));
        aClass.setCreatedAt(rs.getTimestamp("created_at"));
        aClass.setStatus(ClassStatus.valueOf(rs.getString("status")));
        // New fields added to match the database
        aClass.setCreatedBy(rs.getInt("created_by"));
        aClass.setModifiedAt(rs.getTimestamp("modified_at"));
        aClass.setModifiedBy(rs.getInt("modified_by"));

        //LOGGER.info(aClass.toString());

        return aClass;
    }


    public List<Class> findClassesByStudentId(int studentId) {
        List<Class> classList = new ArrayList<>();
        String sql = "SELECT c.* FROM krsdb.class c " +
                "JOIN krsdb.class_student cs ON c.id = cs.class_id " +
                "WHERE cs.user_id = ?";  // Fixed column name

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                classList.add(extractClassFromResultSet(rs));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding classes by student ID", ex);
        }
        return classList;
    }

    public boolean isStudentInClass(int studentId, int classId) {
        String sql = "SELECT COUNT(*) FROM krsdb.class_student WHERE user_id = ? AND class_id = ?";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, classId);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking if student is in class", ex);
        }
        return false;
    }

    public ClassStudentStatus getStudentStatusInClass(int studentId, int classId) {
        String sql = "SELECT status FROM class_student WHERE user_id = ? AND class_id = ?";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, classId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return ClassStudentStatus.valueOf(rs.getString("status")); // Convert to ENUM
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking student's status in class", ex);
        }

        return null; // Return null if not found or error occurs
    }


    public void enrollStudent(int studentId, int classId) {
        String sql = "INSERT INTO class_student (class_id, user_id, status, modified_at) VALUES (?, ?, 'Unapproved', NOW())";

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, classId);
            stmt.setInt(2, studentId);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("Student enrolled successfully.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    public List<Class> searchClasses(String keyword, int limit) {
        List<Class> classList = new ArrayList<>();
        String sql = "SELECT * FROM krsdb.class WHERE class_name LIKE ? OR code LIKE ? LIMIT ?";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setInt(3, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                classList.add(extractClassFromResultSet(rs));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error searching for classes", ex);
        }

        return classList;
    }

    public List<Class> searchClasses(String searchQuery, Integer semesterId, Integer domainId, String status) {
        List<Class> classList = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT c.*, s.code AS subject_code, u.full_name AS manager_name, d.title AS domain_title " +
                    "FROM class c " +
                    "LEFT JOIN subject s ON c.subject_id = s.id " +
                    "LEFT JOIN user u ON c.manager_id = u.id " +
                    "LEFT JOIN setting d ON s.domain_id = d.id " +
                    "WHERE (? IS NULL OR c.semester_id = ?) " +  // Lọc theo Semester
                    "AND (? IS NULL OR s.domain_id = ?) " +  // Lọc theo Domain
                    "AND (? IS NULL OR c.status = ?) " +  // Lọc theo Status
                    "AND (? IS NULL OR c.code LIKE CONCAT('%', ?, '%') " +  // Lọc theo Code
                    "OR ? IS NULL OR s.code LIKE CONCAT('%', ?, '%') " +  // Lọc theo Subject
                    "OR ? IS NULL OR u.username LIKE CONCAT('%', ?, '%'))";  // Lọc theo Manager

            ps = connection.prepareStatement(sql);

            ps.setObject(1, semesterId);
            ps.setObject(2, semesterId);
            ps.setObject(3, domainId);
            ps.setObject(4, domainId);
            ps.setObject(5, status);
            ps.setObject(6, status);

            for (int i = 7; i <= 12; i++) {
                ps.setObject(i, searchQuery);
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                Class cls = new Class();
                cls.setId(rs.getInt("id"));
                cls.setCode(rs.getString("code"));
                cls.setClassName(rs.getString("class_name"));
                cls.setSubjectId(rs.getInt("subject_id"));
                cls.setManagerId(rs.getInt("manager_id"));
                cls.setSemesterId(rs.getInt("semester_id"));
                cls.setStatus(ClassStatus.valueOf(rs.getString("status")));

                classList.add(cls);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return classList;
    }

    public Integer getLatestSemesterId() {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Integer latestSemesterId = null;

        try {
            String sql = "SELECT id FROM krsdb.setting WHERE type = 'Semester' ORDER BY id DESC LIMIT 1";
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                latestSemesterId = rs.getInt("id");
            }
        } catch (SQLException ex) {
            Logger.getLogger(ClassDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException ex) {
                Logger.getLogger(ClassDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return latestSemesterId;
    }

    public List<User> getApprovedStudents(int classId) {
        List<User> studentsList = new ArrayList<>();
        Connection connection = DatabaseConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // SQL query lấy thông tin sinh viên đã được Approved
            String sql = "SELECT u.id AS user_id, u.full_name, u.email, u.avatar " +
                    "FROM class_student cs " +
                    "JOIN user u ON cs.user_id = u.id " +
                    "WHERE cs.class_id = ? AND cs.status = 'Approved'";

            ps = connection.prepareStatement(sql);
            ps.setInt(1, classId);
            rs = ps.executeQuery();

            while (rs.next()) {
                // Tạo đối tượng User và gán thông tin
                User student = new User();
                student.setId(rs.getInt("user_id"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setAvatar(rs.getString("avatar"));

                // Thêm sinh viên vào danh sách
                studentsList.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return studentsList;
    }

    public List<User> getUnapprovedStudents(int classId) {
        List<User> studentsList = new ArrayList<>();
        Connection connection = DatabaseConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // SQL query lấy thông tin sinh viên đã được Approved
            String sql = "SELECT u.id AS user_id, u.full_name, u.email, u.avatar " +
                    "FROM class_student cs " +
                    "JOIN user u ON cs.user_id = u.id " +
                    "WHERE cs.class_id = ? AND cs.status = 'Unapproved'";

            ps = connection.prepareStatement(sql);
            ps.setInt(1, classId);
            rs = ps.executeQuery();

            while (rs.next()) {
                // Tạo đối tượng User và gán thông tin
                User student = new User();
                student.setId(rs.getInt("user_id"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setAvatar(rs.getString("avatar"));

                // Thêm sinh viên vào danh sách
                studentsList.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return studentsList;
    }

    public List<Class> findBySemesterId(int semesterId) {
        List<Class> classList = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT * FROM class WHERE semester_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, semesterId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Class cls = new Class();
                cls.setId(rs.getInt("id"));
                cls.setCode(rs.getString("code"));
                cls.setClassName(rs.getString("class_name"));
                cls.setSubjectId(rs.getInt("subject_id"));
                cls.setManagerId(rs.getInt("manager_id"));
                cls.setSemesterId(rs.getInt("semester_id"));
                cls.setStatus(ClassStatus.valueOf(rs.getString("status")));
                classList.add(cls);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return classList;
    }

    // Thêm phương thức lấy domain_id từ subject_id
    public Integer getDomainIdBySubjectId(int subjectId) {
        Integer domainId = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT domain_id FROM subject WHERE id = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, subjectId);
            rs = ps.executeQuery();

            if (rs.next()) {
                domainId = rs.getInt("domain_id");  // Lấy domain_id từ subject
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return domainId;
    }

    public List<Class> findByManagerId(int managerId, int semesterId) {
        List<Class> classList = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT c.id, c.class_name, c.subject_id, c.manager_id, c.semester_id, c.status, c.code\n" +
                    "                    FROM class c \n" +
                    "                    WHERE c.manager_id = ? AND c.semester_id = ?";

            ps = connection.prepareStatement(sql);
            ps.setInt(1, managerId);
            ps.setInt(2, semesterId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Class cls = new Class();
                cls.setId(rs.getInt("id"));
                cls.setClassName(rs.getString("class_name"));
                cls.setSubjectId(rs.getInt("subject_id"));
                cls.setManagerId(rs.getInt("manager_id"));
                cls.setSemesterId(rs.getInt("semester_id"));
                cls.setStatus(ClassStatus.valueOf(rs.getString("status")));
                cls.setCode(rs.getString("code"));

                classList.add(cls);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return classList;
    }

    public boolean approveStudent(int classId, int studentId) {
        PreparedStatement ps = null;
        try {
            String sql = "UPDATE class_student SET status = 'Approved' WHERE class_id = ? AND user_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, classId);
            ps.setInt(2, studentId);
            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean rejectStudent(int classId, int studentId) {
        PreparedStatement ps = null;
        try {
            String sql = "DELETE FROM class_student WHERE class_id = ? AND user_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, classId);
            ps.setInt(2, studentId);
            int rowsDeleted = ps.executeUpdate();
            return rowsDeleted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean addStudentToClass(int classId, int studentId) {
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Kiểm tra xem sinh viên đã tồn tại trong lớp hay chưa
            String checkSql = "SELECT status FROM class_student WHERE class_id = ? AND user_id = ?";
            ps = connection.prepareStatement(checkSql);
            ps.setInt(1, classId);
            ps.setInt(2, studentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                String status = rs.getString("status");

                // Nếu sinh viên đã có trong lớp với trạng thái "Unapproved", cập nhật thành "Approved"
                if ("Unapproved".equalsIgnoreCase(status)) {
                    String updateSql = "UPDATE class_student SET status = 'Approved' WHERE class_id = ? AND user_id = ?";
                    ps = connection.prepareStatement(updateSql);
                    ps.setInt(1, classId);
                    ps.setInt(2, studentId);
                    int rowsUpdated = ps.executeUpdate();
                    return rowsUpdated > 0;  // Trả về true nếu cập nhật thành công
                } else {
                    return false; // Nếu đã được "Approved", không làm gì cả
                }
            }

            // Nếu sinh viên chưa có trong lớp, thêm vào class_student với trạng thái "Approved"
            String insertSql = "INSERT INTO class_student (class_id, user_id, status) VALUES (?, ?, 'Approved')";
            ps = connection.prepareStatement(insertSql);
            ps.setInt(1, classId);
            ps.setInt(2, studentId);
            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean isStudentApprovedInClass(int studentId, int classId) {
        String sql = "SELECT COUNT(*) FROM krsdb.class_student WHERE user_id = ? AND class_id = ? AND status = 'Approved'";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, classId);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;  // Trả về true nếu đã Approved

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking if student is Approved in class", ex);
        }
        return false;
    }

    public ClassStatus toggleClassStatus(int classId) {
        PreparedStatement getStatusStmt = null;
        PreparedStatement updateStatusStmt = null;
        ResultSet rs = null;
        ClassStatus newStatus = ClassStatus.Private; // Mặc định trạng thái là Private

        try {
            // Truy vấn để lấy trạng thái hiện tại của lớp học
            String getStatusQuery = "SELECT status FROM krsdb.class WHERE id = ?";
            getStatusStmt = connection.prepareStatement(getStatusQuery);
            getStatusStmt.setInt(1, classId);
            rs = getStatusStmt.executeQuery();

            if (rs.next()) {
                String currentStatus = rs.getString("status");

                // Xác định trạng thái mới dựa trên trạng thái hiện tại
                if ("Public".equalsIgnoreCase(currentStatus)) {
                    newStatus = ClassStatus.Private;
                } else if ("Private".equalsIgnoreCase(currentStatus)) {
                    newStatus = ClassStatus.Public;
                }

                // Cập nhật trạng thái mới vào cơ sở dữ liệu
                String updateStatusQuery = "UPDATE krsdb.class SET status = ?, modified_at = NOW() WHERE id = ?";
                updateStatusStmt = connection.prepareStatement(updateStatusQuery);
                updateStatusStmt.setString(1, newStatus.toString());
                updateStatusStmt.setInt(2, classId);
                updateStatusStmt.executeUpdate();
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating class status", ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (getStatusStmt != null) {
                    getStatusStmt.close();
                }
                if (updateStatusStmt != null) {
                    updateStatusStmt.close();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing resources", ex);
            }
        }

        return newStatus; // Trả về trạng thái mới
    }



//    public static void main(String[] args) {
//        ClassDAO dao = new ClassDAO();
//        System.out.println(dao.findByManagerId(2));
//    }
}
