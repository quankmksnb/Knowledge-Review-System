package models.dao;

import models.QuizQuestion;
import services.DatabaseConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizQuestionDAO {

    public List<QuizQuestion> findByQuizId(int quizId) {
        List<QuizQuestion> quizQuestions = new ArrayList<>();
        String sql = "SELECT * FROM quiz_question WHERE quiz_id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quizId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    QuizQuestion quizQuestion = new QuizQuestion();
                    quizQuestion.setId(rs.getInt("id"));
                    quizQuestion.setQuizId(rs.getInt("quiz_id"));
                    quizQuestion.setQuestionId(rs.getInt("question_id"));
                    quizQuestions.add(quizQuestion);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quizQuestions;
    }
}