package models;

public class Question {
    private int id;
    private int subjectId;
    private int lessonid;
    private String content;

    public Question() {}
    public Question(int id, int subjectId, int lessonid, String content) {
        this.id = id;
        this.subjectId = subjectId;
        this.lessonid = lessonid;
        this.content = content;
    }

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

    public int getLessonid() {
        return lessonid;
    }

    public void setLessonid(int lessonid) {
        this.lessonid = lessonid;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    @Override
    public String toString() {
        return "Question{" +
                "id=" + id +
                ", subjectId=" + subjectId +
                ", questionId=" + lessonid +
                ", content='" + content + '\'' +
                '}';
    }
}
