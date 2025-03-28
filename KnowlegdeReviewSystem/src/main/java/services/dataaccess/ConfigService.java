package services.dataaccess;

import models.Config;
import models.DTOConfig;
import models.dao.AnswerOptionDAO;
import models.dao.ConfigDAO;

import java.util.List;

public class ConfigService {
    private ConfigDAO configDAO;

    public ConfigService() {
        this.configDAO = new ConfigDAO();
    }

    public int create(Config config) {
        return configDAO.create(config);
    }

    public void update(Config config) {
        configDAO.update(config);
    }

    public void delete(Config config) {
        configDAO.delete(config);
    }

    public Config findById(int id) {
        return configDAO.findById(id);
    }

    public List<Config> findAll() {
        return configDAO.findAll();
    }

    public List<DTOConfig> findAllConfigDTO(String sql) {
        return configDAO.findAllConfigDTO(sql);
    }

    public List<DTOConfig> findConfigBySubjectId(int subjectId) {
        return configDAO.findConfigBySubjectId(subjectId);
    }

    public List<DTOConfig> findDomainBySubjectId(int subjectId) {
        return configDAO.findDomainBySubjectId(subjectId);
    }

    public void changeStatus(int id, String status) {
        configDAO.changeStatus(id, status);
    }

    public List<Config> getChaptersBySubject(int subjectId) {
        return configDAO.getChaptersBySubject(subjectId);
    }

    public int getChapterIdByLessonId(int lessonId) {
        return configDAO.getChapterIdByLessonId(lessonId);
    }
}
