package models;

public class QuestionReview {
    private Question question;
    private AnswerOption userAnswer;
    private AnswerOption correctAnswer;

    public QuestionReview(Question question, AnswerOption userAnswer, AnswerOption correctAnswer) {
        this.question = question;
        this.userAnswer = userAnswer;
        this.correctAnswer = correctAnswer;
    }

    // Getters
    public Question getQuestion() {
        return question;
    }

    public AnswerOption getUserAnswer() {
        return userAnswer;
    }

    public AnswerOption getCorrectAnswer() {
        return correctAnswer;
    }
}
