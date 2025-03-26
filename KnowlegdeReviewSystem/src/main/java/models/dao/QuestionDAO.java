//package models.dao;
//
//import models.DAO;
//import models.Question;
//import models.AnswerOption;
//import services.DatabaseConnector;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//
//public class QuestionDAO extends DatabaseConnector implements DAO<Question> {
//
//    private final AnswerOptionDAO answerDAO;
//
//    public QuestionDAO() {
//        this.answerDAO = new AnswerOptionDAO();
//    }
//
//    @Override
//    public int create(Question question) {
//        int generatedId = 0;
//        String sql = "INSERT INTO question (subject_id, lesson_id, content, status) VALUES (?, ?, ?, ?)";
//        try (Connection conn = DatabaseConnector.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//
//            stmt.setInt(1, question.getSubjectId());
//            stmt.setInt(2, question.getLessonId()); // Fixed method name
//            stmt.setString(3, question.getContent());
//            stmt.setString(4, question.getStatus());
//            int rowsInserted = stmt.executeUpdate();
//            try (ResultSet rs = stmt.getGeneratedKeys()) {
//                if (rs.next()) {
//                    generatedId = rs.getInt(1);
//                }
//            }
//        } catch (SQLException e) {
//            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
//            throw new RuntimeException(e);
//        }
//        return generatedId;
//    }
//
//    @Override
//    public void update(Question question) {
//        String sql = "UPDATE question SET subject_id = ?, lesson_id = ?, content = ?, status = ? WHERE id = ?";
//        try (Connection conn = DatabaseConnector.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setInt(1, question.getSubjectId());
//            stmt.setInt(2, question.getLessonId()); // Fixed method name
//            stmt.setString(3, question.getContent());
//            stmt.setString(4, question.getStatus());
//            stmt.setInt(5, question.getId());
//
//            stmt.executeUpdate();
//        } catch (SQLException e) {
//            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
//            throw new RuntimeException(e);
//        }
//    }
//
//    @Override
//    public void delete(Question question) {
//        String sql = "DELETE FROM question WHERE id = ?";
//        try (Connection conn = DatabaseConnector.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setInt(1, question.getId());
//            stmt.executeUpdate();
//        } catch (SQLException e) {
//            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
//            throw new RuntimeException(e);
//        }
//    }
//
//    @Override
//    public Question findById(int id) {
//        String sql = "SELECT q.id , q.content , c.description, q.status, q.lesson_id, q.subject_id FROM question q LEFT JOIN question_config qc ON q.id = qc.question_id LEFT JOIN config c ON qc.config_id = c.id WHERE q.id = " + id;
//
//        try (Connection conn = DatabaseConnector.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setInt(1, id);
//            try (ResultSet rs = stmt.executeQuery()) {
//                if (rs.next()) {
//                    Question question = new Question(
//                            rs.getInt("id"),
//                            rs.getInt("subject_id"),
//                            rs.getInt("lesson_id"),
//                            rs.getString("content"),
//                            rs.getString("status")
//                    );
//                    // Fetch answer options
//                    List<AnswerOption> options = answerDAO.findAnswersByQuestionId(question.getId());
//                    question.setOptions(options);
//                    return question;
//                }
//            }
//        } catch (SQLException e) {
//            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
//            throw new RuntimeException(e);
//        }
//        return null;
//    }
//
//    @Override
//    public List<Question> findAll() {
//        List<Question> questions = new ArrayList<>();
//        String sql = "SELECT \n" +
//                "    q.id , \n" +
//                "    q.content ,\n" +
//                "    c.id, \n" +
//                "    c.description,\n" +
//                "    s.title\n" +
//                "FROM \n" +
//                "    question q\n" +
//                "LEFT JOIN \n" +
//                "    question_domain qd ON q.id = qd.question_id\n" +
//                "LEFT JOIN \n" +
//                "    config c ON qd.domain_id = c.id\n" +
//                "LEFT JOIN\n" +
//                "setting s ON c.type_id = s.id\n";
//
//        try (Connection conn = DatabaseConnector.getConnection();
//             Statement stmt = conn.createStatement();
//             ResultSet rs = stmt.executeQuery(sql)) {
//
//            while (rs.next()) {
//                Question question = new Question(
//                        rs.getInt("id"),
//                        rs.getInt("subject_id"),
//                        rs.getInt("lesson_id"),
//                        rs.getString("content"),
//                        rs.getString("status")
//                );
//                // Fetch answer options
//                List<AnswerOption> options = answerDAO.findAnswersByQuestionId(question.getId());
//                question.setOptions(options);
//                questions.add(question);
//            }
//        } catch (SQLException e) {
//            Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
//            throw new RuntimeException(e);
//        }
//        return questions;
//    }
//
//    public List<Question> findBySubjectId(int subjectId) {
//        List<Question> questions = new ArrayList<>();
//        String sql = "SELECT q.id , q.content , c.description, q.status, q.lesson_id, q.subject_id FROM question q LEFT JOIN question_config qc ON q.id = qc.question_id LEFT JOIN config c ON qc.config_id = c.id WHERE q.subject_id = " + subjectId;
//        try (Connection conn = DatabaseConnector.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setInt(1, subjectId);
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    Question question = new Question(
//                            rs.getInt("id"),
//                            rs.getInt("subject_id"),
//                            rs.getInt("lesson_id"),
//                            rs.getString("content"),
//                            rs.getString("status"),
//                            rs.getString("description")
//                    );
//                    // Fetch answer options
//                    List<AnswerOption> options = answerDAO.findAnswersByQuestionId(question.getId());
//                    question.setOptions(options);
//                    questions.add(question);
//                }
//            } catch (SQLException e) {
//                Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
//                throw new RuntimeException(e);
//            }
//            return questions;
//        } catch (SQLException e) {
//            throw new RuntimeException(e);
//        }
//    }
//    public List<Question> findByLessonId(int lessonId) throws SQLException {
//        List<Question> questions = new ArrayList<>();
//        String sql = "SELECT \n" +
//                "    q.id , \n" +
//                "    q.content ,\n" +
//                "    c.id, \n" +
//                "    c.description,\n" +
//                "    s.title\n" +
//                "FROM \n" +
//                "    question q\n" +
//                "LEFT JOIN \n" +
//                "    question_domain qd ON q.id = qd.question_id\n" +
//                "LEFT JOIN \n" +
//                "    config c ON qd.domain_id = c.id\n" +
//                "LEFT JOIN\n" +
//                "    setting s ON c.type_id = s.id\n" +
//                "Where \n" +
//                "q.lesson_id = " + lessonId;
//        try (Connection conn = DatabaseConnector.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setInt(1, lessonId);
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    Question question = new Question(
//                            rs.getInt("id"),
//                            rs.getInt("subject_id"),
//                            rs.getInt("lesson_id"),
//                            rs.getString("content"),
//                            rs.getString("status"),
//                            rs.getString("description")
//                    );
//                    // Fetch answer options
//                    List<AnswerOption> options = answerDAO.findAnswersByQuestionId(question.getId());
//                    question.setOptions(options);
//                    questions.add(question);
//                }
//            } catch (SQLException e) {
//                Logger.getLogger(QuestionDAO.class.getName()).log(Level.SEVERE, null, e);
//                throw new RuntimeException(e);
//            }
//            return questions;
//        }
//    }
//}

package models.dao;

import models.DAO;
import models.Question;
import models.AnswerOption;
import services.DatabaseConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class QuestionDAO extends DatabaseConnector implements DAO<Question> {

    private static final Logger LOGGER = Logger.getLogger(QuestionDAO.class.getName());
    private final AnswerOptionDAO answerDAO;

    public QuestionDAO() {
        this.answerDAO = new AnswerOptionDAO();
    }

    @Override
    public int create(Question question) {
        if (question.getContent() == null || question.getContent().trim().isEmpty()) {
            throw new IllegalArgumentException("Question content cannot be null or empty");
        }
        if (question.getStatus() == null || question.getStatus().trim().isEmpty()) {
            throw new IllegalArgumentException("Question status cannot be null or empty");
        }

        String sql = "INSERT INTO question (subject_id, lesson_id, content, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, question.getSubjectId());
            stmt.setInt(2, question.getLessonId());
            stmt.setString(3, question.getContent());
            stmt.setString(4, question.getStatus());

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted == 0) {
                throw new SQLException("Creating question failed, no rows affected.");
            }

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new SQLException("Creating question failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating question: " + e.getMessage(), e);
            throw new RuntimeException("Failed to create question in the database", e);
        }
    }

    @Override
    public void update(Question question) {
        if (question.getContent() == null || question.getContent().trim().isEmpty()) {
            throw new IllegalArgumentException("Question content cannot be null or empty");
        }
        if (question.getStatus() == null || question.getStatus().trim().isEmpty()) {
            throw new IllegalArgumentException("Question status cannot be null or empty");
        }

        String sql = "UPDATE question SET subject_id = ?, lesson_id = ?, content = ?, status = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, question.getSubjectId());
            stmt.setInt(2, question.getLessonId());
            stmt.setString(3, question.getContent());
            stmt.setString(4, question.getStatus());
            stmt.setInt(5, question.getId());

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated == 0) {
                throw new SQLException("Updating question failed, no rows affected. Question ID: " + question.getId());
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating question with ID " + question.getId() + ": " + e.getMessage(), e);
            throw new RuntimeException("Failed to update question in the database", e);
        }
    }

    @Override
    public void delete(Question question) {
        String sql = "DELETE FROM question WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, question.getId());
            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted == 0) {
                LOGGER.log(Level.WARNING, "No question found with ID " + question.getId() + " to delete.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting question with ID " + question.getId() + ": " + e.getMessage(), e);
            throw new RuntimeException("Failed to delete question from the database", e);
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
                "WHERE q.lesson_id = ?";
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
}