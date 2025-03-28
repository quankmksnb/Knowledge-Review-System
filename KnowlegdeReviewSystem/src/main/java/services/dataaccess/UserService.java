package services.dataaccess;

import models.User;
import models.UserStatus;
import models.dao.UserDAO;

import java.util.List;

public class UserService {
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public int create(User user) {
        return userDAO.create(user);
    }

    public void register(User user) {
        userDAO.register(user);
    }

    public void update(User user) {
        userDAO.update(user);
    }

    public User findById(int id) {
        return userDAO.findById(id);
    }

    public void updateStatus(User user) {
        userDAO.updateStatus(user);
    }

    public void delete(User user) {
        userDAO.delete(user);
    }

    public List<User> findAll() {
        return userDAO.findAll();
    }

    public List<User> searchUsers(String searchQuery, Integer roleId, UserStatus status) {
        return userDAO.searchUsers(searchQuery, roleId, status);
    }

    public boolean isEmailExists(String email) {
        return userDAO.isEmailExists(email);
    }

    public boolean isUsernameExists(String username) {
        return userDAO.isUsernameExists(username);
    }

    public User getUserByUsernameOrEmail(String usernameOrEmail) {
        return userDAO.findByUsernameOrEmail(usernameOrEmail);
    }

    public String getUserFullname(int userId) {
        return userDAO.getUserFullname(userId);
    }

    public String getManagerUsername(int managerId) {
        return userDAO.getManagerUsername(managerId);
    }

    public int getIdByUsername(String username) {
        return userDAO.getIdByUsername(username);
    }

    public String getRoleByUsername(String username) {
        return userDAO.getRoleByUsername(username);
    }

    public User findByEmail(String email) {
        return userDAO.findByEmail(email);
    }

    public UserStatus toggleUserStatus(int userId) {
        return userDAO.toggleUserStatus(userId);
    }
}
