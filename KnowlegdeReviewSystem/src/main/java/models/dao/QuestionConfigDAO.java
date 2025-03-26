package models.dao;

import services.DatabaseConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class QuestionConfigDAO extends DatabaseConnector {
    Connection connection = getConnection();
    public int create (int questionId, int configId) throws Exception {
        String sql = "INSERT INTO question_config (question_id, config_id) VALUES (?, ?)";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, questionId);
            preparedStatement.setInt(2, configId);
            return preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    public int deleteByQuestionId(int questionId) throws Exception {
        String sql = "DELETE FROM question_config WHERE question_id = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, questionId);
            return preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
