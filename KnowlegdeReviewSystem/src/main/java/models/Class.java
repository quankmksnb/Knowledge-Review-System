package models;

import controllers.WebManager;

import java.util.Date;
import java.util.List;

public class Class {
    private int id;
    private int subjectId;
    private int managerId;
    private int semesterId;
    private String className;
    private String code;
    private int createdBy;
    private int modifiedBy;
    private List<User> classStudents;
    private Date createdAt;
    private Date modifiedAt;
    private ClassStatus status;
    private String managerName;
    private String subjectName;

    public Class() {
    }

    public Class(int id, String className, String code, int createdBy, int modifiedBy) {
        this.id = id;
        this.className = className;
        this.code = code;
        this.createdBy = createdBy;
        this.modifiedBy = modifiedBy;
    }

    public Class(String className, List<User> classStudents, String code, Date createdAt, int createdBy, int id, int managerId, Date modifiedAt, int modifiedBy, int semesterId, ClassStatus status, int subjectId) {
        this.className = className;
        this.classStudents = classStudents;
        this.code = code;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
        this.id = id;
        this.managerId = managerId;
        this.modifiedAt = modifiedAt;
        this.modifiedBy = modifiedBy;
        this.semesterId = semesterId;
        this.status = status;
        this.subjectId = subjectId;
        managerName = (managerId > 0) ? WebManager.getInstance().getUserDAO().getUserFullname(managerId) : "UnIdentify";
        managerName = WebManager.getInstance().getSubjectDAO().findById(subjectId).getSubjectName();
    }

    //region Getter & Setter
    public int getId() {
        return id;
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

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
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

    public void setModifiedBy(int modifiedBy) {
        this.modifiedBy = modifiedBy;
    }

    public List<User> getClassStudents() {
        return classStudents;
    }

    public void setClassStudents(List<User> classStudents) {
        this.classStudents = classStudents;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
        subjectName = WebManager.getInstance().getSubjectDAO().findById(subjectId).getSubjectName();
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
        managerName = WebManager.getInstance().getUserDAO().getUserFullname(managerId);
    }

    public void setId(int id) {
        this.id = id;
    }

    public ClassStatus getStatus() {
        return status;
    }

    public void setStatus(ClassStatus status) {
        this.status = status;
    }

    public int getSemesterId() {
        return semesterId;
    }

    public void setSemesterId(int semesterId) {
        this.semesterId = semesterId;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    public String getManagerName(){
        return managerName;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    @Override
    public String toString() {
        return "Class{" +
                "className='" + className + '\'' +
                ", id=" + id +
                ", subjectId=" + subjectId +
                ", managerId=" + managerId +
                ", semesterId=" + semesterId +
                ", code='" + code + '\'' +
                ", createdBy=" + createdBy +
                ", modifiedBy=" + modifiedBy +
                ", classStudents=" + classStudents +
                ", createdAt=" + createdAt +
                ", modifiedAt=" + modifiedAt +
                ", status=" + status +
                '}';
    }
//endregion

}
