package models.dao;

import models.*;
import services.DatabaseConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizDAO extends DatabaseConnector implements DAO<Quiz> {
    @Override
    public int create(Quiz quiz) {
        // Câu lệnh SQL để chèn dữ liệu vào bảng quiz
        String sql = "INSERT INTO quiz (subject_id, user_id, num_of_question, status, created_at, quiz_name) VALUES (?, ?, ?, ?, now(), ?)";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, quiz.getSubjectId());
            stmt.setInt(2, quiz.getUserId());
            stmt.setInt(3, quiz.getNumOfQuestions());
            stmt.setString(4, quiz.getStatus().toString());
            stmt.setString(5, quiz.getQuizName());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);  // Lấy quiz_id vừa tạo
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    @Override
    public void update(Quiz quiz) {
        // Cập nhật bảng quiz
        String sql = "UPDATE quiz SET quiz_name = ?, subject_id = ?, user_id = ?, modified_at = NOW(), status = ?, num_of_question = ?  WHERE id = ?";
        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, quiz.getQuizName());
            ps.setInt(2, quiz.getSubjectId());
            ps.setInt(3, quiz.getUserId());
            ps.setString(4, quiz.getStatus().toString());
            ps.setInt(5, quiz.getNumOfQuestions());
            ps.setInt(6, quiz.getId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(Quiz quiz) {
        String sql = "DELETE FROM quiz WHERE id = ?";
        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, quiz.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Quiz findById(int id) {
        Quiz quiz = null;
        String sql = "SELECT * FROM quiz WHERE id = ?";
        Connection connection = DatabaseConnector.getConnection();
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setQuizName(rs.getString("quiz_name"));
                quiz.setSubjectId(rs.getInt("subject_id"));
                quiz.setUserId(rs.getInt("user_id"));
                quiz.setNumOfQuestions(rs.getInt("num_of_question"));
                quiz.setStatus(QuizStatus.valueOf(rs.getString("status")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return quiz;
    }

    @Override
    public List<Quiz> findAll() {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM quiz ORDER BY created_at DESC";
        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setQuizName(rs.getString("quiz_name"));
                quiz.setSubjectId(rs.getInt("subject_id"));
                quiz.setUserId(rs.getInt("user_id"));
                quiz.setStatus(QuizStatus.valueOf(rs.getString("status")));
                quiz.setCreatedAt(rs.getDate("created_at"));
                quiz.setModifiedAt(rs.getDate("modified_at"));
                quizzes.add(quiz);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quizzes;
    }

    // Phương thức để lấy quiz do userId tạo
    public List<Quiz> findByUserId(int userId) {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM quiz WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setQuizName(rs.getString("quiz_name"));
                quiz.setSubjectId(rs.getInt("subject_id"));
                quiz.setUserId(rs.getInt("user_id"));
                quiz.setStatus(QuizStatus.valueOf(rs.getString("status")));
                quiz.setCreatedAt(rs.getDate("created_at"));
                quiz.setModifiedAt(rs.getDate("modified_at"));
                quiz.setNumOfQuestions(rs.getInt("num_of_question"));
                quizzes.add(quiz);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quizzes;
    }


    public void addQuizLesson(int quizId, int lessonId) {
        String sql = "INSERT INTO quiz_lesson (quiz_id, lesson_id) VALUES (?, ?)";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quizId);
            stmt.setInt(2, lessonId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void addQuizQuestion(int quizId, int userId, int questionId) {
        String sql = "INSERT INTO quiz_question (quiz_id, user_id, question_id) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quizId);
            stmt.setInt(2, userId);
            stmt.setInt(3, questionId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Question> getQuestionsByLessonId(int lessonId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM question WHERE lesson_id = ? && status='active'";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, lessonId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Question question = new Question();
                question.setId(rs.getInt("id"));
                question.setContent(rs.getString("content"));
                questions.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }

    public void updateQuizLesson(int quizId, int lessonId) {
        String sql = "UPDATE quiz_lesson SET lesson_id = ? WHERE quiz_id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, lessonId);
            stmt.setInt(2, quizId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteQuizQuestions(int quizId) {
        String sql = "DELETE FROM quiz_question WHERE quiz_id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quizId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Quiz> filterQuizzes(int userId, Integer subjectId, Integer lessonId, String status, String quizName) {
        List<Quiz> quizzes = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM quiz WHERE user_id = ?");

        // Thêm điều kiện vào SQL nếu có các tham số lọc
        if (subjectId != null) {
            sql.append(" AND subject_id = ?");
        }
        if (lessonId != null) {
            sql.append(" AND id IN (SELECT quiz_id FROM quiz_lesson WHERE lesson_id = ?)");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
        }
        if (quizName != null && !quizName.isEmpty()) {
            sql.append(" AND quiz_name LIKE ?");
        }

        try (Connection connection = DatabaseConnector.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            // Set tham số mặc định cho user_id
            ps.setInt(1, userId);

            int index = 2; // Thực hiện set cho các tham số còn lại

            if (subjectId != null) {
                ps.setInt(index++, subjectId);
            }
            if (lessonId != null) {
                ps.setInt(index++, lessonId);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }
            if (quizName != null && !quizName.isEmpty()) {
                ps.setString(index++, "%" + quizName + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setQuizName(rs.getString("quiz_name"));
                quiz.setSubjectId(rs.getInt("subject_id"));
                quiz.setUserId(rs.getInt("user_id"));
                quiz.setStatus(QuizStatus.valueOf(rs.getString("status")));
                quiz.setNumOfQuestions(rs.getInt("num_of_question"));
                quizzes.add(quiz);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return quizzes;
    }


}
