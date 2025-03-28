package models.dao;

import models.DAO;
import models.Subject;
import services.DatabaseConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SubjectDAO extends DatabaseConnector implements DAO<Subject> {
    Connection connection = getConnection();

    public void save(Subject subject, String action) {
        String sql = "INSERT INTO subject_manager (manager_id, subject_id, time, action) VALUES (?, ?, NOW(), ?)";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, 1);  // user_id mặc định là 1
            preparedStatement.setInt(2, subject.getId());
            preparedStatement.setString(3, action);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    @Override
    public int create(Subject subject) {
        String sql = "INSERT INTO subject ( category_id, domain_id, name, code, description, modified_at, status, created_by) VALUES (?, ?, ?, ?, ?, Now(), ?, ?)";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);

            int categoryId = subject.getCategoryId();
            int domainId = subject.getDomainId();
            String subjectName = subject.getSubjectName();
            String code = subject.getCode();
            String description = subject.getDescription();
            String status = subject.isStatus() ? "Active" : "Inactive";
            int createdBy = 1;

            preparedStatement.setInt(1, categoryId);
            preparedStatement.setInt(2, domainId);
            preparedStatement.setString(3, subjectName);
            preparedStatement.setString(4, code);
            preparedStatement.setString(5, description);
            preparedStatement.setString(6, status);
            preparedStatement.setInt(7, createdBy);

            String formattedSQL = String.format(
                    "INSERT INTO subject (category_id, domain_id, name, code, description, modified_at, status, created_by) " +
                            "VALUES (%d, %d, '%s', '%s', '%s', Now(), '%s', %d);",
                    categoryId, domainId, subjectName, code, description, status, createdBy
            );

            int n = preparedStatement.executeUpdate();
            //System.out.println(formattedSQL);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return 0;
    }

    public void changeStatus(Subject subject) {
        String sql = "UPDATE subject SET status = ? WHERE id = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, (subject.isStatus()) ? "Inactive" : "Active");
            preparedStatement.setInt(2, subject.getId());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void update(Subject subject) {
        String sql = "UPDATE `subject`\n" +
                "SET \n" +
                "    `category_id` = 2, \n" +
                "    `domain_id` = ?, \n" +
                "    `name` = ?, \n" +
                "    `code` = ?, \n" +
                "    `description` = ?,\n" +
                "    `modified_at` = ?,\n" +
                "    `status` = ? \n" +
                "WHERE \n" +
                "    `id` = ?;";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, subject.getDomainId());
            preparedStatement.setString(2, subject.getSubjectName());
            preparedStatement.setString(3, subject.getCode());
            preparedStatement.setString(4, subject.getDescription());
            preparedStatement.setDate(5, new java.sql.Date(subject.getModifiedAt().getTime()));
            preparedStatement.setString(6, (subject.isStatus()) ? "Active" : "Inactive");
            preparedStatement.setInt(7, subject.getId());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void delete(Subject subject) {
        try {
            Statement st = connection.createStatement();
            String sql = "DELETE FROM subject_manager WHERE subject_id = " + subject.getId();

            st.executeUpdate(sql);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        try {
            Statement st = connection.createStatement();
            String sql =  "DELETE FROM subject WHERE id = " + subject.getId();
            st.executeUpdate(sql);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    @Override
    public Subject findById(int id) {
        Subject subject = new Subject();
        ResultSet rs = null;
        try {
            Statement st = connection.createStatement();
            rs = st.executeQuery("select code, name, description, domain_id, status from subject where id = " + id);
            while (rs.next()) {
                subject.setSubjectName(rs.getString("name"));
                subject.setCode(rs.getString("code"));
                subject.setDescription(rs.getString("description"));
                subject.setDomainId(rs.getInt("domain_id"));
                subject.setId(id);
                subject.setStatus((rs.getString("status").equals("Active")) ? true : false);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return subject;
    }

    public HashMap<Integer, String> getDomains() {
        HashMap<Integer, String> map = new HashMap<>();
        String sql = "SELECT id, title FROM setting WHERE type = 'Category'";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = null;
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                map.put(resultSet.getInt("id"), resultSet.getString("title"));
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return map;
    }

    @Override
    public List<Subject> findAll() {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT * FROM subject"; // Ensure the table name is correct

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Subject subject = new Subject(
                        rs.getInt("id"),
                        rs.getInt("domain_id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("code"),
                        rs.getString("description"),
                        rs.getInt("created_by"),
                        rs.getInt("modified_by"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("modified_at")
                );
                subjects.add(subject);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return subjects;
    }

    public List<Subject> searchSubjects(String keyword, int limit) {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT * FROM subject WHERE name LIKE ? OR code LIKE ? OR description LIKE ? LIMIT ?";

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + keyword + "%");
            stmt.setString(2, "%" + keyword + "%");
            stmt.setString(3, "%" + keyword + "%");
            stmt.setInt(4, limit); // Limit results

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    subjects.add(new Subject(
                            rs.getInt("id"),
                            rs.getInt("domain_id"),
                            rs.getInt("category_id"),
                            rs.getString("name"),
                            rs.getString("code"),
                            rs.getString("description"),
                            rs.getInt("created_by"),
                            rs.getInt("modified_by"),
                            rs.getTimestamp("created_at"),
                            rs.getTimestamp("modified_at")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }

    public List<DTOSubject> findAlls(String sql) {
        List<DTOSubject> list = new ArrayList<>();
        ResultSet rs = null;

        try {
            Statement st = connection.createStatement();

            rs = st.executeQuery(sql);
            while (rs.next()) {
                DTOSubject dto = new DTOSubject(
                        rs.getInt("id"),
                        rs.getString("code"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getString("title"),
                        rs.getDate("modified_at"),
                        rs.getString("status").equals("Active")
                );
                list.add(dto);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


        return list;
    }

    public String getSubjectCodeById(int subjectId) {
        String sql = "SELECT code FROM krsdb.subject WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("code");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Unknown";
    }

    public String getSubjectNameById(int subjectId) {
        String sql = "SELECT name FROM krsdb.subject WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("name"); // Lấy tên subject
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Unknown";
    }

    public String getDomain(int subjectId) {
        String sql = "SELECT cfg.title FROM krsdb.subject s LEFT JOIN krsdb.setting cfg ON s.domain_id = cfg.id WHERE s.id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("title");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Unknown";
    }

    public List<Subject> findByDomain(int domainId) {
        List<Subject> subjectList = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT * FROM krsdb.subject WHERE domain_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, domainId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Subject subject = new Subject();
                subject.setId(rs.getInt("id"));
                subject.setCode(rs.getString("code"));
                subject.setDomainId(rs.getInt("domain_id"));
                subjectList.add(subject);
            }
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException ex) {
                Logger.getLogger(SubjectDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return subjectList;
    }

    public List<Subject> getSubjectsByUserId(int userId) {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT s.* FROM subject s " +
                "JOIN class c ON s.id = c.subject_id " +
                "WHERE c.manager_id = ?"; // Giả sử có bảng `class` chứa thông tin người dùng tham gia môn học.

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Subject subject = new Subject();
                subject.setId(rs.getInt("id"));
                subject.setSubjectName(rs.getString("name"));
                subject.setDescription(rs.getString("description"));
                subjects.add(subject);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }

}
