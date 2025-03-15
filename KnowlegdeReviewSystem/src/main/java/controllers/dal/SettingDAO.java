/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import models.Setting;
import models.SettingType;
import services.DatabaseConnector;

/**
 *
 * @author trung
 */
public class SettingDAO extends DatabaseConnector{
    private Connection conn;

    public SettingDAO() {
        conn = getConnection();
    }
     // Lấy danh sách tất cả cài đặt
    public List<Setting> getAllSettings() {
        List<Setting> settings = new ArrayList<>();
        String sql = "SELECT * FROM setting";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Setting setting = new Setting(
                    rs.getInt("id"),
                    rs.getInt("created_by"),
                    rs.getString("title"),
                    rs.getTimestamp("created_at"),
                        SettingType.valueOf(rs.getString("type")),
                    rs.getTimestamp("modified_at"),
                    rs.getObject("modified_by") != null ? rs.getInt("modified_by") : null
                );
                settings.add(setting);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return settings;
    }

    // Thêm cài đặt mới
    public boolean addSetting(Setting setting) {
        String sql = "INSERT INTO setting (created_by, title, type, created_at, modified_at, modified_by) VALUES (?, ?, ?, NOW(), NOW(), ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, setting.getCreatedBy());
            stmt.setString(2, setting.getTitle());
            stmt.setString(3, setting.getType().name());
            stmt.setObject(4, setting.getModifiedBy());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật cài đặt
    public boolean updateSetting(Setting setting) {
        String sql = "UPDATE setting SET title = ?, type = ?, modified_at = NOW(), modified_by = ? WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, setting.getTitle());
            stmt.setString(2, setting.getType().name());
            stmt.setObject(3, setting.getModifiedBy());
            stmt.setInt(4, setting.getId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa cài đặt theo ID
    public boolean deleteSetting(int id) {
        String sql = "DELETE FROM setting WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy cài đặt theo ID
    public Setting getSettingById(int id) {
        String sql = "SELECT * FROM setting WHERE id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Setting(
                    rs.getInt("id"),
                    rs.getInt("created_by"),
                    rs.getString("title"),
                    rs.getTimestamp("created_at"),
                    SettingType.valueOf(rs.getString("type")),
                    rs.getTimestamp("modified_at"),
                    rs.getObject("modified_by") != null ? rs.getInt("modified_by") : null
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Setting> getSettingsByType(String typeFilter) {
    List<Setting> settings = new ArrayList<>();
    String sql = "SELECT * FROM setting WHERE type LIKE ?";

    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, "%" + typeFilter + "%");

        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Setting setting = new Setting(
                    rs.getInt("id"),
                    rs.getInt("created_by"),
                    rs.getString("title"),
                    rs.getTimestamp("created_at"),
                    SettingType.valueOf(rs.getString("type")),
                    rs.getTimestamp("modified_at"),
                    rs.getObject("modified_by") != null ? rs.getInt("modified_by") : null
                );
                settings.add(setting);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return settings;
}

    public static void main(String[] args) {
        SettingDAO dao = new SettingDAO();
        
        Setting setting = dao.getSettingById(1);
        System.out.println(setting.getTitle());
    }

 

}
