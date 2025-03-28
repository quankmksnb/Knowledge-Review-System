package services.dataaccess;

import models.QuizAnswer;
import models.dao.AnswerOptionDAO;
import models.dao.QuizAnswerDAO;

import java.util.List;

public class QuizAnswerService {
    private QuizAnswerDAO quizAnswerDAO;

    public QuizAnswerService() {
        this.quizAnswerDAO = new QuizAnswerDAO();
    }

    public void create(QuizAnswer quizAnswer) {
        quizAnswerDAO.create(quizAnswer);
    }

    public List<QuizAnswer> findByQuizIdAndUserId(int quizId, int userId) {
        return quizAnswerDAO.findByQuizIdAndUserId(quizId, userId);
    }
}
