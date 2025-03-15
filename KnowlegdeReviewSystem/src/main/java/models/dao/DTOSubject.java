package models.dao;

import java.util.Date;

public class DTOSubject {
    private int id;
    private String code;
    private String name;
    private String description;
    private String domain;
    private Date modifiedAt;
    private boolean status;

    public Date getModifiedAt() {
        return modifiedAt;
    }

    public void setModifiedAt(Date modifiedAt) {
        this.modifiedAt = modifiedAt;
    }

    public DTOSubject() {
    }

    public DTOSubject(int id,String code, String name, String description, String domain, Date modifiedAt, boolean status) {
        this.id = id;
        this.code = code;
        this.name = name;
        this.description = description;
        this.domain = domain;
        this.modifiedAt = modifiedAt;
        this.status = status;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDomain() {
        return domain;
    }

    public void setDomain(String domain) {
        this.domain = domain;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
