package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import service.MemberService;
import service.WorkspaceService;

@Controller
public class WorkSpaceController {
	@Autowired
	private WorkspaceService wserivce;
	@Autowired
	private MemberService mservice;
	@RequestMapping("/workspace")
	public String showWsMain() {
		return "/workspace/wsMain";
	}
	@RequestMapping("/chatMain")
	public String showChatMain() {
		return "/chatting/chatMain";
	}
	@RequestMapping("/addWs")
	public String addWs(String wsName,String targetUser1,String targetUser2) {
		
		//workspace 생성
		
		//targetUser들에게 초대메일 보내기
		
		return "redirect:workpace";
	}
}
