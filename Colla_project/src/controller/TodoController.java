package controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import model.Member;
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
	public String showTodoMain(HttpSession session, int pNum, Model model) {
//		System.out.println("todoMain요청받음 // pNum : "+pNum);
		List<Todo> tList = tService.getAllTodoByPnum(pNum);
		model.addAttribute("tList", tList); //todo 리스트 입니다...
		model.addAttribute("pNum", pNum);
		session.setAttribute("pNum", pNum);
		model.addAttribute("progress",pService.getProject(pNum).getProgress());

		return "/project/todoMain";
	}
	
	//-------------------------------------------------------------------------------CRUD
	
	@RequestMapping(value="/addTodo", method = RequestMethod.POST)
	public String addTodo(String tdTitle, String tdContent, int mNumTo, String startDate, String endDate, HttpSession session) throws ParseException {
		System.out.println("addTodo 실행!");
		int pNum = (int)session.getAttribute("pNum");
		Member member = (Member)session.getAttribute("user");
		int mNumFrom = member.getNum(); //일 시킨 사람
		SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd");
		Date encStartDate = dt.parse(startDate);
		Date encEndDate = dt.parse(endDate);
		int tdNum = tService.addTodo(tdTitle, tdContent, pNum, mNumTo, mNumFrom, encStartDate, encEndDate);
		System.out.println("tdNum : "+tdNum);
		return "redirect:todoMain?pNum="+pNum;
	}
	@ResponseBody
	@RequestMapping(value="/removeTodo", method = RequestMethod.POST)
	public boolean removeTodo(int tdNum) {
		boolean result = tService.removeTodo(tdNum);
		return result;
	}
	@RequestMapping(value="/modifyTodo", method = RequestMethod.POST)
	public String modifyTodo(int tdNum, String tdTitle, String tdContent, int mNumTo, String startDate, String endDate, HttpSession session) throws ParseException {
		System.out.println("modifyTodo 실행!");
		System.out.println("tdNum : "+tdNum);
		int pNum = (int)session.getAttribute("pNum");
		SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd");
		Date encStartDate = dt.parse(startDate);
		Date encEndDate = dt.parse(endDate);	
		Todo todo = new Todo();
		todo.setTdNum(tdNum);
		todo.setTdTitle(tdTitle);
		todo.setTdContent(tdContent);
		todo.setmNumTo(mNumTo);
		todo.setTdStartDate(encStartDate);
		todo.setTdEndDate(encEndDate);
		boolean result = tService.modifyTodo(todo);
		System.out.println("result : "+result);
		return "redirect:todoMain?pNum="+pNum;
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
