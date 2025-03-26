package models;

public class Config {
    private int id;
    private int subjectId;
    private int typeId;
    private String description;
    private String status;

    public Config() {
    }

    public Config(int id, int subjectId, int typeId, String description) {
        this.id = id;
        this.subjectId = subjectId;
        this.typeId = typeId;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
