package models;

public class QuizQuestion {
    private int id;
    private int quizId;
    private int lessonId;  // Mỗi câu hỏi sẽ thuộc một lesson cụ thể
    private int questionId;  // ID câu hỏi từ bảng `question`

    public QuizQuestion() {
    }

    public QuizQuestion(int id, int lessonId, int questionId, int quizId) {
        this.id = id;
        this.lessonId = lessonId;
        this.questionId = questionId;
        this.quizId = quizId;
    }

    // Getters và Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

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

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    @Override
    public String toString() {
        return "QuizQuestion{" +
                "id=" + id +
                ", quizId=" + quizId +
                ", lessonId=" + lessonId +
                ", questionId=" + questionId +
                '}';
    }
}
