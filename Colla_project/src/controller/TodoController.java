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
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import model.Member;
import model.Project;
import model.ProjectMember;
import model.Todo;
import service.AlarmService;
import service.MemberService;
import service.ProjectMemberService;
import service.ProjectService;
import service.SetAlarmService;
import service.TodoService;

@Controller
public class TodoController {
	@Autowired
	private TodoService tService;
	@Autowired
	private ProjectService pService;
	@Autowired
	private ProjectMemberService pmService;
	@Autowired
	private SimpMessagingTemplate smt;
	@Autowired
	private AlarmService aService;
	@Autowired
	private SetAlarmService saService;
	@Autowired
	private MemberService mService;
	@RequestMapping("/todoMain") //todoMain으로 이동
	public String showTodoMain(HttpSession session, int pNum, Model model) {
		List<Todo> tList = tService.getAllTodoByPnum(pNum);
		List<ProjectMember> pmList =  pmService.getAllProjectMemberByPnum(pNum);
		List<Map<String, Object>> thisProjectTdList = new ArrayList<Map<String,Object>>();
		for(int i=0;i<pmList.size();i++) {
			Map<String, Object> todoMap = new HashMap<String, Object>();
			List<Todo> oneMemberTdList = tService.getAllTodoByMnumPnum(pmList.get(i).getmNum(), pNum);
			todoMap.put("oneMemberTdList", oneMemberTdList);
			todoMap.put("mNum",pmList.get(i).getmNum());
//			todoMap.put(key, value)
			thisProjectTdList.add(todoMap);
		}
		Project project = pService.getProject(pNum);
		model.addAttribute("pName", project.getpName());
		model.addAttribute("tList", tList); //todo 리스트 입니다...
		model.addAttribute("pmList", pmList);
		model.addAttribute("thisProjectTdList",thisProjectTdList);
		model.addAttribute("pNum", pNum);
		session.setAttribute("pNum", pNum);
		model.addAttribute("progress", pService.getProject(pNum).getProgress());
		return "/project/todoMain";
	}
	
	//-------------------------------------------------------------------------------CRUD
	
	@RequestMapping(value="/addTodo", method = RequestMethod.POST)
	public String addTodo(String tdTitle, String tdContent, int mNum, String startDate, String endDate, HttpSession session) throws ParseException {
		int pNum = (int)session.getAttribute("pNum");
		Project pj = pService.getProject(pNum);
		int wNum = pj.getwNum();
		Member member = (Member)session.getAttribute("user");
		int mNumFrom = member.getNum(); //일 시킨 사람
		SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd");
		Date encStartDate = dt.parse(startDate);
		Date encEndDate = dt.parse(endDate);
		tService.addTodo(tdTitle, tdContent, pNum, mNum, mNumFrom, encStartDate, encEndDate);
		if(mNumFrom!=mNum) {
			//내가 나한테 일시키면 알람X
			int aNum = aService.addAlarm(wNum, mNum, mNumFrom, "todo", pNum);
			smt.convertAndSend("/category/alarm/"+mNum,aService.getAlarm(aNum));								
		}
		return "redirect:todoMain?pNum="+pNum;
	}
	@RequestMapping(value="/removeTodo")
	public String removeTodo(int tdNum, HttpSession session) {
		tService.removeTodo(tdNum);
		int pNum = (int)session.getAttribute("pNum");
		return "redirect:todoMain?pNum="+pNum;
	}
	@RequestMapping(value="/modifyTodo", method = RequestMethod.POST)
	public String modifyTodo(int tdNum, String tdTitle, String tdContent, int mNum, String startDate, String endDate, HttpSession session) throws ParseException {
		int pNum = (int)session.getAttribute("pNum");
		Project pj = pService.getProject(pNum);
		SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd");
		Date encStartDate = dt.parse(startDate);
		Date encEndDate = dt.parse(endDate);
		Todo todo = tService.getTodo(tdNum);
		todo.setTdNum(tdNum);
		todo.setTdTitle(tdTitle);
		todo.setTdContent(tdContent);
		todo.setmNumTo(mNum);
		todo.setTdStartDate(encStartDate);
		todo.setTdEndDate(encEndDate);
		tService.modifyTodo(todo);
		if(todo.getmNumFrom()!=mNum) {
			//내가 나한테 일시키면 알람X
			int aNum = aService.addAlarm(pj.getwNum(), mNum, todo.getmNumFrom(), "todo", pNum);
			smt.convertAndSend("/category/alarm/"+mNum,aService.getAlarm(aNum));								
		}
		return "redirect:todoMain?pNum="+pNum;
	}
	@ResponseBody
	@RequestMapping("/getTodo")
	public Todo getTodo(@RequestParam("tdNum")int tdNum) {
		Todo todo = tService.getTodo(tdNum);
		return todo;
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
	
	//-------------------------------------------------------------------------------CRUD 끝
	
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
		completeAndProgress.put("isComplete", todo.getIsComplete());
		completeAndProgress.put("progress", progress);
		return completeAndProgress;
	}
	@ResponseBody
	@RequestMapping("/resortingTodo")
	public void resortingTodo(@RequestParam(value="priorityArray[]")List<Integer> priorityArray,@RequestParam("pNum")int pNum,@RequestParam("mNum")int mNum){
		/*
		System.out.println("priorityArray : " + priorityArray);
		List<Todo> todoList = tService.getAllTodoByPnum(pNum);
		System.out.println(todoList);
		for(int i=0;i<todoList.size();i++) {
			Todo todo = todoList.get(i);
			todo.setPriority(priorityArray.get(i));
			System.out.println(i + " : " + i);
			tService.modifyTodo(todo);
		
			
		}
		*/
		System.out.println("사용자가 변경한 순서  : " + priorityArray);
		List<Todo> todoList = tService.getAllTodoByMnumPnum(2,pNum);
		for(int i=0;i<todoList.size();i++) {
			Todo todo = todoList.get(i);
			System.out.println();
			int tdNum = todo.getTdNum();
			int tdindex = priorityArray.indexOf(tdNum);
			todo.setPriority(tdindex);
			tService.modifyTodo(todo);
		
			
		}
	}
}
