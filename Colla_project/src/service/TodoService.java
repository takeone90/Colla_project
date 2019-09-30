package service;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.TodoDao;
import model.Todo;

@Service
public class TodoService {
	@Autowired
	private TodoDao tdDao;
	public int addTodo(String tdTitle, String tdContent,int pNum,int mNumTo,int mNumFrom,Date tdStartDate,Date tdEndDate,Date completeDate) {
		int tdNum = 0;
		Todo todo = new Todo();
		todo.setCompleteDate(completeDate);
		todo.setmNumFrom(mNumFrom);
		todo.setmNumTo(mNumTo);
		todo.setTdEndDate(tdEndDate);
		todo.setTdStartDate(tdStartDate);
		todo.setTdTitle(tdTitle);
		todo.setpNum(pNum);
		todo.setTdContent(tdContent);
		if(tdDao.insertTodo(todo)>0) {
			tdNum = todo.getTdNum();
		}
		return tdNum;
	}
	public boolean removeTodo(int tdNum) {
		boolean result = false;
		if(tdDao.deleteTodo(tdNum)>0) {
			result = true;
		}
		return result;
	}
	public boolean modifyTodo(Todo todo) {
		boolean result = false;
		if(tdDao.updateTodo(todo)>0) {
			result = true;
		}
		return result;
	}
	public Todo getTodo(int tdNum) {
		return tdDao.selectTodo(tdNum);
	}
	public List<Todo> getAllTodoByPnum(int pNum){
		return tdDao.selectAllTodoByPnum(pNum);
	}
	public List<Todo> getAllTodoByMnum(int mNum){
		return tdDao.selectAllTodoByMnum(mNum);
	}
}
