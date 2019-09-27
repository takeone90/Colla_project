package dao;

import java.util.List;

import model.Todo;

public interface TodoDao {
	public int insertTodo(Todo todo);
	public int deleteTodo(int tdNum);
	public int updateTodo(Todo todo);
	public Todo selectTodo(int tdNum);
	public List<Todo> selectAllTodoByPnum(int pNum);
	public List<Todo> selectAllTodoByMnum(int mNum);
}
