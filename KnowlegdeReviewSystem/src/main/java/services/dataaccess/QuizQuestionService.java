package services.dataaccess;

import models.QuizQuestion;
import models.dao.QuizQuestionDAO;

import java.util.List;

public class QuizQuestionService {
    private QuizQuestionDAO quizQuestionDAO;

    public QuizQuestionService() {
        this.quizQuestionDAO = new QuizQuestionDAO();
    }

    public List<QuizQuestion> findByQuizId(int quizId){
        return quizQuestionDAO.findByQuizId(quizId);
    }
}
