package controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import model.ChatRoom;
import model.Member;
import model.Workspace;
import model.WsMember;
import service.ChatRoomService;
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
	@Autowired
	private ChatRoomService crService;
	@RequestMapping("/workspace")
	public String showWsMain(Principal principal,HttpSession session,Model model) {
		//Ws메인이 보여질때 시큐리티가 갖고있는 principal 정보의 userid 를 가져와서
		String userEmail = principal.getName();
		//세션에 그 userEmail저장하고
		session.setAttribute("userEmail", userEmail);
		//이메일을 기반으로 멤버하나를 찾는다
		Member user = mService.getMemberByEmail(userEmail);
		session.setAttribute("user", user);
		//session에 user와 userEmail이 같이 담긴 상태
		List<Map<String, Object>> workspaceList = new ArrayList<Map<String,Object>>();
		List<Workspace> wsList = wService.getWsListByMnum(user.getNum());//유저 번호로 WS 들을 모두 꺼낸다.
		for(int i = 0;i<wsList.size();i++) {
			int wsNum = wsList.get(i).getNum();
			Map<String, Object> wsMap = new HashMap<String, Object>();
			wsMap.put("wsInfo", wsList.get(i));
			wsMap.put("crList", crService.getAllChatRoomByWnum(wsNum));
			wsMap.put("mList", mService.getAllMemberByWnum(wsNum));
			workspaceList.add(wsMap);
		}
		model.addAttribute("workspaceList", workspaceList);
		return "/workspace/wsMain";
	}
	
	
	@RequestMapping("/addWs")
	public String addWs(String wsName,String targetUser1,String targetUser2,HttpSession session) {
		String userEmail = (String)session.getAttribute("userEmail");
		Member member = mService.getMemberByEmail(userEmail);
		//workspace 생성
		wService.addWorkspace(member.getNum(), wsName);
		//targetUser들에게 초대메일 보내기
		return "redirect:workspace";
	}
}
