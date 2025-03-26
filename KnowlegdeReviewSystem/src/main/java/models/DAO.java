package models;


import java.util.List;



public interface DAO<T> {
    public int create(T t);
    public void update(T t);
    public void delete(T t);
    public T findById(int id);
    public List<T> findAll();
}
