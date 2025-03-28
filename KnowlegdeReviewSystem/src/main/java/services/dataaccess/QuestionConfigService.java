package services.dataaccess;

import models.dao.AnswerOptionDAO;
import models.dao.QuestionConfigDAO;

public class QuestionConfigService {
    private QuestionConfigDAO questionConfigDAO;

    public QuestionConfigService() {
        this.questionConfigDAO = new QuestionConfigDAO();
    }

    public int create (int questionId, int configId) throws Exception {
        return questionConfigDAO.create(questionId, configId);
    }
    public int deleteByQuestionId(int questionId) throws Exception{
        return questionConfigDAO.deleteByQuestionId(questionId);
    }
}
