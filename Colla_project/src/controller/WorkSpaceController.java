package controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import model.Member;
import model.Workspace;
import model.WsMember;
import service.MemberService;
import service.WorkspaceService;
import service.WsMemberService;

@Controller
public class WorkSpaceController {
	@Autowired
	private MemberService mService;
	@Autowired
	private WorkspaceService wService;
	@Autowired
	private WsMemberService wsService;
	
	@RequestMapping("/workspace")
	public String showWsMain(Principal principal,HttpSession session,Model model) {
		//Ws메인이 보여질때 시큐리티가 갖고있는 principal 정보의 userid 를 가져와서
		String userEmail = principal.getName();
		//세션에 그 userEmail저장하고
		session.setAttribute("userEmail", userEmail);
		//이메일을 기반으로 멤버하나를 찾는다
		Member user = mService.getMemberByEmail(userEmail);
		session.setAttribute("user", user);
		
		List<Workspace> wsList = wService.getWsListByMnum(user.getNum());//유저 번호로 WS 들을 모두 꺼낸다.
		int wNum = 1; //선택한 workspace 번호
		List<Member> mList = mService.getAllMemberByWnum(wNum);
		model.addAttribute("mList", mList);
		model.addAttribute("wsList", wsList);
		return "/workspace/wsMain";
	}
	
	//showSelectWs(int wNum) 핸들러 만들어야한다.
	
	
	@RequestMapping("/chatMain")
	public String showChatMain() {
		return "/chatting/chatMain";
	}
	@RequestMapping("/addWs")
	public String addWs(String wsName,String targetUser1,String targetUser2,HttpSession session) {
		String userEmail = (String)session.getAttribute("userEmail");
		Member member = mService.getMemberByEmail(userEmail);
		//workspace 생성
		wService.addWorkspace(member.getNum(), wsName);
		//targetUser들에게 초대메일 보내기
		return "redirect:workpace";
	}
}
