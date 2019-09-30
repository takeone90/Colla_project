package controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import model.Project;
import model.Todo;
import service.ProjectService;
import service.TodoService;

@Controller
public class TodoController {
	@Autowired
	private TodoService tService;
	@Autowired
	private ProjectService pService;
	@RequestMapping("/todoMain") //todoMain으로 이동
	public String showTodoMain(int pNum, Model model) {
//		System.out.println("todoMain요청받음 // pNum : "+pNum);
		List<Todo> tList = tService.getAllTodoByPnum(pNum);
		model.addAttribute("tList", tList); //todo 리스트 입니다...
		model.addAttribute("pNum",pNum);
		model.addAttribute("progress",pService.getProject(pNum).getProgress());
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
	public Map<String, Object> toggleComplete(@RequestParam("tdNum")int tdNum) {
		Map<String, Object> completeAndProgress = new HashMap<String, Object>();
		Todo todo = tService.getTodo(tdNum);
		int pNum = todo.getpNum();
		if(todo.getIsComplete()==0) {
			todo.setIsComplete(1);
		}else {
			todo.setIsComplete(0);
		}
		tService.modifyTodo(todo);
		
		List<Todo> todoList = tService.getAllTodoByPnum(pNum);
		int completeCount = 0;
		for(Todo td : todoList) {
			if(td.getIsComplete()==1) {
				completeCount++;
			}
		}
		int todoListSize = todoList.size();
		
		double progress = pService.calcProgress(pNum, completeCount, todoListSize);
//		System.out.println("progress : " + progress);
		completeAndProgress.put("isComplete", todo.getIsComplete());
		completeAndProgress.put("progress", progress);
		return completeAndProgress;
	}
	@ResponseBody
	@RequestMapping("/resortingTodo")
	public void resortingTodo(@RequestParam(value="priorityArray[]")List<Integer> priorityArray,@RequestParam("pNum")int pNum){
		System.out.println(priorityArray);
		List<Todo> todoList = tService.getAllTodoByPnum(pNum);
		for(int i=0;i<todoList.size();i++) {
			Todo todo = todoList.get(i);
			todo.setPriority(priorityArray.get(i));
			tService.modifyTodo(todo);
		}
		
	}
//	@RequestMapping
//	public int updateProgress() {
//		return 0;
//	}
}
