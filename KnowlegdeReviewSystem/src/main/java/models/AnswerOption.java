package models;

public class AnswerOption {
    private int id;
    private int questionId;
    private String content;
    private boolean isAnswer;

    public AnswerOption() {
    }

    public AnswerOption(int id, int questionId, String content, boolean isAnswer) {
        this.id = id;
        this.questionId = questionId;
        this.content = content;
        this.isAnswer = isAnswer;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isAnswer() {
        return isAnswer;
    }

    public void setAnswer(boolean answer) {
        isAnswer = answer;
    }

    @Override
    public String toString() {
        return "AnswerOption{" +
                "id=" + id +
                ", questionId=" + questionId +
                ", content='" + content + '\'' +
                ", isAnswer=" + isAnswer +
                '}';
    }
}