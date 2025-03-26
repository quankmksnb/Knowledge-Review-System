package models;

public class QuizResult {
    private int id;
    private int quizId;
    private int userId;
    private double grade;  // Điểm số của người dùng sau khi hoàn thành quiz

    public QuizResult() {
    }

    public QuizResult(double grade, int id, int quizId, int userId) {
        this.grade = grade;
        this.id = id;
        this.quizId = quizId;
        this.userId = userId;
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

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public double getGrade() {
        return grade;
    }

    public void setGrade(double grade) {
        this.grade = grade;
    }

    @Override
    public String toString() {
        return "QuizResult{" +
                "grade=" + grade +
                ", quizId=" + quizId +
                ", userId=" + userId +
                '}';
    }
}
