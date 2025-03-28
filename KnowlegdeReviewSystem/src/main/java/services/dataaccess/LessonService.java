package services.dataaccess;

import models.Lesson;
import models.dao.LessonDAO;

import java.util.List;

public class LessonService {
    private LessonDAO lessonDAO;

    public LessonService() {
        this.lessonDAO = new LessonDAO();
    }

    public boolean addLesson(int userId, int subjectId, String lessonName, String description) {
        return lessonDAO.addLesson(userId, subjectId, lessonName, description);
    }

    public boolean updateLesson(int lessonId, int userId, int subjectId, String lessonName, String description) {
        return lessonDAO.updateLesson(lessonId, userId, subjectId, lessonName, description);
    }

    public boolean deleteLesson(int id) {
        return lessonDAO.deleteLesson(id);
    }

    public Lesson getLessonById(int id) {
        return lessonDAO.getLessonById(id);
    }

    public List<Lesson> getAllLessons() {
        return lessonDAO.getAllLessons();
    }

    public List<Lesson> getLessonsByTitle(String textSearch) {
        return lessonDAO.getLessonsByTitle(textSearch);
    }

    public List<Lesson> findAllLessonsInSubject(int subjectId) {
        return lessonDAO.findAllLessonsInSubject(subjectId);
    }

    public Lesson findById(int id) {
        return lessonDAO.findById(id);
    }

    public List<Lesson> findAll() {
        return lessonDAO.findAll();
    }

    public String getLessonTitleByQuizId(int quizId) {
        return lessonDAO.getLessonTitleByQuizId(quizId);
    }

    public List<Lesson> getLessonsByEnrolledSubjects(List<Integer> enrolledSubjectIds) {
        return lessonDAO.getLessonsByEnrolledSubjects(enrolledSubjectIds);
    }

    public List<Lesson> getLessonsBySubject(int subjectId) {
        return lessonDAO.getLessonsBySubject(subjectId);
    }

    public int getQuestionCountByLessonId(int lessonId) {
        return lessonDAO.getQuestionCountByLessonId(lessonId);
    }

    public int getLessonIdByQuizId(int quizId) {
        return lessonDAO.getLessonIdByQuizId(quizId);
    }

    public List<Lesson> getLessonsByUserId(int userId) {
        return lessonDAO.getLessonsByUserId(userId);
    }

    public List<Lesson> getLessonsBySubjectId(int subjectId) {
        return lessonDAO.getLessonsBySubjectId(subjectId);
    }

    public String getChapterNameByLessonId(int lessonId) {
        return lessonDAO.getChapterNameByLessonId(lessonId);
    }

    public boolean updateLessonChapter(int lessonId, int chapterId) {
        return lessonDAO.updateLessonChapter(lessonId, chapterId);
    }

    public boolean updateLessonWithChapter(int lessonId, int subjectId, String lessonName, String description, int chapterId, String videoUrl) {
        return lessonDAO.updateLessonWithChapter(lessonId, subjectId, lessonName, description, chapterId, videoUrl);
    }

    public boolean addLesson1(String title, String description, String videoUrl, int subjectId, int chapterId, int createdBy) {
        return lessonDAO.addLesson1(title, description, videoUrl, subjectId, chapterId, createdBy);
    }
}
