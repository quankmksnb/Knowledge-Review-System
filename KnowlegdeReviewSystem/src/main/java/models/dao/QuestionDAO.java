package models.dao;

import models.DAO;
import models.Question;
import services.DatabaseConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class QuestionDAO extends DatabaseConnector implements DAO<Question> {

    @Override
    public void create(Question question) {
        String sql = "INSERT INTO question (subject_id, lesson_id, content) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, question.getSubjectId());
            stmt.setInt(2, question.getLessonid());
            stmt.setString(3, question.getContent());

            int rowsInserted = stmt.executeUpdate();
            System.out.println(rowsInserted);
        } catch (SQLException e) {
            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public void update(Question question) {
        String sql = "UPDATE question SET subject_id = ?, lesson_id = ?, content = ? WHERE id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, question.getSubjectId());
            stmt.setInt(2, question.getLessonid());
            stmt.setString(3, question.getContent());
            stmt.setInt(4, question.getId());

            stmt.executeUpdate();
        } catch (SQLException e) {
            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
        }
    }

    @Override
    public void delete(Question question) {
        String sql = "DELETE FROM question WHERE id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, question.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
        }
    }

    @Override
    public Question findById(int id) {
        String sql = "SELECT * FROM question WHERE id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Question(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getInt("lesson_id"),
                        rs.getString("content")
                );
            }
        } catch (SQLException e) {
            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return null;
    }

    @Override
    public List<Question> findAll() {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM question";
        try (Connection conn = DatabaseConnector.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                questions.add(new Question(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getInt("lesson_id"),
                        rs.getString("content")
                ));
            }
        } catch (SQLException e) {
            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return questions;
    }


    public List<Question> findBySubjectId(int subjectId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM question WHERE subject_id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, subjectId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                questions.add(new Question(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getInt("lesson_id"),
                        rs.getString("content")
                ));
            }
        } catch (SQLException e) {
            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return questions;
    }

    public List<Question> findByLessonId(int lessonId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM question WHERE lesson_id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, lessonId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                questions.add(new Question(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getInt("lesson_id"),
                        rs.getString("content")
                ));
            }
        } catch (SQLException e) {
            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return questions;
    }

    public static void main(String[] args) {
        QuestionDAO dao = new QuestionDAO();
        dao.create(new Question(1,2,1,"Vi trai tim anh yeu em nhieu lam"));
    }
}
