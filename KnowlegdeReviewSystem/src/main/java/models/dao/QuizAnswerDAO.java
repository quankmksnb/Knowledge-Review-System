package models.dao;

import models.QuizAnswer;
import services.DatabaseConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizAnswerDAO {
    private Connection getConnection() throws SQLException {
        // Replace with your connection logic (e.g., DataSource)
        return DatabaseConnector.getConnection();
    }

    public void create(QuizAnswer quizAnswer) {
        String sql = "INSERT INTO quiz_answer (quiz_id, user_id, question_id, answer_option_id, is_correct) " +
                "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quizAnswer.getQuizId());
            stmt.setInt(2, quizAnswer.getUserId());
            stmt.setInt(3, quizAnswer.getQuestionId());
            stmt.setObject(4, quizAnswer.getAnswerOptionId(), Types.INTEGER); // Handles null
            stmt.setBoolean(5, quizAnswer.isCorrect());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle exception appropriately
        }
    }

    public List<QuizAnswer> findByQuizIdAndUserId(int quizId, int userId) {
        List<QuizAnswer> answers = new ArrayList<>();
        String sql = "SELECT * FROM quiz_answer WHERE quiz_id = ? AND user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quizId);
            stmt.setInt(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    QuizAnswer answer = new QuizAnswer();
                    answer.setId(rs.getInt("id"));
                    answer.setQuizId(rs.getInt("quiz_id"));
                    answer.setUserId(rs.getInt("user_id"));
                    answer.setQuestionId(rs.getInt("question_id"));
                    answer.setAnswerOptionId(rs.getInt("answer_option_id")); // Handles null in the class
                    answer.setIsCorrect(rs.getBoolean("is_correct"));
                    answers.add(answer);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Consider proper logging in production
        }
        return answers;
    }
}