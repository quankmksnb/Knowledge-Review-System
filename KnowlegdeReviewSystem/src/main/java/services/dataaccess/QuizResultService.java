package services.dataaccess;

import models.QuizResult;
import models.dao.QuizResultDAO;

public class QuizResultService {
    private QuizResultDAO quizResultDAO;

    public QuizResultService() {
        this.quizResultDAO = new QuizResultDAO();
    }

    public void create(QuizResult quizResult) {
        quizResultDAO.create(quizResult);
    }

    public QuizResult findByQuizIdAndUserId(int quizId, int userId) {
        return quizResultDAO.findByQuizIdAndUserId(quizId, userId);
    }
}
