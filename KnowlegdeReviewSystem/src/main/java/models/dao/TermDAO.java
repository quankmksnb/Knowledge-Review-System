package models.dao;

import models.Subject;
import models.Term;
import services.DatabaseConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.Hashtable;
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
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("status")
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
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("status")

                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return terms;
    }

    public Term getTermsByTermId(int term) {
        List<Term> terms = new ArrayList<>();
        String sql = "select * from term where id = " + term;

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {



            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    terms.add(new Term(
                            rs.getInt("id"),
                            rs.getInt("lesson_id"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("status")

                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return terms.get(0);
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
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("status")

                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return terms;
    }

    public List<Term> getTermsByContent(int subjectId, String content) {
        List<Term> terms = new ArrayList<>();
        String sql = "SELECT t.* FROM term t JOIN lesson l ON t.lesson_id = l.id JOIN subject s ON l.subject_id = s.id WHERE s.id = " + subjectId + " and t.title LIKE '%" + content + "%'";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {



            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    terms.add(new Term(
                            rs.getInt("id"),
                            rs.getInt("lesson_id"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("status")

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
        String sql = "SELECT t.id, t.title As term_title,t.content AS term_content, l.id AS lesson_id, t.status " +
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
                            rs.getString("term_title"),
                            rs.getString("term_content"),
                            rs.getString("status")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return terms;
    }

    public List<Term> getTermsByUserIdByContent(int userId, String content) {
        List<Term> terms = new ArrayList<>();
        String sql = "SELECT t.* FROM term t JOIN user_flashcard uf ON t.id = uf.term_id WHERE uf.user_id = " + userId + " AND t.title LIKE '%" + content + "%'";

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {



            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    terms.add(new Term(
                            rs.getInt("id"),
                            rs.getInt("lesson_id"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("status")

                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return terms;
    }

    public Hashtable<Integer, String> getTermDomainConfigHashtable() {
        Hashtable<Integer, String> termDomainConfigMap = new Hashtable<>();
        String sql = "SELECT td.term_id, c.description FROM term_domain td JOIN config c ON td.domain_id = c.id";

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int termId = rs.getInt("term_id");
                    String configDescription = rs.getString("description");
                    termDomainConfigMap.put(termId, configDescription);
                }

            }


        } catch (SQLException e) {
            e.printStackTrace();
        }

        return termDomainConfigMap;
    }
    public int createTerm(Term term) {
        String sql = "INSERT INTO term (lesson_id, title, content, status) VALUES (?, ?, ?, ?)";
        int generatedId = -1;

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, term.getLessonId());
            stmt.setString(2, term.getTitle());
            stmt.setString(3, term.getContent());
            stmt.setString(4, term.getStatus());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        generatedId = generatedKeys.getInt(1);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return generatedId;
    }

    public int updateTerm(Term term) {
        String sql = "UPDATE term SET lesson_id = ?, title = ?, content = ?, status = ? WHERE id = ?";
        int affectedRows = 0;

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, term.getLessonId());
            stmt.setString(2, term.getTitle());
            stmt.setString(3, term.getContent());
            stmt.setString(4, term.getStatus());
            stmt.setInt(5, term.getId());

            affectedRows = stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return affectedRows;
    }

    public int changeTermStatus(int id, String status) {
        String sql = "UPDATE term SET status = ? WHERE id = ?";
        int affectedRows = 0;

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, id);

            affectedRows = stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return affectedRows;
    }

    public static void main(String[] args) {
        Term term = new Term(0, 2, "Kera", "Bang mot bo rau", "Active");

        System.out.println(new TermDAO().createTerm(term));
    }
}
