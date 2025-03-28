package services.dataaccess;

import models.Class;
import models.ClassStatus;
import models.ClassStudentStatus;
import models.Subject;
import models.User;
import models.dao.ClassDAO;
import models.dao.ClassInfo;

import java.util.List;

public class ClassService {
    private ClassDAO classDAO;

    public ClassService() {
        this.classDAO = new ClassDAO();
    }

    public int create(models.Class aClass) {
        return classDAO.create(aClass);
    }

    public void update(models.Class aClass) {
        classDAO.update(aClass);
    }

    public void delete(models.Class aClass) {
        classDAO.delete(aClass);
    }

    public models.Class findById(int id) {
        return classDAO.findById(id);
    }

    public List<models.Class> findAll() {
        return classDAO.findAll();
    }

    public List<models.Class> findAllPublicClasses() {
        return classDAO.findAllPublicClasses();
    }

    public List<models.Class> findClassesByStudentId(int studentId) {
        return classDAO.findClassesByStudentId(studentId);
    }

    public models.Class getClassByCriteria(String code, int subjectId, int managerId, int semesterId, String className) {
        return classDAO.getClassByCriteria(code, subjectId, managerId, semesterId, className);
    }

    public boolean isStudentInClass(int studentId, int classId) {
        return classDAO.isStudentInClass(studentId, classId);
    }

    public ClassStudentStatus getStudentStatusInClass(int studentId, int classId){
        return classDAO.getStudentStatusInClass(studentId, classId);
    }

    public void enrollStudent(int studentId, int classId) {
        classDAO.enrollStudent(studentId, classId);
    }

    public List<models.Class> searchClasses(String keyword, int limit) {
        return classDAO.searchClasses(keyword, limit);
    }

    public List<models.Class> searchClasses(String searchQuery, Integer semesterId, Integer domainId, String status) {
        return classDAO.searchClasses(searchQuery, semesterId, domainId, status);
    }

    public Integer getLatestSemesterId() {
        return classDAO.getLatestSemesterId();
    }

    public List<User> getApprovedStudents(int classId){
        return classDAO.getApprovedStudents(classId);
    }

    public List<User> getUnapprovedStudents(int classId){
        return classDAO.getUnapprovedStudents(classId);
    }

    public List<models.Class> findBySemesterId(int semesterId) {
        return classDAO.findBySemesterId(semesterId);
    }

    public Integer getDomainIdBySubjectId(int subjectId){
        return classDAO.getDomainIdBySubjectId(subjectId);
    }

    public List<Class> findByManagerId(int managerId, int semesterId){
        return classDAO.findByManagerId(managerId, semesterId);
    }

    public boolean approveStudent(int classId, int studentId) {
        return classDAO.approveStudent(classId, studentId);
    }

    public boolean rejectStudent(int classId, int studentId) {
        return classDAO.rejectStudent(classId, studentId);
    }

    public boolean addStudentToClass(int classId, int studentId) {
        return classDAO.addStudentToClass(classId, studentId);
    }

    public boolean isStudentApprovedInClass(int studentId, int classId) {
        return classDAO.isStudentApprovedInClass(studentId, classId);
    }

    public ClassStatus toggleClassStatus(int classId) {
        return classDAO.toggleClassStatus(classId);
    }

    public ClassInfo getClassInfo(int classId) {
        return classDAO.getClassInfo(classId);
    }

    public List<Subject> getEnrolledSubjectsByUserId(int userId) {
        return classDAO.getEnrolledSubjectsByUserId(userId);
    }
}
