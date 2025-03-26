package models;

import java.util.ArrayList;
import java.util.List;

public class Question {
    private int id;
    private int subjectId;
    private int lessonId; // Renamed from lessonid to lessonId for consistency
    private String content;
    private String status; // Added to match the database schema
    private List<AnswerOption> options; // Added to store answer options
    private String domain;

    public Question(){}

    // Constructor for creating a new question (without ID, status, and options)
    public Question(int subjectId, int lessonId, String content) {}

    public Question(int id, int subjectId, int lessonId, String content, String status, String domain) {
        this.id = id;
        this.subjectId = subjectId;
        this.lessonId = lessonId;
        this.content = content;
        this.status = "active"; // Default status
        this.options = new ArrayList<>();
        this.status = status;
        this.domain = domain;
    }

    // Constructor for fetching a question from the database (without options)
    public Question(int id, int subjectId, int lessonId, String content, String status) {
        this.id = id;
        this.subjectId = subjectId;
        this.lessonId = lessonId;
        this.content = content;
        this.status = status;
        this.options = new ArrayList<>();
    }

    // Constructor for fetching a question with options
    public Question(int id, int subjectId, int lessonId, String content, String status, List<AnswerOption> options) {
        this.id = id;
        this.subjectId = subjectId;
        this.lessonId = lessonId;
        this.content = content;
        this.status = status;
        this.options = options != null ? options : new ArrayList<>();
    }

    // Getters and setters
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

    public int getLessonId() {
        return lessonId;
    }

    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<AnswerOption> getOptions() {
        return options;
    }

    public void setOptions(List<AnswerOption> options) {
        this.options = options != null ? options : new ArrayList<>();
    }

    public void addOption(AnswerOption option) {
        this.options.add(option);
    }

    public String getDomain() {
        return domain;
    }

    public void setDomain(String domain) {
        this.domain = domain;
    }

    @Override
    public String toString() {
        return "Question{" +
                "id=" + id +
                ", subjectId=" + subjectId +
                ", lessonId=" + lessonId +
                ", content='" + content + '\'' +
                ", status='" + status + '\'' +
                ", options=" + options +
                '}';
    }
}