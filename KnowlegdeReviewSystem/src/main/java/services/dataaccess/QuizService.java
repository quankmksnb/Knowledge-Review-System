package services.dataaccess;

import models.Question;
import models.Quiz;
import models.dao.QuizDAO;

import java.util.List;

public class QuizService {
    private QuizDAO quizDAO;

    public QuizService() {
        this.quizDAO = new QuizDAO();
    }

    public int create(Quiz quiz) {
        return quizDAO.create(quiz);
    }

    public void update(Quiz quiz) {
        quizDAO.update(quiz);
    }

    public void delete(Quiz quiz) {
        quizDAO.delete(quiz);
    }

    public Quiz findById(int id) {
        return quizDAO.findById(id);
    }

    public List<Quiz> findAll() {
        return quizDAO.findAll();
    }

    public List<Quiz> findByUserId(int userId) {
        return quizDAO.findByUserId(userId);
    }

    public void addQuizLesson(int quizId, int lessonId) {
        quizDAO.addQuizLesson(quizId, lessonId);
    }

    public void addQuizQuestion(int quizId, int userId, int questionId) {
        quizDAO.addQuizQuestion(quizId, userId, questionId);
    }

    public List<Question> getQuestionsByLessonId(int lessonId) {
        return quizDAO.getQuestionsByLessonId(lessonId);
    }

    public void updateQuizLesson(int quizId, int lessonId) {
        quizDAO.updateQuizLesson(quizId, lessonId);
    }

    public void deleteQuizQuestions(int quizId) {
        quizDAO.deleteQuizQuestions(quizId);
    }

    public List<Quiz> filterQuizzes(int userId, Integer subjectId, Integer lessonId, String status, String quizName) {
        return quizDAO.filterQuizzes(userId, subjectId, lessonId, status, quizName);
    }
}
