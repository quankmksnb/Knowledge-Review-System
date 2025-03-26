package models.dao;

import models.Lesson;

import java.util.ArrayList;
import java.util.List;

public class Chapter {
    private int chapterId;
    private String chapterName;
    private List<Lesson> lessons;

    public Chapter(int chapterId, String chapterName) {
        this.chapterId = chapterId;
        this.chapterName = chapterName;
        this.lessons = new ArrayList<>();
    }

    public int getChapterId() {
        return chapterId;
    }

    public void setChapterId(int chapterId) {
        this.chapterId = chapterId;
    }

    public String getChapterName() {
        return chapterName;
    }

    public void setChapterName(String chapterName) {
        this.chapterName = chapterName;
    }

    public List<Lesson> getLessons() {
        return lessons;
    }

    public void setLessons(List<Lesson> lessons) {
        this.lessons = lessons;
    }

    public void addLesson(Lesson lesson) {
        this.lessons.add(lesson);
    }
}
