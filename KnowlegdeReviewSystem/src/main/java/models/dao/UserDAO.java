package models.dao;

import models.DAO;
import models.User;
import models.UserStatus;
import services.DatabaseConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.*;

public class UserDAO extends DatabaseConnector implements DAO<User> {
    Connection connection = getConnection();

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    @Override
    public int create(User user) {
        String sql = "INSERT INTO user (full_name, username, password_hash, email, role_id, status, created_at, modified_at) VALUES (?, ?, ?, ?, ?, ?, now(), now())";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, user.getFullName());
            preparedStatement.setString(2, user.getUsername());
            preparedStatement.setString(3, user.getPasswordHash());
            preparedStatement.setString(4, user.getEmail());
            preparedStatement.setInt(5, user.getRoleId());
            preparedStatement.setString(6, user.getStatus().toString());

            preparedStatement.executeUpdate();
            System.out.println("User created successfully!");

        } catch (SQLException e) {
            System.err.println("Error creating user: " + e.getMessage());
        }
        return 0;
    }

    public void register(User user) {
        String sql = "INSERT INTO user (username, avatar, password_hash, email, role_id, status, created_at, modified_at, full_name) VALUES (?, ?, ?, ?, ?, ?, Now(), Now(), ?)";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getAvatar());
            preparedStatement.setString(3, user.getPasswordHash());
            preparedStatement.setString(4, user.getEmail());
            preparedStatement.setInt(5, user.getRoleId());
            preparedStatement.setString(6, user.getStatus().toString());
            preparedStatement.setString(7, user.getFullName());
            //System.out.println(preparedStatement);

            preparedStatement.executeUpdate();
            System.out.println("User created successfully!");

        } catch (SQLException e) {
            System.err.println("Error creating user: " + e.getMessage());
        }
    }

    @Override
    public void update(User user) {
        PreparedStatement ps = null;

        try {
            String sql = "UPDATE krsdb.user " +
                    "SET full_name = ?, " +
                    "email = ?, " +
                    "role_id = ?, " +
                    "modified_at = NOW(), " +
                    "avatar = ? " +
                    "WHERE id = ?";

            ps = connection.prepareStatement(sql);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setInt(3, user.getRoleId());
            ps.setString(4, user.getAvatar());
            ps.setInt(5, user.getId());

            ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    @Override
    public User findById(int id) {

        PreparedStatement ps = null;
        ResultSet rs = null;
        User user = null;

        try {
            String sql = "SELECT * FROM krsdb.user WHERE id = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                user.setAvatar(rs.getString("avatar"));
                user.setUsername(rs.getString("username"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setEmail(rs.getString("email"));
                user.setRoleId(rs.getInt("role_id"));

                // Xử lý UserStatus (tránh lỗi null)
                String statusStr = rs.getString("status");
                if (statusStr != null) {
                    user.setStatus(UserStatus.valueOf(statusStr.replace(" ", "")));
                } else {
                    user.setStatus(UserStatus.NotVerified); // Giá trị mặc định nếu status bị null
                }

                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setModifiedAt(rs.getTimestamp("modified_at"));
                user.setModifiedBy(rs.getInt("modified_by"));
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

        return user;
    }

    public void updateStatus(User user){
        String sql = "UPDATE user SET status = ?, modified_at = Now() WHERE id = ?";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, user.getStatus().toString());
            preparedStatement.setInt(2, user.getId());

            int rowsUpdated = preparedStatement.executeUpdate();

            if (rowsUpdated > 0) {
                LOGGER.info("User updated successfully! ID: " + user.getId());
            } else {
                LOGGER.warning("No user found with ID: " + user.getId());
            }

        } catch (SQLException e) {

            LOGGER.warning("Error updating user: " + e.getMessage());
        }
    }

    @Override
    public void delete(User user) {
        String sql = "DELETE FROM user WHERE id = ?";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, user.getId());
            preparedStatement.executeUpdate();
            System.out.println("User deleted successfully!");

        } catch (SQLException e) {
            System.err.println("Error deleting user: " + e.getMessage());
        }
    }

    @Override
    public List<User> findAll() {
        ArrayList<User> userList = new ArrayList<>();
        PreparedStatement ps = null;

        try {
            String sql = "SELECT * FROM krsdb.user";

            ps = connection.prepareStatement(sql);     // chuyển câu lệnh sang sql server
            ResultSet rs = ps.executeQuery();                // thay có việc run bên sql server
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                user.setAvatar(rs.getString("avatar"));
                user.setUsername(rs.getString("username"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setEmail(rs.getString("email"));
                user.setRoleId(rs.getInt("role_id"));

                String statusStr = rs.getString("status");
                if (statusStr != null && !statusStr.trim().isEmpty()) {
                    UserStatus status = UserStatus.valueOf(statusStr.replace(" ", ""));
                    user.setStatus(status);
                } else {
                    user.setStatus(UserStatus.NotVerified); // Gán giá trị mặc định nếu status null
                }

                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setModifiedAt(rs.getTimestamp("modified_at"));
                user.setModifiedBy(rs.getInt("modified_by"));

                userList.add(user);
            }

        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return userList;
    }

    public List<User> searchUsers(String searchQuery, Integer roleId, UserStatus status) {
        List<User> userList = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT * FROM krsdb.user WHERE "
                    + "(? IS NULL OR full_name LIKE CONCAT('%', ?, '%') "
                    + "OR username LIKE CONCAT('%', ?, '%') "
                    + "OR email LIKE CONCAT('%', ?, '%')) "
                    + "AND (role_id = COALESCE(?, role_id)) "
                    + "AND (? IS NULL OR status = ?)";


            ps = connection.prepareStatement(sql);
            if (searchQuery == null || searchQuery.trim().isEmpty()) {
                ps.setNull(1, Types.VARCHAR);
                ps.setNull(2, Types.VARCHAR);
                ps.setNull(3, Types.VARCHAR);
                ps.setNull(4, Types.VARCHAR);
            } else {
                ps.setString(1, searchQuery);
                ps.setString(2, searchQuery);
                ps.setString(3, searchQuery);
                ps.setString(4, searchQuery);
            }


            if (roleId != null) {
                ps.setInt(5, roleId);
            } else {
                ps.setNull(5, Types.INTEGER);
            }

            if (status != null) {
                ps.setString(6, status.toString());
                ps.setString(7, status.toString());
            } else {
                ps.setNull(6, Types.VARCHAR);
                ps.setNull(7, Types.VARCHAR);
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRoleId(rs.getInt("role_id"));

                // Xử lý trạng thái
                String statusStr = rs.getString("status");
                user.setStatus(statusStr != null ? UserStatus.valueOf(statusStr) : UserStatus.NotVerified);

                userList.add(user);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return userList;
    }
    //endregion
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM krsdb.user WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM krsdb.user WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public User findByUsernameOrEmail(String usernameOrEmail) {
        System.out.println("Find User By Username or Email: " + usernameOrEmail);

        String sql = "SELECT * FROM user WHERE (username = ? OR email = ?) AND (status = 'Active' OR status = 'NotVerified')";
        User user = null;

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, usernameOrEmail);
            preparedStatement.setString(2, usernameOrEmail);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                user = new User();
                user.setId(resultSet.getInt("id"));
                user.setFullName(resultSet.getString("full_name"));
                user.setAvatar(resultSet.getString("avatar"));
                user.setUsername(resultSet.getString("username"));
                user.setPasswordHash(resultSet.getString("password_hash"));
                user.setEmail(resultSet.getString("email"));
                user.setRoleId(resultSet.getInt("role_id"));
                user.setStatus(UserStatus.valueOf(resultSet.getString("status")));
                user.setCreatedAt(resultSet.getTimestamp("created_at"));
                user.setModifiedAt(resultSet.getTimestamp("modified_at"));
                user.setModifiedBy(resultSet.getInt("modified_by"));
            }

        } catch (SQLException e) {
            System.err.println("Error finding user by username or email: " + e.getMessage());
        }

        return user;
    }

    public String getUserFullname(int userId){
        String sql = "SELECT full_name FROM krsdb.user WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("full_name");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error while fetching manager username", e);
        }
        return "Unknown";
    }

    public String getManagerUsername(int managerId) {
        String sql = "SELECT username FROM krsdb.user WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("username");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error while fetching manager username", e);
        }
        return "Unknown";
    }

    public int getIdByUsername(String username) {
        String sql = "SELECT id FROM krsdb.user WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error while fetching manager ID by username", e);
        }
        return -1;  // Return -1 if username is not found
    }

    public String getRoleByUsername(String username) {
        String role = null;
        Connection connection = getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Sử dụng JOIN để lấy role trực tiếp từ bảng setting
            String sql = "SELECT s.title FROM user u " +
                    "JOIN setting s ON u.role_id = s.id " +
                    "WHERE u.username = ?";

            ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Trả về title của role từ bảng setting
                role = rs.getString("title");
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

        return role;
    }

    public User findByEmail(String email) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        User user = null;

        try {
            String sql = "SELECT * FROM krsdb.user WHERE email = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setAvatar(rs.getString("avatar"));
                user.setUsername(rs.getString("username"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }

        return user;
    }

    public UserStatus toggleUserStatus(int userId) {
        String getStatusQuery = "SELECT status FROM krsdb.user WHERE id = ?";
        String updateStatusQuery = "UPDATE krsdb.user SET status = ?, modified_at = NOW() WHERE id = ?";
        UserStatus newStatus = UserStatus.NotVerified;

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement getStatusStmt = connection.prepareStatement(getStatusQuery);
             PreparedStatement updateStatusStmt = connection.prepareStatement(updateStatusQuery)) {

            // Lấy trạng thái hiện tại của user
            getStatusStmt.setInt(1, userId);
            ResultSet rs = getStatusStmt.executeQuery();

            if (rs.next()) {
                String currentStatus = rs.getString("status");

                if ("Active".equalsIgnoreCase(currentStatus) || "NotVerified".equalsIgnoreCase(currentStatus)) {
                    newStatus = UserStatus.Deactivated;
                } else if ("Deactivated".equalsIgnoreCase(currentStatus)) {
                    newStatus = UserStatus.NotVerified;
                }

                // Cập nhật trạng thái mới
                updateStatusStmt.setString(1, newStatus.toString());
                updateStatusStmt.setInt(2, userId);
                updateStatusStmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return newStatus;
    }
}
