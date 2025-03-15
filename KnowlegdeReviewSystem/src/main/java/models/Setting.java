package models;

import java.sql.Timestamp;
import java.util.List;

public class Setting {
    private int id;
    private int createdBy;
    private String title;
    private Timestamp createdAt;
    private SettingType type;
    private Timestamp modifiedAt;
    private Integer modifiedBy; 

    public Setting() {
    }

    public Setting(int id, int createdBy, String title, Timestamp createdAt, SettingType type, Timestamp modifiedAt, Integer modifiedBy) {
        this.id = id;
        this.createdBy = createdBy;
        this.title = title;
        this.createdAt = createdAt;
        this.type = type;
        this.modifiedAt = modifiedAt;
        this.modifiedBy = modifiedBy;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public SettingType getType() {
        return type;
    }

    public void setType(SettingType type) {
        this.type = type;
    }

    public Timestamp getModifiedAt() {
        return modifiedAt;
    }

    public void setModifiedAt(Timestamp modifiedAt) {
        this.modifiedAt = modifiedAt;
    }

    public Integer getModifiedBy() {
        return modifiedBy;
    }

    public void setModifiedBy(Integer modifiedBy) {
        this.modifiedBy = modifiedBy;
    }
    //endregion


    @Override
    public String toString() {
        return "Setting{" +
                "createdBy=" + createdBy +
                ", id=" + id +
                ", title='" + title + '\'' +
                ", type=" + type +
                ", modifiedBy=" + modifiedBy +
                '}';
    }
}
