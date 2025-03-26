package models;

public class QuizAnswer {
    private int id; // Added the missing 'id' field
    private int quizId;
    private int userId;
    private int questionId;
    private Integer answerOptionId; // Nullable for unanswered questions
    private boolean isCorrect;

    public QuizAnswer() {}

    public QuizAnswer(int id, int quizId, int userId, int questionId, Integer answerOptionId, boolean isCorrect) {
        this.id = id;
        this.quizId = quizId;
        this.userId = userId;
        this.questionId = questionId;
        this.answerOptionId = answerOptionId;
        this.isCorrect = isCorrect;
    }

    public QuizAnswer(int quizId, int userId, int questionId, Integer answerOptionId, boolean isCorrect) {
        this.quizId = quizId;
        this.userId = userId;
        this.questionId = questionId;
        this.answerOptionId = answerOptionId;
        this.isCorrect = isCorrect;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getQuizId() { return quizId; }
    public void setQuizId(int quizId) { this.quizId = quizId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    public Integer getAnswerOptionId() { return answerOptionId; }
    public void setAnswerOptionId(Integer answerOptionId) { this.answerOptionId = answerOptionId; }
    public boolean isCorrect() { return isCorrect; }
    public void setIsCorrect(boolean isCorrect) { this.isCorrect = isCorrect; }
}