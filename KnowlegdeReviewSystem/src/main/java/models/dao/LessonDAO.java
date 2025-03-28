package models.dao;

import models.DAO;
import models.Lesson;
import services.DatabaseConnector;

import java.sql.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LessonDAO extends DatabaseConnector implements DAO<Lesson> {

    @Override
    public int create(Lesson lesson) {
        return 0;
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

        try (PreparedStatement stmt = DatabaseConnector.getConnection().prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
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

    public List<Lesson> findAllLessonsInSubject(int subjectId) {
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
                        rs.getString("video_url"),
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

    public String getLessonTitleByQuizId(int quizId) {
        String title = null;
        String sql = "SELECT l.title " +
                "FROM quiz_lesson ql " +
                "JOIN lesson l ON ql.lesson_id = l.id " +
                "WHERE ql.quiz_id = ?";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                title = rs.getString("title");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return title != null ? title : "Unknown";
    }

    public List<Lesson> getLessonsByEnrolledSubjects(List<Integer> enrolledSubjectIds) {
        List<Lesson> lessons = new ArrayList<>();

        if (enrolledSubjectIds.isEmpty()) {
            return lessons;  // Nếu không có subjectId nào thì trả về danh sách rỗng
        }

        // Truy vấn để lấy danh sách các bài học từ các subject mà user đã enroll
        String sql = "SELECT * FROM lesson WHERE subject_id IN (" +
                String.join(",", Collections.nCopies(enrolledSubjectIds.size(), "?")) + ")";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            // Đặt giá trị của các subject_id vào prepared statement
            for (int i = 0; i < enrolledSubjectIds.size(); i++) {
                ps.setInt(i + 1, enrolledSubjectIds.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Tạo đối tượng lesson từ kết quả truy vấn
                Lesson lesson = new Lesson();
                lesson.setId(rs.getInt("id"));
                lesson.setSubjectId(rs.getInt("subject_id"));
                lesson.setCreatedBy(rs.getInt("created_by"));
                lesson.setTitle(rs.getString("title"));
                lesson.setVideoUrl(rs.getString("video_url"));
                lesson.setDescription(rs.getString("description"));
                lesson.setCreatedAt(rs.getTimestamp("created_at"));
                lesson.setModifiedAt(rs.getTimestamp("modified_at"));
                lesson.setModifiedBy(rs.getInt("modified_by"));

                lessons.add(lesson);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lessons;
    }

    public List<Lesson> getLessonsBySubject(int subjectId) {
        List<Lesson> lessons = new ArrayList<>();
        String sql = "SELECT * FROM lesson WHERE subject_id = ?";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, subjectId);
            ResultSet rs = ps.executeQuery();

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

    public int getQuestionCountByLessonId(int lessonId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM question WHERE lesson_id = ? && status='active'";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);  // Lấy số câu hỏi
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return count;
    }

    public int getLessonIdByQuizId(int quizId) {
        int lessonId = -1; // Mặc định trả về -1 nếu không tìm thấy lesson

        String sql = "SELECT lesson_id FROM quiz_lesson WHERE quiz_id = ?";

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                lessonId = rs.getInt("lesson_id"); // Lấy lessonId từ bảng quiz_lesson
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lessonId;
    }

    public List<Lesson> getLessonsByUserId(int userId) {
        List<Lesson> lessons = new ArrayList<>();
        String sql = "SELECT * FROM lesson WHERE created_by = ? ORDER BY created_at DESC"; // Giả sử `created_by` là userId

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

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

    public List<Lesson> getLessonsBySubjectId(int subjectId) {
        List<Lesson> lessons = new ArrayList<>();
        Connection connection = DatabaseConnector.getConnection();
        String sql = "SELECT * FROM lesson WHERE subject_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, subjectId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Lesson lesson = new Lesson();
                lesson.setId(rs.getInt("id"));
                lesson.setTitle(rs.getString("title"));
                lesson.setSubjectId(rs.getInt("subject_id"));
                // Thêm các trường khác nếu có
                lessons.add(lesson);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lessons;
    }

    public String getChapterNameByLessonId(int lessonId) {
        String chapterName = null;

        String sql = "SELECT c.description " +
                "FROM config c " +
                "JOIN lesson_config lc ON c.id = lc.config_id " +
                "JOIN setting s ON c.type_id = s.id " +
                "WHERE lc.lesson_id = ? AND s.title = 'Chapter' AND s.type = 'Config' " +
                "LIMIT 1";

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, lessonId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                chapterName = rs.getString("description");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return chapterName != null ? chapterName : "N/A";
    }

    public boolean updateLessonChapter(int lessonId, int chapterId) {
        // Kiểm tra xem lesson đã có chapter hay chưa
        String checkSql = "SELECT * FROM lesson_config WHERE lesson_id = ?";
        try (PreparedStatement stmt = DatabaseConnector.getConnection().prepareStatement(checkSql)) {
            stmt.setInt(1, lessonId);
            ResultSet rs = stmt.executeQuery();

            // Nếu đã có liên kết, thì update, nếu không có thì insert
            if (rs.next()) {
                String updateSql = "UPDATE lesson_config SET config_id = ? WHERE lesson_id = ?";
                try (PreparedStatement updateStmt = DatabaseConnector.getConnection().prepareStatement(updateSql)) {
                    updateStmt.setInt(1, chapterId);
                    updateStmt.setInt(2, lessonId);
                    return updateStmt.executeUpdate() > 0;
                }
            } else {
                String insertSql = "INSERT INTO lesson_config (lesson_id, config_id) VALUES (?, ?)";
                try (PreparedStatement insertStmt = DatabaseConnector.getConnection().prepareStatement(insertSql)) {
                    insertStmt.setInt(1, lessonId);
                    insertStmt.setInt(2, chapterId);
                    return insertStmt.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateLessonWithChapter(int lessonId,  int subjectId, String lessonName, String description, int chapterId, String videoUrl) {
        // Cập nhật thông tin bài học
        String sqlUpdateLesson = "UPDATE lesson SET title = ?, description = ?, modified_at = ?, video_url = ? WHERE id = ?";
        try (PreparedStatement stmt = DatabaseConnector.getConnection().prepareStatement(sqlUpdateLesson)) {
            stmt.setString(1, lessonName);
            stmt.setString(2, description);
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            stmt.setString(4, videoUrl);
            stmt.setInt(5, lessonId);
            int updateCount = stmt.executeUpdate();

            // Nếu cập nhật bài học thành công, cập nhật chapter cho lesson
            if (updateCount > 0) {
                return updateLessonChapter(lessonId, chapterId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addLesson1(String title, String description, String videoUrl, int subjectId, int chapterId, int createdBy) {
        String sql = "INSERT INTO lesson (title, description, video_url, subject_id, created_by) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, title);
            stmt.setString(2, description);
            stmt.setString(3, videoUrl);
            stmt.setInt(4, subjectId);
            stmt.setInt(5, createdBy);

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int lessonId = generatedKeys.getInt(1);

                    String lessonConfigSql = "INSERT INTO lesson_config (lesson_id, config_id) VALUES (?, ?)";
                    try (PreparedStatement stmtLessonConfig = conn.prepareStatement(lessonConfigSql)) {
                        stmtLessonConfig.setInt(1, lessonId);
                        stmtLessonConfig.setInt(2, chapterId);
                        stmtLessonConfig.executeUpdate();
                    }

                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
