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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import commons.LoginList;
import controller.MemberController.inner;
import mail.MailSend;
import model.ChatRoom;
import model.Member;
import model.Workspace;
import model.WorkspaceInvite;
import model.WsMember;
import service.ChatRoomMemberService;
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
	private ChatRoomMemberService crmService;
	@Autowired
	private WorkspaceInviteService wiService;
	
	@Autowired
	private LoginList loginList;
	
	@RequestMapping("/workspace")
	public String showWsMain(Principal principal,HttpSession session,Model model) {
		//Ws메인이 보여질때 시큐리티가 갖고있는 principal 정보의 userid 를 가져와서
		String userEmail = principal.getName();
		//세션에 그 userEmail저장하고
		session.setAttribute("userEmail", userEmail);
		//이메일을 기반으로 멤버하나를 찾는다
		Member user = mService.getMemberByEmail(userEmail);//로그인한사람
		session.setAttribute("user", user);
		//session에 user와 userEmail이 같이 담긴 상태
		List<Map<String, Object>> workspaceList = new ArrayList<Map<String,Object>>();
		List<Workspace> wsList = wService.getWsListByMnum(user.getNum());//유저 번호로 WS 들을 모두 꺼낸다.
		for(int i = 0;i<wsList.size();i++) {
			int wNum = wsList.get(i).getNum();
			Map<String, Object> wsMap = new HashMap<String, Object>();
			wsMap.put("wsInfo", wsList.get(i));
			wsMap.put("crList", crService.getAllChatRoomByWnumMnum(wNum, user.getNum()));
			wsMap.put("mList", mService.getAllMemberByWnum(wNum));
			wsMap.put("mlList", loginList.getLoginList()); //로그인한 멤버 리스트
			workspaceList.add(wsMap);
		}
		model.addAttribute("workspaceList", workspaceList);
		session.setAttribute("workspaceList", workspaceList);//네비게이션 바에 셀렉터에 들어갈 session
		return "/workspace/wsMain";
	}
	
	@ResponseBody
	@RequestMapping("/thisWsMemberList")
	public List<Member> showThisWsMember(@RequestParam("wNum") int wNum) {
		
		List<WsMember> wsmList = wsmService.getAllWsMemberByWnum(wNum);
		List<Member> wsMemberList = new ArrayList<Member>();
		for(WsMember wsm : wsmList) {
			Member member = mService.getMember(wsm.getmNum());
			wsMemberList.add(member);
		}
		
		return wsMemberList;
	}
	
	//워크스페이스 추가
	@RequestMapping("/addWs")
	public String addWs(String wsName,String targetUser,HttpSession session) {
		//현재 로그인된 생성자를 워크스페이스에 담으면서 생성
		String userEmail = (String)session.getAttribute("userEmail");
		Member member = mService.getMemberByEmail(userEmail);
		int wNum = wService.addWorkspace(member.getNum(), wsName);
		if(targetUser!="" && targetUser!=null) {
			//targetUser들에게 초대메일 보내기 해야함
			wiService.addWorkspaceInvite(targetUser, wNum);
			Thread innerTest = new Thread(new inner(targetUser,wNum));
			innerTest.start();
		}
		
		return "redirect:workspace";
	}
	//워크스페이스에 멤버 초대하는부분
	@RequestMapping("/inviteMember")
	public String inviteMember(int wNum, String targetUser,HttpSession session) {
		//ws초대 여부를 db에 담는다
		wiService.addWorkspaceInvite(targetUser, wNum);
		Thread innerTest = new Thread(new inner(targetUser,wNum));
		innerTest.start();
		return "redirect:workspace";
	}
	
	
	//워크스페이스 초대에 수락하는부분
	@RequestMapping("/addMember")
	public String addMember(String id,int wNum,HttpSession session) { 
		String userEmail = id;
		//targetUser랑 wNum으로 ws 초대정보를 불러와야한다.
		WorkspaceInvite wi = wiService.getWorkspaceInviteByTargetUser(userEmail,wNum);
		if(wi!=null) {
			if(mService.getMemberByEmail(userEmail)!=null) {
				//회원이다.
				Member member = mService.getMemberByEmail(userEmail);
				wsmService.addWsMember(wNum, member.getNum());
				wiService.removeWorkspaceInvite(userEmail, wNum);
				return "redirect:loginForm";
			}else {
				//비회원이다
				session.setAttribute("inviteUserEmail", userEmail);
				session.setAttribute("inviteWnum", wNum);
				wiService.removeWorkspaceInvite(userEmail, wNum);
				return "redirect:joinStep3";
			}
		}else {
			
			return "redirect:error";
		}
		
		
	}
	
	@RequestMapping("/exitWs")
	public String exitWs(int wNum,HttpSession session) {
		Member member = (Member)session.getAttribute("user");
		wsmService.removeWsMember(wNum, member.getNum());
		//mNum과 wNum을 이용해서 모든 chatRoomMember값을 지운다
		crmService.removeChatRoomMemberByWnumMnum(wNum, member.getNum());
		//exit 한사람이 chatroom의 생성자일지라도 그 chatroom 은 지워지지 않는다.
		return "redirect:workspace";
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
