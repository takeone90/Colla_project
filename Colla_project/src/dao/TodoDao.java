package dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import model.Todo;

public interface TodoDao {
	public int insertTodo(Todo todo);
	public int deleteTodo(int tdNum);
	public int deleteAllTodoByPnum(int pNum);
	public int deleteAllTodoByPnumMnum(@Param("mNumTo")int mNum,@Param("pNum")int pNum);
	public int updateTodo(Todo todo);
	public Todo selectTodo(int tdNum);
	public List<Todo> selectAllTodoByPnum(int pNum);
	public List<Todo> selectAllTodoByMnum(int mNum);
	public List<Todo> selectAllTodoByMnumPnum(@Param("mNumTo")int mNum,@Param("pNum")int pNum);
}
