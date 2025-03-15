package models;

import java.util.Date;

public class Subject {
    private int id;
    private int domainId;
    private int categoryId;
    private String subjectName;
    private String code;
    private String description;
    private int createdBy;
    private int modifiedBy;
    private Date createdAt;
    private boolean status;
    private Date modifiedAt;

    public Subject() {
    }

    public Subject(int id, int managerId, int domainId, int categoryId, String subjectName, String code, String description, Date modifiedAt) {
        this.id = id;
        this.domainId = domainId;
        this.categoryId = categoryId;
        this.subjectName = subjectName;
        this.code = code;
        this.description = description;
        this.modifiedBy = modifiedBy;
        this.modifiedAt = modifiedAt;
    }

    public Subject(int id, int managerId, int domainId, int categoryId, String subjectName, String code, String description, int modifiedBy, Date createdAt, Date modifiedAt) {
        this.id = id;
        this.domainId = domainId;
        this.categoryId = categoryId;
        this.subjectName = subjectName;
        this.code = code;
        this.description = description;
    }

    public Subject(int id, int domainId, int categoryId, String subjectName,
                   String code, String description, int createdBy, int modifiedBy) { // Removed settingId
        this.id = id;
        this.domainId = domainId;
        this.categoryId = categoryId;
        this.subjectName = subjectName;
        this.code = code;
        this.description = description;
        this.createdBy = createdBy; // Assign createdBy
        this.modifiedBy = modifiedBy;
    }

    public Subject(int id, int domainId, int categoryId, String subjectName,
                   String code, String description, int createdBy, int modifiedBy,
                   Date createdAt, Date modifiedAt) { // Include all fields
        this(id, domainId, categoryId, subjectName, code, description, createdBy, modifiedBy);
        this.createdAt = createdAt;
        this.modifiedAt = modifiedAt;
    }


    //region Getter & Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getDomainId() {
        return domainId;
    }

    public void setDomainId(int domainId) {
        this.domainId = domainId;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public int getModifiedBy() {
        return modifiedBy;
    }

    public Date getModifiedAt() {
        return modifiedAt;
    }

    public void setModifiedAt(Date modifiedAt) {
        this.modifiedAt = modifiedAt;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    //endregion

    @Override
    public String toString() {
        return "Subject{" +
                "id=" + id +

                ", domainId=" + domainId +
                ", categoryId=" + categoryId +
                ", subjectName='" + subjectName + '\'' +
                ", code='" + code + '\'' +
                ", description='" + description + '\'' +

                '}';
    }
}
