package models.dao;

import models.AnswerOption;
import models.DAO;
import models.Question;
import services.DatabaseConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class QuestionDAO extends DatabaseConnector implements DAO<Question> {

    private final AnswerOptionDAO answerDAO;
    private static final Logger LOGGER = Logger.getLogger(QuestionDAO.class.getName());

    public QuestionDAO() {
        this.answerDAO = new AnswerOptionDAO();
    }

    @Override
    public int create(Question question) {
        int generatedId = 0;
        String sql = "INSERT INTO question (subject_id, lesson_id, content, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, question.getSubjectId());
            stmt.setInt(2, question.getLessonId());
            stmt.setString(3, question.getContent());
            stmt.setString(4, question.getStatus());
            int rowsInserted = stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
            throw new RuntimeException(e);
        }
        return generatedId;
    }

    @Override
    public void update(Question question) {
        String sql = "UPDATE question SET subject_id = ?, lesson_id = ?, content = ? WHERE id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, question.getSubjectId());
            stmt.setInt(2, question.getLessonId());
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
        String sql = "SELECT q.id, q.content, q.status, q.lesson_id, q.subject_id, c.description " +
                "FROM question q " +
                "LEFT JOIN question_config qc ON q.id = qc.question_id " +
                "LEFT JOIN config c ON qc.config_id = c.id " +
                "WHERE q.id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Question question = new Question(
                            rs.getInt("id"),
                            rs.getInt("subject_id"),
                            rs.getInt("lesson_id"),
                            rs.getString("content"),
                            rs.getString("status"),
                            rs.getString("description")
                    );
                    // Fetch answer options
                    List<AnswerOption> options = answerDAO.findAnswersByQuestionId(question.getId());
                    question.setOptions(options);
                    return question;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding question with ID " + id + ": " + e.getMessage(), e);
            throw new RuntimeException("Failed to find question in the database", e);
        }
        return null;
    }

    @Override
    public List<Question> findAll() {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT q.id, q.content, q.status, q.lesson_id, q.subject_id, c.description " +
                "FROM question q " +
                "LEFT JOIN question_config qc ON q.id = qc.question_id " +
                "LEFT JOIN config c ON qc.config_id = c.id";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Question question = new Question(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getInt("lesson_id"),
                        rs.getString("content"),
                        rs.getString("status"),
                        rs.getString("description")
                );
                // Fetch answer options
                List<AnswerOption> options = answerDAO.findAnswersByQuestionId(question.getId());
                question.setOptions(options);
                questions.add(question);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all questions: " + e.getMessage(), e);
            throw new RuntimeException("Failed to retrieve questions from the database", e);
        }
        return questions;
    }

    public List<Question> findBySubjectId(int subjectId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT q.id, q.content, q.status, q.lesson_id, q.subject_id, c.description " +
                "FROM question q " +
                "LEFT JOIN question_config qc ON q.id = qc.question_id " +
                "LEFT JOIN config c ON qc.config_id = c.id " +
                "WHERE q.subject_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, subjectId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Question question = new Question(
                            rs.getInt("id"),
                            rs.getInt("subject_id"),
                            rs.getInt("lesson_id"),
                            rs.getString("content"),
                            rs.getString("status"),
                            rs.getString("description")
                    );

                    //System.out.println(question.getId() + " " + question.getDomain());

                    // Fetch answer options
                    List<AnswerOption> options = answerDAO.findAnswersByQuestionId(question.getId());
                    question.setOptions(options);
                    questions.add(question);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding questions for subject ID " + subjectId + ": " + e.getMessage(), e);
            throw new RuntimeException("Failed to retrieve questions for subject ID " + subjectId, e);
        }
        return questions;
    }

    public List<Question> findByLessonId(int lessonId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT q.id, q.content, q.status, q.lesson_id, q.subject_id, c.description " +
                "FROM question q " +
                "LEFT JOIN question_config qc ON q.id = qc.question_id " +
                "LEFT JOIN config c ON qc.config_id = c.id " +
                "WHERE q.lesson_id = ? && q.status = 'active'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, lessonId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Question question = new Question(
                            rs.getInt("id"),
                            rs.getInt("subject_id"),
                            rs.getInt("lesson_id"),
                            rs.getString("content"),
                            rs.getString("status"),
                            rs.getString("description")
                    );
                    // Fetch answer options
                    List<AnswerOption> options = answerDAO.findAnswersByQuestionId(question.getId());
                    question.setOptions(options);
                    questions.add(question);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding questions for lesson ID " + lessonId + ": " + e.getMessage(), e);
            throw new RuntimeException("Failed to retrieve questions for lesson ID " + lessonId, e);
        }
        return questions;
    }

    public Map<Integer, Question> findByIds(List<Integer> ids) {
        Map<Integer, Question> questionMap = new HashMap<>();
        if (ids == null || ids.isEmpty()) {
            return questionMap;
        }

        String placeholders = String.join(",", ids.stream().map(id -> "?").toArray(String[]::new));
        String sql = "SELECT * FROM question WHERE id IN (" + placeholders + ")";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < ids.size(); i++) {
                stmt.setInt(i + 1, ids.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Question question = new Question();
                    question.setId(rs.getInt("id"));
                    question.setContent(rs.getString("content"));
                    // Fetch answer options
                    List<AnswerOption> options = answerDAO.findAnswersByQuestionId(question.getId());
                    question.setOptions(options);
                    questionMap.put(question.getId(), question);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questionMap;
    }

    public List<Question> findByQuestionsByContent(String content) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT q.id , q.content , c.description, q.status, q.lesson_id, q.subject_id FROM question q LEFT JOIN question_config qc ON q.id = qc.question_id LEFT JOIN config c ON qc.config_id = c.id WHERE q.content like '%" + content + "%'";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                questions.add(new Question(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getInt("lesson_id"),
                        rs.getString("content"),
                        rs.getString("status"),
                        rs.getString("description")
                ));
            }
        } catch (SQLException e) {
            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return questions;
    }

    public boolean changeStatus(int id, String status) {
        String sql = "UPDATE question SET status = ? WHERE id = ?";

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, id);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }
    }

    public static void main(String[] args) {
        QuestionDAO dao = new QuestionDAO();
        System.out.println(dao.findByQuestionsByContent("kera").size());
    }
//
//    public Map<Integer, Question> findByIds(List<Integer> ids) {
//        Map<Integer, Question> questionMap = new HashMap<>();
//        if (ids == null || ids.isEmpty()) {
//            return questionMap;
//        }
//
//        String placeholders = String.join(",", ids.stream().map(id -> "?").toArray(String[]::new));
//        String sql = "SELECT * FROM question WHERE id IN (" + placeholders + ")";
//
//        try (Connection conn = getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            for (int i = 0; i < ids.size(); i++) {
//                stmt.setInt(i + 1, ids.get(i));
//            }
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    Question question = new Question();
//                    question.setId(rs.getInt("id"));
//                    question.setContent(rs.getString("content"));
//
//                    List<AnswerOption> options = answerDAO.findAnswersByQuestionId(question.getId());
//                    question.setOptions(options);
//                    questionMap.put(question.getId(), question);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return questionMap;
//    }
}
