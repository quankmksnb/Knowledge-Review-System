package services.dataaccess;

import models.Question;
import models.dao.AnswerOptionDAO;
import models.dao.QuestionDAO;

import java.util.List;
import java.util.Map;

public class QuestionService {
    private QuestionDAO questionDAO;

    public QuestionService() {
        this.questionDAO = new QuestionDAO();
    }

    public int create(Question question) {
        return questionDAO.create(question);
    }

    public void update(Question question) {
        questionDAO.update(question);
    }

    public void delete(Question question) {
        questionDAO.delete(question);
    }

    public void changeStatus(int questionId, String status) {
        questionDAO.changeStatus(questionId, status);
    }

    public List<Question> findByQuestionContent(String content) {
        return questionDAO.findByQuestionsByContent(content);
    }

    public Question findById(int id) {
        return questionDAO.findById(id);
    }

    public List<Question> findAll() {
        return questionDAO.findAll();
    }

    public List<Question> findBySubjectId(int subjectId) {
        return questionDAO.findBySubjectId(subjectId);
    }

    public List<Question> findByLessonId(int lessonId) {
        return questionDAO.findByLessonId(lessonId);
    }

    public Map<Integer, Question> findByIds(List<Integer> ids) {
        return questionDAO.findByIds(ids);
    }
}
