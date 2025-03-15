package models;

import java.util.Date;
import java.util.List;

public class Lesson {
    private Integer id;
    private Integer subjectId;
    private Integer createdBy;
    private String title;
    private String description;
    private Date createdAt;
    private Date modifiedAt;
    private Integer modifiedBy;
    private List<Config> configs;

    public Lesson() {

    }

    public Lesson(int id, int subjectId, int createdBy, String title, String description, Date createdAt, Date modifiedAt, int modifiedBy) {
        this.id = id;
        this.subjectId = subjectId;
        this.createdBy = createdBy;
        this.title = title;
        this.description = description;
        this.createdAt = createdAt;
        this.modifiedAt = modifiedAt;
        this.modifiedBy = modifiedBy;
    }

    public Lesson(Integer id, Integer subjectId, Integer createdBy, String title, String description, Date createdAt, Date modifiedAt, Integer modifiedBy, List<Config> configs) {
        this(id, subjectId, createdBy, title, description, createdAt, modifiedAt, modifiedBy);
        this.configs = configs;
    }

    public Integer getId() {
        return id;
    }

    public Integer getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(Integer subjectId) {
        this.subjectId = subjectId;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getModifiedAt() {
        return modifiedAt;
    }

    public void setModifiedAt(Date modifiedAt) {
        this.modifiedAt = modifiedAt;
    }

    public Integer getModifiedBy() {
        return modifiedBy;
    }

    public void setModifiedBy(Integer modifiedBy) {
        this.modifiedBy = modifiedBy;
    }

    public List<Config> getConfigs() {
        return configs;
    }

    public void setConfigs(List<Config> configs) {
        this.configs = configs;
    }
    
    @Override
    public String toString() {
        return "Lesson{" + "id=" + id + ", subjectId=" + subjectId + ", createdBy=" + createdBy + ", title=" + title + ", description=" + description + ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + ", modifiedBy=" + modifiedBy + '}';
    }
}
