package controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import model.Member;
import model.Project;
import model.ProjectMember;
import model.Workspace;
import model.WsMember;
import service.ChatRoomMemberService;
import service.ChatRoomService;
import service.ProjectMemberService;
import service.ProjectService;
import service.WorkspaceService;
import service.WsMemberService;

@Controller
public class ProjectController {
	@Autowired
	private ProjectService pService;
	@Autowired
	private ProjectMemberService pmService;
	@Autowired
	private ChatRoomService crService;
	@Autowired
	private ChatRoomMemberService crmService;
	@Autowired
	private WorkspaceService wService;
	@Autowired
	private WsMemberService wsmService;
	@RequestMapping("/projectMain") //projectMain으로 이동
	public String showProjectMain(HttpSession session, int wNum, Model model) {
		List<Project> pList = pService.getAllProjectByWnum(wNum); //프로젝트 리스트를 가져온다..
		List<Map<String, Object>> projectList = new ArrayList<Map<String,Object>>();
		for(int i=0; i<pList.size(); i++) { //프로젝트 리스트를 돌면서..
			int pNum = pList.get(i).getpNum();
			List<ProjectMember> pmList = pmService.getAllProjectMemberByPnum(pNum); // 각각의 프로젝트에 속한 멤버 가져오기
			Map<String, Object> pMap = new HashMap<String, Object>();
			pMap.put("pInfo", pList.get(i)); //프로젝트 정보 
			pMap.put("pmList", pmList); //프로젝트 소속 멤버
			projectList.add(pMap);
		}
		
		List<WsMember> wsmList = wsmService.getAllWsMemberByWnum(wNum);
		model.addAttribute("wsmList", wsmList);
		model.addAttribute("projectList", projectList);
		Workspace ws = wService.getWorkspace(wNum);
		session.setAttribute("wsName", ws.getName());
		session.setAttribute("currWnum", wNum);
		return "/project/projectMain";
	}
	
	//-------------------------------------------------------------------------------CRUD 
	
	@RequestMapping(value="/addProject", method = RequestMethod.POST)
	public String addProject(String pName, int wNum, String pDetail, String startDate, String endDate, HttpSession session, HttpServletRequest request) throws ParseException {
		Member member = (Member)session.getAttribute("user");
		int mNum = member.getNum();
		SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd");
		Date encStartDate = dt.parse(startDate);
		Date encEndDate = dt.parse(endDate);
		int pNum = pService.addProject(pName, wNum, pDetail, encStartDate, encEndDate, mNum); //프로젝트 추가 & 채팅방 추가
		String[] mNumListForInvitePj = request.getParameterValues("mNumListForInvitePj"); 
		if(mNumListForInvitePj != null) { //프로젝트 초대 멤버 추가
			for(String stringMnum : mNumListForInvitePj) {
				int num = Integer.parseInt(stringMnum);
				pmService.addProjectMember(pNum, num); //프로젝트에 초대 멤버들 추가 
				crmService.addChatRoomMember(pService.getProject(pNum).getCrNum(), num, wNum); //채팅방에 초대 멤버들 추가
			}
		}
		return "redirect:projectMain?wNum="+wNum;
	}
	
	@RequestMapping(value="/inviteProject",method=RequestMethod.POST)
	public String inviteProject(int pNum,int wNum,HttpServletRequest request) {
		System.out.println("inviteProjet 동작");
		String[] mNumListForInvitePj = request.getParameterValues("mNumListForInvitePj"); 
		if(mNumListForInvitePj != null) { //프로젝트 멤버 추가
			for(String stringMnum : mNumListForInvitePj) {
				int num = Integer.parseInt(stringMnum);
				pmService.addProjectMember(pNum, num);
			}
		}
		return "redirect:projectMain?wNum="+wNum;
	}
	
	@ResponseBody
	@RequestMapping(value="/exitProject")
	public boolean exitProject(int pNum, HttpSession session) {
		Member member = (Member)session.getAttribute("user");
		boolean result = pmService.removeProjectMember(pNum, member.getNum()); //프로젝트에서 나감 
//		result = crmService.removeChatRoomMemberByCrNumMnum(pService.getProject(pNum).getCrNum(), member.getNum()); //채팅방에서 나감
		return result;
	}
	@RequestMapping(value="/modifyProject", method = RequestMethod.POST)
	public String modifyProject(int wNum, int pNum, String pName, String pDetail, String startDate, String endDate, HttpSession session) throws ParseException {
		Member member = (Member)session.getAttribute("user");
		int mNum = member.getNum();
		SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd");
		Date encStartDate = dt.parse(startDate);
		Date encEndDate = dt.parse(endDate);
		pService.modifyProject(pNum, pName, pDetail, encStartDate, encEndDate, mNum); //프로젝트 수정 & 채팅방 수정
		return "redirect:projectMain?wNum="+wNum;
	}
	@ResponseBody
	@RequestMapping(value="/getProject", method = RequestMethod.POST)
	public Project getProject(int pNum) {
		Project projectTmp = pService.getProject(pNum);
		return projectTmp;
	}
	@ResponseBody
	@RequestMapping(value="/getProjectByCrNum", method = RequestMethod.POST)
	public Project getProjectByCrNum(int crNum) {
		Project projectTmp = pService.getProjectByCrNum(crNum);
		return projectTmp;
	}
	@ResponseBody
	@RequestMapping(value="/getAllProjectByMnum", method = RequestMethod.POST)
	public List<Project> getAllProjectByMnum(int mNum) {
		List<Project> projectList = pService.getAllProjectByMnum(mNum);
		return projectList;
	}
	@ResponseBody
	@RequestMapping(value="/getAllProjectByWnum", method = RequestMethod.POST)
	public List<Project> getAllProjectByWnum(int wNum) {
		List<Project> projectList = pService.getAllProjectByWnum(wNum);
		return projectList;
	}
	@ResponseBody
	@RequestMapping(value="/getAllProject", method = RequestMethod.POST)
	public List<Project> getAllProject() {
		List<Project> projectList = pService.getAllProject();
		return projectList;
	}
}
