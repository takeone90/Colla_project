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

import controller.MemberController.inner;
import mail.MailSend;
import model.ChatRoom;
import model.Member;
import model.Workspace;
import model.WsMember;
import service.ChatRoomService;
import service.MemberService;
import service.WorkspaceInviteService;
import service.WorkspaceService;
import service.WsMemberService;

@Controller
public class WorkSpaceController {
	@Autowired
	private MemberService mService;
	@Autowired
	private WorkspaceService wService;
	@Autowired
	private WsMemberService wsmService;
	@Autowired
	private ChatRoomService crService;
	@Autowired
	private WorkspaceInviteService wiService;
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
	
	//워크스페이스 추가
	@RequestMapping("/addWs")
	public String addWs(String wsName,String targetUser1,String targetUser2,HttpSession session) {
		String userEmail = (String)session.getAttribute("userEmail");
		Member member = mService.getMemberByEmail(userEmail);
		wService.addWorkspace(member.getNum(), wsName);
		//targetUser들에게 초대메일 보내기 해야함
		return "redirect:workspace";
	}
	
	
	//워크스페이스에 멤버 초대하는부분
	@RequestMapping("/inviteMember")
	public String inviteMember(int wNum, String targetUser,HttpSession session) {
		String emailAddress = targetUser;
		//ws초대 여부를 db에 담는다
		wiService.addWorkspaceInvite(emailAddress, wNum);
		Member member = mService.getMemberByEmail(emailAddress);
		Thread innerTest = new Thread(new inner(emailAddress,wNum));
		innerTest.start();
		return "redirect:workspace";
	}
	
	
	//워크스페이스 초대에 수락하는부분
	@RequestMapping("/addMember")
	public String addMember(String id,int wNum,HttpSession session) { 
		String userEmail = id;
		if(mService.getMemberByEmail(userEmail)!=null) {
			//회원이다.
			Member member = mService.getMemberByEmail(userEmail);
			wsmService.addWsMember(wNum, member.getNum());
			return "redirect:loginForm";
		}else {
			//비회원이다
			return "redirect:joinStep1";
		}
		
	}
	
	
	
	
	
	public class inner implements Runnable {
		String emailAddress;
		int wNum;
		public inner(String emailAddress,int wNum) {
			this.emailAddress = emailAddress;
			this.wNum = wNum;
		}
		@Override
		public void run() {
			MailSend ms = new MailSend();
			String tmpCode = "<a href='http://localhost:8081/Colla_project/addMember?id="+emailAddress+"&wNum="+wNum+"'><b>워크스페이스 초대</b>를 수락하려면 누르세요</a>";
			ms.MailSend(emailAddress, tmpCode);
		}
	}
}
