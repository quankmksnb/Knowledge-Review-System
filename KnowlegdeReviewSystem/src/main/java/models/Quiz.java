package models;

import java.sql.Date;

public class Quiz {
    private int id;
    private String quizName;
    private int subjectId;
    private int userId;  // Người tạo quiz
    private int numOfQuestions;
    private QuizStatus status;
    private Date createdAt;
    private Date modifiedAt;

    public Quiz() {
    }

    public int getNumOfQuestions() {
        return numOfQuestions;
    }

    public void setNumOfQuestions(int numOfQuestions) {
        this.numOfQuestions = numOfQuestions;
    }


    // Getters và Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    public String getQuizName() {
        return quizName;
    }

    public void setQuizName(String quizName) {
        this.quizName = quizName;
    }

    public QuizStatus getStatus() {
        return status;
    }

    public void setStatus(QuizStatus status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Quiz{" +
                "createdAt=" + createdAt +
                ", id=" + id +
                ", quizName='" + quizName + '\'' +
                ", subjectId=" + subjectId +
                ", userId=" + userId +
                ", status=" + status +
                ", modifiedAt=" + modifiedAt +
                '}';
    }
}
