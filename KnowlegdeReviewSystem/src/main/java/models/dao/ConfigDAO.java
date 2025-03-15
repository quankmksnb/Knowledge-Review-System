package models.dao;

import models.Config;
import models.DAO;
import models.DTOConfig;
import services.DatabaseConnector;
import java.util.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

public class ConfigDAO extends DatabaseConnector implements DAO<Config>{
    @Override
    public void create(Config config) {
        try {
            String sql = "INSERT INTO config (subject_id, type_id, description) VALUES (?, ?, ?)";
            PreparedStatement preparedStatement = getConnection().prepareStatement(sql);
            preparedStatement.setInt(1, config.getSubjectId());
            preparedStatement.setInt(2, config.getTypeId());
            preparedStatement.setString(3, config.getDescription());
            System.out.println(preparedStatement.executeUpdate());

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void update(Config config) {
        String sql = "UPDATE config SET type_id = ?, description = ? WHERE id = " + config.getId();

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setInt(1, config.getTypeId());
            stmt.setString(2, config.getDescription());
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
        return null;
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
                DTOConfig dto = new DTOConfig(id, subjectName, title, description);
                list.add(dto);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public DTOConfig findConfigBySubjectId(int subjectId) {
        DTOConfig dtoConfig = null;
        ResultSet rs = null;
        try {
            Statement statement = getConnection().createStatement();
            rs = statement.executeQuery("SELECT config.id, config.description, subject.name, setting.title FROM config JOIN subject ON config.subject_id = subject.id JOIN setting ON config.type_id = setting.id WHERE config.subject_id = " + subjectId);
            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String subjectName = rs.getString("name");
                String description = rs.getString("description");
                dtoConfig = new DTOConfig(id, subjectName, title, description);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return dtoConfig;
    }

}
