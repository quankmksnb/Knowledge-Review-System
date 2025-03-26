package models.dao;

import models.Config;
import models.DAO;
import models.DTOConfig;
import services.DatabaseConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConfigDAO extends DatabaseConnector implements DAO<Config>{
    @Override
    public int create(Config config) {
        try {
            String sql = "INSERT INTO config (subject_id, type_id, description, status) VALUES (?, ?, ?, ?)";
            PreparedStatement preparedStatement = getConnection().prepareStatement(sql);
            preparedStatement.setInt(1, config.getSubjectId());
            preparedStatement.setInt(2, config.getTypeId());
            preparedStatement.setString(3, config.getDescription());
            preparedStatement.setString(4, "Active");
            System.out.println(preparedStatement.executeUpdate());

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return 0;
    }

    @Override
    public void update(Config config) {
        String sql = "UPDATE config SET type_id = ?, description = ?, status = ? WHERE id = " + config.getId();

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setInt(1, config.getTypeId());
            stmt.setString(2, config.getDescription());
            stmt.setString(3, config.getStatus());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void delete(Config config) {

    }

    @Override
    public Config findById(int id) {
        Config config = new Config();
        ResultSet rs = null;
        try {
            Statement statement = getConnection().createStatement();
            rs = statement.executeQuery("SELECT id, type_id, description, status FROM config  WHERE config.id = " + id);
            while (rs.next()) {
                String typeId = rs.getString("type_id");
                String description = rs.getString("description");
                String status = rs.getString("status");
                config.setId(id);
                config.setTypeId(Integer.parseInt(typeId));
                config.setDescription(description);
                config.setStatus(status);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return config;
    }

    @Override
    public List<Config> findAll() {

        return List.of();
    }

    public List<DTOConfig> findAllConfigDTO(String sql) {
        List<DTOConfig> list = new ArrayList<>();
        ResultSet rs = null;
        try {
            Statement statement = getConnection().createStatement();
            rs = statement.executeQuery(sql);
            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String subjectName = rs.getString("name");
                String description = rs.getString("description");
                String status = rs.getString("status");
                DTOConfig dto = new DTOConfig(id, subjectName, title, description, status);
                list.add(dto);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<DTOConfig> findConfigBySubjectId(int subjectId) {
        DTOConfig dtoConfig = null;
        ResultSet rs = null;
        List<DTOConfig> list = new ArrayList<>();
        try {
            Statement statement = getConnection().createStatement();
            rs = statement.executeQuery("SELECT config.id, config.description, subject.name, setting.title , config.status FROM config JOIN subject ON config.subject_id = subject.id JOIN setting ON config.type_id = setting.id WHERE config.subject_id =" + subjectId);
            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String subjectName = rs.getString("name");
                String description = rs.getString("description");
                String status = rs.getString("status");
                dtoConfig = new DTOConfig(id, subjectName, title, description, status);
                list.add(dtoConfig);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<DTOConfig> findDomainBySubjectId(int subjectId) {
        DTOConfig dtoConfig = null;
        ResultSet rs = null;
        List<DTOConfig> list = new ArrayList<>();
        try {
            Statement statement = getConnection().createStatement();
            rs = statement.executeQuery("SELECT config.id, config.description, subject.name, setting.title , config.status FROM config JOIN subject ON config.subject_id = subject.id JOIN setting ON config.type_id = setting.id WHERE config.subject_id = " + subjectId);
            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String subjectName = rs.getString("name");
                String description = rs.getString("description");
                String status = rs.getString("status");
                dtoConfig = new DTOConfig(id, subjectName, title, description, status);
                list.add(dtoConfig);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public int changeStatus(int id, String status) {
        String sql = "UPDATE config SET status = ? WHERE id = " + id;
        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setString(1, status);
            return stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Config> getChaptersBySubject(int subjectId) {
        List<Config> chapters = new ArrayList<>();
        String sql = "SELECT c.id, c.description FROM config c " +
                "JOIN setting s ON c.type_id = s.id WHERE s.title = 'Chapter' " +
                "AND c.subject_id = ?";

        try (PreparedStatement stmt = DatabaseConnector.getConnection().prepareStatement(sql)) {
            stmt.setInt(1, subjectId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Config chapter = new Config();
                chapter.setId(rs.getInt("id"));
                chapter.setDescription(rs.getString("description"));
                chapters.add(chapter);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return chapters;
    }

    public int getChapterIdByLessonId(int lessonId) {
        int chapterId = -1; // Mặc định trả về -1 nếu không tìm thấy chapter

        String sql = "SELECT config_id FROM lesson_config WHERE lesson_id = ?";

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, lessonId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                chapterId = rs.getInt("config_id"); // Lấy chapterId từ bảng lesson_config
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return chapterId;
    }

}
