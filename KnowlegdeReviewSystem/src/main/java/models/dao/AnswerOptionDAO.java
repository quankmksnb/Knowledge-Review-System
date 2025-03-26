package models.dao;

import models.AnswerOption;
import models.DAO;
import services.DatabaseConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AnswerOptionDAO extends DatabaseConnector implements DAO<AnswerOption> { // Renamed to AnswerOptionDAO for clarity

    private static final Logger LOGGER = Logger.getLogger(AnswerOptionDAO.class.getName());

    @Override
    public int create(AnswerOption answer) {
        String sql = "INSERT INTO answer_option (question_id, content, is_answer) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, answer.getQuestionId());
            stmt.setString(2, answer.getContent());
            stmt.setBoolean(3, answer.isAnswer());

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted == 0) {
                throw new SQLException("Creating answer failed, no rows affected.");
            }

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new SQLException("Creating answer failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating answer: " + e.getMessage(), e);
            throw new RuntimeException("Failed to create answer in the database", e);
        }
    }

    @Override
    public void update(AnswerOption answer) {
        String sql = "UPDATE answer_option SET content = ?, is_answer = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, answer.getContent());
            stmt.setBoolean(2, answer.isAnswer());
            stmt.setInt(3, answer.getId());

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated == 0) {
                throw new SQLException("Updating answer failed, no rows affected. Answer ID: " + answer.getId());
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating answer with ID " + answer.getId() + ": " + e.getMessage(), e);
            throw new RuntimeException("Failed to update answer in the database", e);
        }
    }

    @Override
    public void delete(AnswerOption answer) {
        String sql = "DELETE FROM answer_option WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, answer.getId());
            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted == 0) {
                LOGGER.log(Level.WARNING, "No answer found with ID " + answer.getId() + " to delete.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting answer with ID " + answer.getId() + ": " + e.getMessage(), e);
            throw new RuntimeException("Failed to delete answer from the database", e);
        }
    }

    @Override
    public AnswerOption findById(int id) {
        String sql = "SELECT * FROM answer_option WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet resultSet = stmt.executeQuery()) {
                if (resultSet.next()) {
                    return new AnswerOption(
                            resultSet.getInt("id"),
                            resultSet.getInt("question_id"),
                            resultSet.getString("content"),
                            resultSet.getBoolean("is_answer")
                    );
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding answer with ID " + id + ": " + e.getMessage(), e);
            throw new RuntimeException("Failed to find answer in the database", e);
        }
        return null;
    }

    @Override
    public List<AnswerOption> findAll() {
        List<AnswerOption> answers = new ArrayList<>();
        String sql = "SELECT * FROM answer_option";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet resultSet = stmt.executeQuery(sql)) {

            while (resultSet.next()) {
                answers.add(new AnswerOption(
                        resultSet.getInt("id"),
                        resultSet.getInt("question_id"),
                        resultSet.getString("content"),
                        resultSet.getBoolean("is_answer")
                ));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all answers: " + e.getMessage(), e);
            throw new RuntimeException("Failed to retrieve answers from the database", e);
        }
        return answers;
    }

    public List<AnswerOption> findAnswersByQuestionId(int questionId) {
        List<AnswerOption> answers = new ArrayList<>();
        String sql = "SELECT * FROM answer_option WHERE question_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, questionId);
            try (ResultSet resultSet = stmt.executeQuery()) {
                while (resultSet.next()) {
                    answers.add(new AnswerOption(
                            resultSet.getInt("id"),
                            resultSet.getInt("question_id"),
                            resultSet.getString("content"),
                            resultSet.getBoolean("is_answer")
                    ));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding answers for question ID " + questionId + ": " + e.getMessage(), e);
            throw new RuntimeException("Failed to retrieve answers for question ID " + questionId, e);
        }
        return answers;
    }

    public void deleteByQuestionId(int questionId) {
        String sql = "DELETE FROM answer_option WHERE question_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, questionId);
            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted == 0) {
                LOGGER.log(Level.WARNING, "No answers found for question ID " + questionId + " to delete.");
            } else {
                LOGGER.log(Level.INFO, "Deleted " + rowsDeleted + " answers for question ID " + questionId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting answers for question ID " + questionId + ": " + e.getMessage(), e);
            throw new RuntimeException("Failed to delete answers for question ID " + questionId, e);
        }
    }
}