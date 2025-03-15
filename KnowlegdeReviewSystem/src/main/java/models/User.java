package models;

import java.util.Date;
import java.util.List;
import java.util.Objects;

public class User {
    private Integer id;
    private String fullName;
    private String avatar;
    private String username;
    private String passwordHash;
    private String email;
    private Integer roleId;
    private UserStatus status;
    private Date createdAt;
    private Date modifiedAt;
    private Integer modifiedBy;

    public User() {
    }

    public User(Integer id, String fullName, String avatar, String username, String passwordHash, String email, Integer roleId, UserStatus status, Date createdAt, Date modifiedAt, Integer modifiedBy) {
        this.id = id;
        this.fullName = fullName;
        this.avatar = avatar;
        this.username = username;
        this.passwordHash = passwordHash;
        this.email = email;
        this.roleId = roleId;
        this.status = status;
        this.createdAt = createdAt;
        this.modifiedAt = modifiedAt;
        this.modifiedBy = modifiedBy;
    }

    public User(Integer id, String username, String passwordHash, String email, Integer roleId, UserStatus status) {
        this.id = id;
        this.username = username;
        this.passwordHash = passwordHash;
        this.email = email;
        this.roleId = roleId;
        this.status = status;
    }
    public User(String email, String username, String fullName, Integer roleId, Date createdAt){
        this.email = email;
        this.username = username;
        this.fullName = fullName;
        this.roleId = roleId;
        this.createdAt = createdAt;
    }

    //region Getter & Setter

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public UserStatus getStatus() {
        return status;
    }

    public void setStatus(UserStatus status) {
        this.status = status;
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

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", fullName='" + fullName + '\'' +
                ", avatar='" + avatar + '\'' +
                ", username='" + username + '\'' +
                ", passwordHash='" + passwordHash + '\'' +
                ", email='" + email + '\'' +
                ", roleId=" + roleId +
                ", status=" + status +
                ", createdAt=" + createdAt +
                ", modifiedAt=" + modifiedAt +
                ", modifiedBy=" + modifiedBy +
                '}';
    }

    //endregion
}
