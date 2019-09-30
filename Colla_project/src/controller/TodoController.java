package controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import model.Todo;
import service.TodoService;

@Controller
public class TodoController {
	@Autowired
	private TodoService tService;
	
	@RequestMapping("/todoMain") //todoMain으로 이동
	public String showTodoMain(int pNum, Model model) {
//		System.out.println("todoMain요청받음 // pNum : "+pNum);
		List<Todo> tList = tService.getAllTodoByPnum(pNum);
		model.addAttribute("tList", tList); //todo 리스트 입니다...
		return "/project/todoMain";
	}
	
	//-------------------------------------------------------------------------------CRUD
	
	@ResponseBody
	@RequestMapping(value="/addTodo", method = RequestMethod.POST)
	public int addTodo(String tdTitle, String tdContent, int pNum, int mNumTo, int mNumFrom, Date tdStartDate, Date tdEndDate, Date completeDate) {
		int tdNum = tService.addTodo(tdTitle, tdContent, pNum, mNumTo, mNumFrom, tdStartDate, tdEndDate, completeDate);
		return tdNum;
	}
	@ResponseBody
	@RequestMapping(value="/removeTodo", method = RequestMethod.POST)
	public boolean removeTodo(int tdNum) {
		boolean result = tService.removeTodo(tdNum);
		return result;
	}
	@ResponseBody
	@RequestMapping(value="/modifyTodo", method = RequestMethod.POST)
	public boolean modifyTodo(Todo todo) {
		boolean result = tService.modifyTodo(todo);
		return result;
	}
	@ResponseBody
	@RequestMapping(value="/getTodo", method = RequestMethod.POST)
	public Todo getTodo(int tdNum) {
		Todo todoTmp = tService.getTodo(tdNum);
		return todoTmp;
	}
	@ResponseBody
	@RequestMapping(value="/getAllTodoByPnum", method = RequestMethod.POST)
	public List<Todo> getAllTodoByPnum(int pNum) {
		List<Todo> todoList = tService.getAllTodoByPnum(pNum);
		return todoList;
	}
	@ResponseBody
	@RequestMapping(value="/getAllTodoByMnum", method = RequestMethod.POST)
	public List<Todo> getAllTodoByMnum(int mNum) {
		List<Todo> todoList = tService.getAllTodoByMnum(mNum);
		return todoList;
	}
	@ResponseBody
	@RequestMapping("/toggleComplete")
	public int toggleComplete(@RequestParam("tdNum")int tdNum) {
		Todo todo = tService.getTodo(tdNum);
		if(todo.getIsComplete()==0) {
			todo.setIsComplete(1);
		}else {
			todo.setIsComplete(0);
		}
		tService.modifyTodo(todo);
		return todo.getIsComplete();
	}
}
