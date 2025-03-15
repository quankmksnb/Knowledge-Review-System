package controllers;

import models.dao.*;

import java.sql.SQLException;
import java.util.logging.Logger;

public class WebManager {
    private UserDAO userDAO;
    private ClassDAO classDAO;
    private SubjectDAO subjectDAO;
    private SettingDAO settingDAO;
    private LessonDAO lessonDAO;
    private ConfigDAO configDAO;
    private QuestionDAO questionDAO;
    private Logger logger;

    private static WebManager instance;

    // Private constructor to enforce singleton pattern
    private WebManager() {
        // No initialization here to avoid creating DAO instances unnecessarily
    }

    // Singleton instance getter with lazy initialization
    public static synchronized WebManager getInstance() {
        if (instance == null) {
            instance = new WebManager();
        }
        return instance;
    }

    // Generic method to lazily initialize DAO instances
    private <T> T getDAOInstance(T dao, Class<T> daoClass) {
        if (dao == null) {
            try {
                dao = daoClass.getDeclaredConstructor().newInstance();
            } catch (Exception e) {
                throw new RuntimeException("Error creating DAO instance for: " + daoClass.getSimpleName(), e);
            }
        }
        return dao;
    }

    public UserDAO getUserDAO() {
        userDAO = getDAOInstance(userDAO, UserDAO.class);
        return userDAO;
    }

    public ClassDAO getClassDAO() {
        classDAO = getDAOInstance(classDAO, ClassDAO.class);
        return classDAO;
    }

    public SubjectDAO getSubjectDAO() {
        subjectDAO = getDAOInstance(subjectDAO, SubjectDAO.class);
        return subjectDAO;
    }

    public SettingDAO getSettingDAO() {
        settingDAO = getDAOInstance(settingDAO, SettingDAO.class);
        return settingDAO;
    }

    public LessonDAO getLessonDAO() {
        lessonDAO = getDAOInstance(lessonDAO, LessonDAO.class);
        return lessonDAO;
    }

    public ConfigDAO getConfigDAO() {
        configDAO = getDAOInstance(configDAO, ConfigDAO.class);
        return configDAO;
    }

    public QuestionDAO getQuestionDAO() {
        questionDAO = getDAOInstance(questionDAO, QuestionDAO.class);
        return questionDAO;
    }

    public Logger getLogger() {
        logger = getDAOInstance(logger, Logger.class);
        return logger;
    }
}
