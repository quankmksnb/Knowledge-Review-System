package models;

public class QuizLesson {
    private int id;
    private int quizId;
    private int lessonId;

    public QuizLesson() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    // Getters và Setters
    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public int getLessonId() {
        return lessonId;
    }

    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
    }



    @Override
    public String toString() {
        return "QuizLesson{" +
                "lessonId=" + lessonId +
                ", quizId=" + quizId +
                '}';
    }
}
