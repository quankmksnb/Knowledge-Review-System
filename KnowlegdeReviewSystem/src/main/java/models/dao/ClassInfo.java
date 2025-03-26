package models.dao;

import java.util.ArrayList;
import java.util.List;

public class ClassInfo {
    private String className;
    private List<Chapter> chapters;

    public ClassInfo(String className) {
        this.className = className;
        this.chapters = new ArrayList<>();
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public List<Chapter> getChapters() {
        return chapters;
    }

    public void setChapters(List<Chapter> chapters) {
        this.chapters = chapters;
    }

    public void addChapter(Chapter chapter) {
        this.chapters.add(chapter);
    }
}
