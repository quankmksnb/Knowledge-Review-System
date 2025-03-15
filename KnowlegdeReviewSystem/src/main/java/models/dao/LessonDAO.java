package models.dao;

import models.DAO;
import models.Lesson;
import services.DatabaseConnector;

import java.sql.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LessonDAO extends DatabaseConnector implements DAO<Lesson> {

    @Override
    public void create(Lesson lesson) {

    }

    @Override
    public void update(Lesson lesson) {

    }

    @Override
    public void delete(Lesson lesson) {

    }

    public boolean addLesson(int userId, int subjectId, String lessonName, String description) {
        String sql = "INSERT INTO lesson (subject_id, created_by, title, description, created_at) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = DatabaseConnector.getConnection().prepareStatement(sql)) {
            stmt.setInt(1, subjectId);
            stmt.setInt(2, userId);
            stmt.setString(3, lessonName);
            stmt.setString(4, description);
            stmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    public boolean updateLesson(int lessonId, int userId, int subjectId, String lessonName, String description) {
        String sql = "UPDATE lesson SET title = ?, description = ?, modified_at = ?, modified_by = ? WHERE id = ?";

        try (PreparedStatement stmt = DatabaseConnector.getConnection().prepareStatement(sql)) {
            stmt.setString(1, lessonName);
            stmt.setString(2, description);
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(4, userId);
            stmt.setInt(5, lessonId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteLesson(int id) {
        String sql = "DELETE FROM lesson WHERE id = ?";

        try (PreparedStatement stmt = DatabaseConnector.getConnection().prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Lesson getLessonById(int id) {
        String sql = "SELECT * FROM lesson WHERE id = ?";

        try (PreparedStatement stmt = DatabaseConnector.getConnection().prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Lesson(
                            rs.getInt("id"),
                            rs.getInt("subject_id"),
                            rs.getInt("created_by"),
                            rs.getString("title"),
                            rs.getString("description"),
                            rs.getTimestamp("created_at"),
                            rs.getTimestamp("modified_at"),
                            rs.getInt("modified_by")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Lesson> getAllLessons() {
        List<Lesson> lessons = new ArrayList<>();
        String sql = "SELECT * FROM lesson ORDER BY created_at DESC";

        try (PreparedStatement stmt = DatabaseConnector.getConnection().prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Lesson lesson = new Lesson(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getInt("created_by"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("modified_at"),
                        rs.getInt("modified_by")
                );
                lessons.add(lesson);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lessons;
    }

    public List<Lesson> getLessonsByTitle(String textSearch) {
        List<Lesson> lessons = new ArrayList<>();
        String sql = "SELECT * FROM lesson WHERE title LIKE ? ORDER BY created_at DESC";

        try (PreparedStatement stmt = DatabaseConnector.getConnection().prepareStatement(sql)) {
            stmt.setString(1, "%" + textSearch + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Lesson lesson = new Lesson(
                            rs.getInt("id"),
                            rs.getInt("subject_id"),
                            rs.getInt("created_by"),
                            rs.getString("title"),
                            rs.getString("description"),
                            rs.getTimestamp("created_at"),
                            rs.getTimestamp("modified_at"),
                            rs.getInt("modified_by")
                    );
                    lessons.add(lesson);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lessons;
    }

    public List<Lesson> findAllLessonsInSubject(int subjectId){
        List<Lesson> lessons = new ArrayList<>();
        String query = "SELECT * FROM lesson WHERE subject_id = ?";

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, subjectId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Lesson lesson = new Lesson(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getInt("created_by"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("modified_at"),
                        rs.getInt("modified_by")
                );
                lessons.add(lesson);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lessons;
    }

    @Override
    public Lesson findById(int id) {

        Connection conn = DatabaseConnector.getConnection();

        String sql = "SELECT * FROM lesson WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Lesson(
                            rs.getInt("id"),
                            rs.getInt("subject_id"),
                            rs.getInt("created_by"),
                            rs.getString("title"),
                            rs.getString("description"),
                            rs.getTimestamp("created_at"),
                            rs.getTimestamp("modified_at"),
                            rs.getInt("modified_by")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Lesson> findAll() {
        List<Lesson> lessons = new ArrayList<>();
        String sql = "SELECT * FROM lesson";

        try {
            Statement stmt = getConnection().createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                lessons.add(new Lesson(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getInt("created_by"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("modified_at"),
                        rs.getInt("modified_by")
                ));
            }

        } catch (SQLException e) {
            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
        }

        return lessons;
    }

    public static void main(String[] args) {
        LessonDAO dao = new LessonDAO();
        List<Lesson> lessons = dao.findAll();
        for (Lesson lesson : lessons) {
            System.out.println(lesson.toString());
        }
    }
}
