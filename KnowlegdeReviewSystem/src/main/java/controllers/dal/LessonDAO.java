/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import services.DatabaseConnector;
import models.Lesson;

public class LessonDAO extends DatabaseConnector {

    private Connection conn;

    public LessonDAO() {
        conn = getConnection();
    }

    public boolean addLesson(int userId, int subjectId, String lessonName, String description) {
        String sql = "INSERT INTO lesson (subject_id, created_by, title, description, created_at) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Lesson getLessonById(int id) {
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
                            rs.getString("video_url"),
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

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Lesson lesson = new Lesson(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getInt("created_by"),
                        rs.getString("title"),
                        rs.getString("video_url"),
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

    public static void main(String[] args) {
        LessonDAO lessonDAO = new LessonDAO();
        boolean added = lessonDAO.addLesson(1, 2, "Java Basics", "Introduction to Java");
        System.out.println("Thêm bài học mới: " + (added ? "Thành công" : "Thất bại"));

        List<Lesson> lessonList = lessonDAO.getAllLessons();

        for (Lesson lesson : lessonList) {
            System.out.println(lesson.getId());
        }
    }

    public List<Lesson> getLessonsByTitle(String textSearch) {
    List<Lesson> lessons = new ArrayList<>();
    String sql = "SELECT * FROM lesson WHERE title LIKE ? ORDER BY created_at DESC";

    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, "%" + textSearch + "%");

        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Lesson lesson = new Lesson(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getInt("created_by"),
                        rs.getString("title"),
                        rs.getString("video_url"),
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


}
