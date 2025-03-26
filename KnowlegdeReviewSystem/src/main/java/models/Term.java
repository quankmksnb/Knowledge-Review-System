package models;

public class Term {
    private int id;
    private int lessonId;
    private String content;

    public Term(int id, int lessonId, String content) {
        this.id = id;
        this.lessonId = lessonId;
        this.content = content;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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
}
