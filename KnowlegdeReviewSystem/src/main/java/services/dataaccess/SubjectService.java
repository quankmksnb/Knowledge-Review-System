package services.dataaccess;

import models.Subject;
import models.dao.DTOSubject;
import models.dao.SubjectDAO;

import java.util.HashMap;
import java.util.List;

public class SubjectService {
    private SubjectDAO subjectDAO;

    public SubjectService() {
        this.subjectDAO = new SubjectDAO();
    }

    public void save(Subject subject, String action) {
        subjectDAO.save(subject, action);
    }

    public int create(Subject subject) {
        return subjectDAO.create(subject);
    }

    public void changeStatus(Subject subject) {
        subjectDAO.changeStatus(subject);
    }

    public void update(Subject subject) {
        subjectDAO.update(subject);
    }

    public void delete(Subject subject) {
        subjectDAO.delete(subject);
    }

    public Subject findById(int id) {
        return subjectDAO.findById(id);
    }

    public List<Subject> findAll() {
        return subjectDAO.findAll();
    }

    public HashMap<Integer, String> getDomains(){
        return subjectDAO.getDomains();
    }

    public List<Subject> searchSubjects(String keyword, int limit) {
        return subjectDAO.searchSubjects(keyword, limit);
    }

    public List<Subject> findByDomain(int domainId) {
        return subjectDAO.findByDomain(domainId);
    }

    public List<Subject> getSubjectsByUserId(int userId) {
        return subjectDAO.getSubjectsByUserId(userId);
    }

    public String getSubjectCodeById(int subjectId) {
        return subjectDAO.getSubjectCodeById(subjectId);
    }

    public String getSubjectNameById(int subjectId) {
        return subjectDAO.getSubjectNameById(subjectId);
    }

    public String getDomain(int subjectId) {
        return subjectDAO.getDomain(subjectId);
    }

    public List<Subject> findAllByDomainId(int domainId) {
        return subjectDAO.findByDomain(domainId);
    }

    public List<DTOSubject> findAlls(String search, String domain) {
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT subject.id, subject.code, setting.title, subject.name, " +
                        "subject.description, subject.modified_at, subject.status " +
                        "FROM subject " +
                        "INNER JOIN setting ON subject.domain_id = setting.id " +
                        "WHERE setting.type = 'Category'"
        );

        if (search != null && !search.isEmpty()) {
            sqlBuilder.append(" AND subject.name LIKE '%").append(search).append("%'");
        }

        if (domain != null && !domain.isEmpty() && !domain.equals("all")) {
            sqlBuilder.append(" AND subject.domain_id = ").append(domain);
        }

        return subjectDAO.findAlls(sqlBuilder.toString());
    }
}
