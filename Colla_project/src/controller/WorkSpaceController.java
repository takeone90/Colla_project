package controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import controller.MemberController.inner;
import mail.MailSend;
import model.ChatRoom;
import model.Member;
import model.Workspace;
import model.WorkspaceInvite;
import model.WsMember;
import service.AlarmService;
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
	private SimpMessagingTemplate smt;
	@Autowired
	private AlarmService aService;
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
			ChatRoom defaultChatRoom = crService.getDefaultChatRoomByWnum(wNum);
			wsMap.put("wsInfo", wsList.get(i));
			wsMap.put("crList", crService.getAllChatRoomByWnumMnum(wNum, user.getNum()));
			wsMap.put("mList", mService.getAllMemberByWnum(wNum));
			wsMap.put("defaultCrNum",defaultChatRoom.getCrNum());
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
	public String addWs(String wsName,HttpSession session,HttpServletRequest request) {
		//현재 로그인된 생성자를 워크스페이스에 담으면서 생성
		String[] targetUserList = request.getParameterValues("targetUserList");
		String userEmail = (String)session.getAttribute("userEmail");
		Member member = mService.getMemberByEmail(userEmail);
		int wNum = wService.addWorkspace(member.getNum(), wsName);
		if(targetUserList!=null) {
			for(String targetUser:targetUserList) {
				//targetUser들에게 초대메일 보내기 해야함
				wiService.addWorkspaceInvite(targetUser, wNum);
				Thread innerTest = new Thread(new inner(targetUser,wNum));
				innerTest.start();	
			}
		}
		return "redirect:workspace";
	}
	
	
	//워크스페이스에 멤버 초대하는부분
	@RequestMapping("/inviteMember")
	public String inviteMember(int wNum,HttpSession session,HttpServletRequest request) {
		//ws초대 여부를 db에 담는다
		String[] targetUserList = request.getParameterValues("targetUserList");
		for(String targetUser:targetUserList) {
			wiService.addWorkspaceInvite(targetUser, wNum);
			Thread innerTest = new Thread(new inner(targetUser,wNum));
			innerTest.start();
		}
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
	
	@ResponseBody
	@RequestMapping("/exitWs")
	public void exitWs(@RequestParam("thisWnum")int wNum,HttpSession session) {
		Member member = (Member)session.getAttribute("user");
		wsmService.removeWsMember(wNum, member.getNum());
		//mNum과 wNum을 이용해서 모든 chatRoomMember값을 지운다
		crmService.removeChatRoomMemberByWnumMnum(wNum, member.getNum());
		//exit 한사람이 chatroom의 생성자일지라도 그 chatroom 은 지워지지 않는다.
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
			String tmpCode = 
					"<body>\r\n" + 
					"	<div style='background-color: #4D4B4C; width: 760px; margin: 50px auto'>\r\n" + 
					"		<h1 style='background-color: white'>\r\n" + 
					"			<a href=\"#\"><img style='width: 150px' src=\"http://localhost:8081/Colla_project/img/COLLA_LOGO_200px.png\" /></a>\r\n" + 
					"		</h1>\r\n" + 
					"		<div>\r\n" + 
					"			<img style='width: 100%'src='http://localhost:8081/Colla_project/img/COLLA_WAVE_PNG.png'>\r\n" + 
					"		</div>\r\n" + 
					"		<div\r\n" + 
					"			style='background-color: #4D4B4C; width: 100%; height: 500px; background-image: url(\"http://localhost:8081/Colla_project/img/Main_background.jpg\"); background-size: cover;'>\r\n" + 
					"			<p style='font-size: 15px;color: white;text-align: center;width: 100%;padding-top: 180px;'>\r\n" + 
					"				워크스페이스 초대를 수락하려면 아래 버튼을 누르세요 </p>\r\n" + 
					"				<div>\r\n" + 
					"					<div style=\"background-color: rgba(255, 255, 255,0.2);width: 120px;border-radius: 10px;margin: 10px auto;text-align:center;\">\r\n" + 
					"						<a  style='color: #EB6C62;font-size: 25px;font-weight: bolder; line-height: 40.5px; text-decoration:none;' href='http://localhost:8081/Colla_project/addMember?id="+emailAddress+"&wNum="+wNum+"'> 초대 수락</a>\r\n" + 
					"					</div>\r\n" + 
					"				</div> \r\n" + 
					"		</div>\r\n" + 
					"		<div style='width: 100%;background-color: #EFEEEE;text-align: center;font-size: 13px;padding-top: 20px;padding-bottom: 50px;'>\r\n" + 
					"			<div style='display: inline-block; padding-right: 15px; position: relative; vertical-align: middle; line-height: 1.9; font-weight: 500; color: #767676;'>\r\n" + 
					"				<p><span style='padding-left: 15px'>(주)질수없조</span><span style='padding-left: 15px'>명예이사 : 임창목</span><span style='padding-left: 15px'>사업자등록번호 : 1990-09-17</span></p>\r\n" + 
					"				<p><span>Republic of Korea</span><span>459, Gangnam-daero, Seocho-gu, Seoul</span></p>\r\n" + 
					"			</div>\r\n" + 
					"			<div>\r\n" + 
					"				<p style=\"font-size: 14px; font-weight: 300; letter-spacing: 0.025em; line-height: 1.75; color: #767676; display: inline-block;\">© 2019 NeverLose systems inc. All rights reserved.</p>\r\n" + 
					"			</div>\r\n" + 
					"		</div>\r\n" + 
					"	</div>\r\n" + 
					"</body>";
			ms.MailSend(emailAddress, tmpCode, "inviteWs");
		}
	}
}
