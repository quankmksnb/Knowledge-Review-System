package models.dao;

import models.QuizResult;
import services.DatabaseConnector;

import java.sql.*;

public class QuizResultDAO {
    public void create(QuizResult quizResult) {
        String sql = "INSERT INTO quiz_result (quiz_id, user_id, grade) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quizResult.getQuizId());
            stmt.setInt(2, quizResult.getUserId());
            stmt.setDouble(3, quizResult.getGrade());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public QuizResult findByQuizIdAndUserId(int quizId, int userId) {
        String sql = "SELECT * FROM quiz_result WHERE quiz_id = ? AND user_id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quizId);
            stmt.setInt(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    QuizResult result = new QuizResult();
                    result.setId(rs.getInt("id"));
                    result.setQuizId(rs.getInt("quiz_id"));
                    result.setUserId(rs.getInt("user_id"));
                    result.setGrade(rs.getDouble("grade"));
                    // Set other fields as needed
                    return result;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Return null if no result is found
    }
}