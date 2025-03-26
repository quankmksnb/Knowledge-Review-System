package models.dao;

import models.Subject;
import models.Term;
import services.DatabaseConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TermDAO extends DatabaseConnector {


    public List<Term> getTermsBySubjectId(int subjectId) {
        List<Term> terms = new ArrayList<>();
        String sql = "SELECT t.* FROM term t JOIN lesson l ON t.lesson_id = l.id JOIN subject s ON l.subject_id = s.id WHERE s.id = " + subjectId;

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {



            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    terms.add(new Term(
                            rs.getInt("id"),
                            rs.getInt("lesson_id"),

                            rs.getString("content")

                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return terms;
    }
    public List<Term> getTermsByLessonId(int lessonId) {
        List<Term> terms = new ArrayList<>();
        String sql = "select * from term where lesson_id = " + lessonId;

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {



            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    terms.add(new Term(
                            rs.getInt("id"),
                            rs.getInt("lesson_id"),

                            rs.getString("content")

                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return terms;
    }

    public List<Term> getTermsByUserId(int userId) {
        List<Term> terms = new ArrayList<>();
        String sql = "SELECT t.* FROM term t JOIN user_flashcard uf ON t.id = uf.term_id WHERE uf.user_id = " + userId;

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {



            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    terms.add(new Term(
                            rs.getInt("id"),
                            rs.getInt("lesson_id"),

                            rs.getString("content")

                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return terms;
    }
    public List<Term> getTermsByUserIdBySubjectId(int subjectId, int userId) {
        List<Term> terms = new ArrayList<>();
        String sql = "SELECT t.id, t.content AS term_content, l.id AS lesson_id " +
                "FROM user_flashcard uf " +
                "JOIN term t ON uf.term_id = t.id " +
                "JOIN lesson l ON t.lesson_id = l.id " +
                "JOIN subject s ON l.subject_id = s.id " +
                "WHERE s.id = ? AND uf.user_id = ?";

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, subjectId);
            stmt.setInt(2, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    terms.add(new Term(
                            rs.getInt("id"),
                            rs.getInt("lesson_id"),
                            rs.getString("term_content")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return terms;
    }


}
