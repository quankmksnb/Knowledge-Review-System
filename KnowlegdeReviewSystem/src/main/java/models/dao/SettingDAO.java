package models.dao;

import models.DAO;
import models.Setting;
import models.SettingType;
import services.DatabaseConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import static services.DatabaseConnector.getConnection;

public class SettingDAO implements DAO<Setting> {
    Connection connection = getConnection();

    @Override
    public int create(Setting setting) {
        String sql = "INSERT INTO setting (title, type, created_by, modified_by) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, setting.getTitle());
            stmt.setString(2, setting.getType().name()); // Assuming type is an ENUM stored as String
            stmt.setInt(3, setting.getCreatedBy());
            stmt.setInt(4, setting.getModifiedBy());

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    setting.setId(generatedKeys.getInt(1)); // Get auto-generated ID
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return 0;
    }

    @Override
    public void update(Setting setting) {
        String sql = "UPDATE setting SET title = ?, type = ?, modified_by = ? WHERE id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, setting.getTitle());
            stmt.setString(2, setting.getType().name());
            stmt.setInt(3, setting.getModifiedBy());
            stmt.setInt(4, setting.getId());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(Setting setting) {
        String sql = "DELETE FROM setting WHERE id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, setting.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Setting findById(int id) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Setting setting = null;

        try {
            String sql = "SELECT * FROM krsdb.setting WHERE id = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                setting = new Setting();
                setting.setId(rs.getInt("id"));
                setting.setTitle(rs.getString("title"));

                // Xử lý Enum SettingType
                String type = rs.getString("type");
                if (type != null) {
                    setting.setType(SettingType.valueOf(type));
                }

                setting.setCreatedBy(rs.getInt("created_by"));
                setting.setModifiedBy(rs.getInt("modified_by"));
            }

        } catch (SQLException ex) {
            Logger.getLogger(SettingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(SettingDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return setting;
    }

    @Override
    public List<Setting> findAll() {
        List<Setting> settings = new ArrayList<>();
        String sql = "SELECT * FROM setting";
        try (Connection conn = DatabaseConnector.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                settings.add(new Setting(
                        rs.getInt("id"),
                        rs.getInt("created_by"),
                        rs.getString("title"),
                        rs.getTimestamp("created_at"),
                        SettingType.valueOf(rs.getString("type")),
                        rs.getTimestamp("modified_at"),
                        rs.getInt("modified_by")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return settings;
    }

    public List<Setting> findAllByType(SettingType type) {
        List<Setting> settings = new ArrayList<>();
        String sql = "SELECT * FROM setting WHERE type = ?";

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, type.name()); // Set the enum value as a string
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                settings.add(new Setting(
                        rs.getInt("id"),
                        rs.getInt("created_by"),
                        rs.getString("title"),
                        rs.getTimestamp("created_at"),
                        SettingType.valueOf(rs.getString("type")),
                        rs.getTimestamp("modified_at"),
                        rs.getInt("modified_by")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return settings;
    }

    public List<Setting> findAllBySemester(){
        ArrayList<Setting> settingList = new ArrayList<>();
        PreparedStatement ps = null;
        try {
            String sql = "SELECT * FROM krsdb.setting where type = 'Semester' ORDER BY id DESC";

            ps = connection.prepareStatement(sql);     // chuyển câu lệnh sang sql server
            ResultSet rs = ps.executeQuery();                // thay có việc run bên sql server
            while (rs.next()) {
                Setting setting = new Setting();
                setting.setId(rs.getInt("id"));
                setting.setTitle(rs.getString("title"));

                // Xử lý Enum SettingType
                String type = rs.getString("type");
                if (type != null) {
                    setting.setType(SettingType.valueOf(type));
                }

                setting.setCreatedBy(rs.getInt("created_by"));
                setting.setModifiedBy(rs.getInt("modified_by"));

                settingList.add(setting);
            }

        } catch (SQLException ex) {
            Logger.getLogger(SettingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(SettingDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return settingList;
    }
    public String getRoleById(int roleId) {
        String role = null;
        Connection connection = getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT title FROM setting WHERE id = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, roleId);
            rs = ps.executeQuery();

            if (rs.next()) {
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
    public static void main(String[] args) {
        SettingDAO settingDAO = new SettingDAO();
        System.out.println(settingDAO.findAllByType(SettingType.Semester));
    }
}
