package models.dao;

import models.Answer;
import models.DAO;
import services.DatabaseConnector;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class AnswerDAO extends DatabaseConnector implements DAO<Answer> {

    @Override
    public void create(Answer answer) {
        try {
            String sql = "INSERT INTO answer_option (question_id, content, is_answer) VALUES (?, ?, ?)";
            PreparedStatement preparedStatement = getConnection().prepareStatement(sql);
            preparedStatement.setInt(1, answer.getQuestionId());
            preparedStatement.setString(2, answer.getContent());
            preparedStatement.setBoolean(3, answer.isAnswer());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void update(Answer answer) {
        try {
            String sql = "UPDATE answer_option SET content = ?, is_answer = ? WHERE id = ?";
            PreparedStatement preparedStatement = getConnection().prepareStatement(sql);
            preparedStatement.setString(1, answer.getContent());
            preparedStatement.setBoolean(2, answer.isAnswer());
            preparedStatement.setInt(3, answer.getId());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void delete(Answer answer) {
        try {
            String sql = "DELETE FROM answer_option WHERE id = ?";
            PreparedStatement preparedStatement = getConnection().prepareStatement(sql);
            preparedStatement.setInt(1, answer.getId());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Answer findById(int id) {
        Answer answer = null;
        try {
            String sql = "SELECT * FROM answer_option WHERE id = ?";
            PreparedStatement preparedStatement = getConnection().prepareStatement(sql);
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                answer = new Answer(
                        resultSet.getInt("id"),
                        resultSet.getInt("question_id"),
                        resultSet.getString("content"),
                        resultSet.getBoolean("is_answer")
                );
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return answer;
    }

    @Override
    public List<Answer> findAll() {
        List<Answer> answers = new ArrayList<>();
        try {
            String sql = "SELECT * FROM answer_option";
            Statement statement = getConnection().createStatement();
            ResultSet resultSet = statement.executeQuery(sql);
            while (resultSet.next()) {
                answers.add(new Answer(
                        resultSet.getInt("id"),
                        resultSet.getInt("question_id"),
                        resultSet.getString("content"),
                        resultSet.getBoolean("is_answer")
                ));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return answers;
    }

    public List<Answer> findAnswersByQuestionId(int questionId) {
        List<Answer> answers = new ArrayList<>();
        try {
            String sql = "SELECT * FROM answer_option WHERE question_id = ?";
            PreparedStatement preparedStatement = getConnection().prepareStatement(sql);
            preparedStatement.setInt(1, questionId);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                answers.add(new Answer(
                        resultSet.getInt("id"),
                        resultSet.getInt("question_id"),
                        resultSet.getString("content"),
                        resultSet.getBoolean("is_answer")
                ));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return answers;
    }

    public static void main(String[] args) {
        AnswerDAO dao = new AnswerDAO();

        // Example Usage
        // Create
         Answer newAnswer = new Answer(0, 1, "Answer Content", true);
         dao.create(newAnswer);

        // Update
        // Answer updateAnswer = new Answer(1, 1, "Updated Content", false);
        // dao.update(updateAnswer);

        // Delete
        // Answer deleteAnswer = new Answer(1, 0, "Delete me", false);
        // dao.delete(deleteAnswer);

        // Find By Id
        // Answer foundAnswer = dao.findById(1);
        // System.out.println(foundAnswer);

        // Find All
         List<Answer> allAnswers = dao.findAll();
         System.out.println(allAnswers);

        // Find by Question Id
        // List<Answer> questionAnswers = dao.findAnswersByQuestionId(1);
        // System.out.println(questionAnswers);
    }
}