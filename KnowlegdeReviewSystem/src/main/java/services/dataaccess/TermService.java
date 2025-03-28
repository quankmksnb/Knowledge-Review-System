package services.dataaccess;

import models.Term;
import models.dao.TermDAO;

import java.util.Hashtable;
import java.util.List;

public class TermService {
    private TermDAO termDAO;

    public TermService() {
        this.termDAO = new TermDAO();
    }

    public List<Term> getTermsBySubjectId(int subjectId) {
        return termDAO.getTermsBySubjectId(subjectId);
    }

    public List<Term> getTermsByLessonId(int lessonId) {
        return termDAO.getTermsByLessonId(lessonId);
    }

    public Term getTermsByTermId(int termId) {
        return termDAO.getTermsByTermId(termId);
    }

    public List<Term> getTermsByUserId(int userId) {
        return termDAO.getTermsByUserId(userId);
    }

    public List<Term> getTermsByContent(int subjectId, String content) {
        return termDAO.getTermsByContent(subjectId, content);
    }

    public List<Term> getTermsByUserIdBySubjectId(int subjectId, int userId) {
        return termDAO.getTermsByUserIdBySubjectId(subjectId, userId);
    }

    public List<Term> getTermsByUserIdByContent(int userId, String content) {
        return termDAO.getTermsByUserIdByContent(userId, content);
    }

    public Hashtable<Integer, String> getTermDomainConfigHashtable() {
        return termDAO.getTermDomainConfigHashtable();
    }

    public int createTerm(Term term) {
        return termDAO.createTerm(term);
    }

    public int updateTerm(Term term) {
        return termDAO.updateTerm(term);
    }

    public int changeTermStatus(int id, String status) {
        return termDAO.changeTermStatus(id, status);
    }
}