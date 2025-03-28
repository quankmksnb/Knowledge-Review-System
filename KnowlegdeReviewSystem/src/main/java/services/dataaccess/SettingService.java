package services.dataaccess;

import models.Setting;
import models.SettingType;
import models.dao.SettingDAO;

import java.util.List;

public class SettingService {
    private SettingDAO settingDAO;

    public SettingService() {
        this.settingDAO = new SettingDAO();
    }

    public int create(Setting setting) {
        return settingDAO.create(setting);
    }

    public void update(Setting setting) {
        settingDAO.update(setting);
    }

    public void delete(Setting setting) {
        settingDAO.delete(setting);
    }

    public Setting findById(int id) {
        return settingDAO.findById(id);
    }

    public List<Setting> findAll() {
        return settingDAO.findAll();
    }

    public List<Setting> findAllByType(SettingType type) {
        return settingDAO.findAllByType(type);
    }

    public List<Setting> findAllBySemester() {
        return settingDAO.findAllBySemester();
    }

    public String getRoleById(int roleId) {
        return settingDAO.getRoleById(roleId);
    }
}
