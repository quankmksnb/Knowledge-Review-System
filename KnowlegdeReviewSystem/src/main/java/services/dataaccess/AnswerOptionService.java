package services.dataaccess;

import models.AnswerOption;
import models.dao.AnswerOptionDAO;
import models.dao.LessonDAO;

import java.util.List;

public class AnswerOptionService {
    private AnswerOptionDAO answerOptionDAO;

    public AnswerOptionService() {
        this.answerOptionDAO = new AnswerOptionDAO();
    }

    public int create(AnswerOption answer) {
        return answerOptionDAO.create(answer);
    }

    public void update(AnswerOption answer) {
        answerOptionDAO.update(answer);
    }

    public void delete(AnswerOption answer) {
        answerOptionDAO.delete(answer);
    }

    public AnswerOption findById(int id) {
        return answerOptionDAO.findById(id);
    }

    public List<AnswerOption> findAll() {
        return answerOptionDAO.findAll();
    }

    public List<AnswerOption> findAnswersByQuestionId(int questionId) {
        return answerOptionDAO.findAnswersByQuestionId(questionId);
    }

    public void deleteByQuestionId(int questionId) {
        answerOptionDAO.deleteByQuestionId(questionId);
    }
}
