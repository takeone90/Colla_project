package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mail.MailSend;
import model.ChatMessage;
import model.ChatRoom;
import model.Member;
import model.SetAlarm;
import model.Workspace;
import model.WorkspaceInvite;
import model.WsMember;
import service.AlarmService;
import service.ChatMessageService;
import service.ChatRoomMemberService;
import service.ChatRoomService;
import service.MemberService;
import service.ProjectMemberService;
import service.ProjectService;
import service.SetAlarmService;
import service.SystemMsgService;
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
	@Autowired
	private SetAlarmService saService;
	@Autowired
	private ProjectService pService;
	@Autowired
	private ProjectMemberService pmService;
	@Autowired
	private ChatMessageService cmService;
	@Autowired
	private SystemMsgService smService;
	
	
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
			wsMap.put("pjList",pService.getAllProjectByMnumWnum(user.getNum(), wNum));
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
		String[] targetUserArray = request.getParameterValues("targetUserList");
		List<Member> targetUserList = new ArrayList<Member>();
		Member member = (Member)session.getAttribute("user");
		int wNum = wService.addWorkspace(member.getNum(), wsName);
		for(int i=0;i<targetUserArray.length;i++) {
			if(targetUserArray[i].length()!=0) {
				String targetUser = targetUserArray[i];
				if(mService.getMemberByEmail(targetUser)!=null) {
					//기존 유저면
					Member tu = mService.getMemberByEmail(targetUser);
					targetUserList.add(tu);
					wiService.addWorkspaceInvite(targetUser, wNum);
					Thread innerTest = new Thread(new inner(targetUser,wNum));
					innerTest.start();
					
					if(tu.getNum()!=member.getNum()) {
						//나한텐 알림X
						int aNum = aService.addAlarm(wNum, tu.getNum(), member.getNum(), "wInvite", 0);
						smt.convertAndSend("/category/alarm/"+tu.getNum(),aService.getAlarm(aNum));								
					}	
				}else {
					//기존유저가 아니면
					wiService.addWorkspaceInvite(targetUser, wNum);
					Thread innerTest = new Thread(new inner(targetUser,wNum));
					innerTest.start();
				}
			}
		}
		return "redirect:workspace";
	}

	//워크스페이스에 멤버 초대하는부분
	@RequestMapping("/inviteMember")
	public String inviteMember(int wNum,HttpSession session,HttpServletRequest request,HttpServletResponse response) throws IOException {
		//ws초대 여부를 db에 담는다
		response.setContentType("text/html; charset=UTF-8");
		Member user = (Member)session.getAttribute("user");
		String[] targetUserArray = request.getParameterValues("targetUserList");
		for(int i=0;i<targetUserArray.length;i++) {
			if(targetUserArray[i].length()==0) {
				PrintWriter out = response.getWriter();
				out.println("<script>alert('초대할 유저의 이메일을 입력하세요');</script>");
				out.flush();
				return "/workspace/wsMain";	
			}
		}	

		List<Member> targetUserList = new ArrayList<Member>();
		List<WsMember> wsmList = wsmService.getAllWsMemberByWnum(wNum);
		List<Member> existingMemberList = new ArrayList<Member>();
		//원래 그 워크스페이스에 있는 멤버..
		for(WsMember wsm : wsmList) {
			Member existMember = mService.getMember(wsm.getmNum());
			existingMemberList.add(existMember);
		}
		//받아온 targetUserArray만큼 돌면서
		for(String targetUser:targetUserArray) {
			//targetUser한명당 existMember한명이랑 비교해서
			boolean isExist = false;
			for(Member existMember : existingMemberList) {
				//현재 targetUser의 이메일이 existMember 이메일과 일치하지 않으면
				if(targetUser.equals(existMember.getEmail())) {
					//진짜 타겟유저인 tu를 만들고 초대메일보내고 targetUserList에 담는다
					isExist = true;
					break;
				}
			}
			if(isExist) {
				continue;
			}else {
				Member tu;
				if((tu = mService.getMemberByEmail(targetUser)) != null) {
					//메일 보낸 targetUserList 사람들에게 알림도 보내기
					if(tu.getNum()!=user.getNum()) {
						//나한텐 알림X
						SetAlarm setAlarm = saService.getSetAlarm(tu.getNum());
						if(setAlarm.getWorkspace()==1) {
							int aNum = aService.addAlarm(wNum, tu.getNum(), user.getNum(), "wInvite", 0);
							smt.convertAndSend("/category/alarm/"+tu.getNum(),aService.getAlarm(aNum));
						}
					}
				}
				wiService.addWorkspaceInvite(targetUser, wNum);
				Thread innerTest = new Thread(new inner(targetUser,wNum));
				innerTest.start();
			}
		}
		return "redirect:workspace";
	}
	
	//워크스페이스 초대에 수락하는부분
	@RequestMapping("/addMember")
	public String addMember(String id,int wNum,HttpSession session) {
		Member user= (Member)session.getAttribute("user");
		String userEmail = id;
		//targetUser랑 wNum으로 ws 초대정보를 불러와야한다.
		List<WorkspaceInvite> wiList = wiService.getWorkspaceInviteByTargetUser(userEmail,wNum);
		WorkspaceInvite wi = wiList.get(0);
		if(wi!=null) {
			System.out.println("여기 진입");
			if(mService.getMemberByEmail(userEmail)!=null) {
				//회원이다.
				Member member = mService.getMemberByEmail(userEmail);
				wsmService.addWsMember(wNum, member.getNum()); 
				int crNum = (wsmService.getDefaultChatRoomByWnum(wNum)).getCrNum(); //기본채팅방 번호 하나 생성
				ChatMessage cm = smService.joinChatRoom(crNum, member);
				smt.convertAndSend("/category/systemMsg/"+ crNum, cm);
				wiService.removeWorkspaceInvite(userEmail, wNum);
				if(user!=null && user.getEmail().equals(userEmail)) {
					//회원이고 현재 사용자면
					return "redirect:workspace";
				}else {
					return "redirect:loginForm";					
				}
			}else {
				//비회원이다
				System.out.println("여기 진입");
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
		
		List<WsMember> wsmList = wsmService.getAllWsMemberByWnum(wNum);
		List<ChatRoom> crList = crService.getAllChatRoomByWnum(wNum);
		for(int i=0;i<crList.size();i++) {
			int crNum = crList.get(i).getCrNum();
			ChatMessage cm = smService.exitChatRoom(crNum, member);
			smt.convertAndSend("/category/systemMsg/"+ crNum, cm);
		}
		if(wsmList.isEmpty()) {
			//사람없는 ws면 ws랑 cr,crm,p,pm,td 지우기 실행
			crService.removeAllChatRoomByWnum(wNum);
			crmService.removeChatRoomMemberByWnumMnum(wNum, member.getNum());
			pService.removeAllProjectByWnum(wNum);
			wService.removeWorkspace(wNum);
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
			String tmpCode = 
					"<body>\r\n" + 
					"	<div style='width: 760px; margin: 50px auto'>\r\n" + 
					"		<h1 style='background-color: white'>\r\n" + 
					"			<a href=\"http://www.c0lla.com\"><img style='width: 150px' src='http://www.c0lla.com/img/COLLA_LOGO_200px.png' /></a>\r\n" + 
					"		</h1>\r\n" + 
					"		<div>\r\n" + 
					"			<img style='width: 100%'src='http://www.c0lla.com/img/COLLA_WAVE_PNG.png'>\r\n" + 
					"		</div>\r\n" + 
					"		<div\r\n" + 
					"			style='width: 100%; height: 500px; background-image: url(\"http://www.c0lla.com/img/Main_background.jpg\"); background-size: cover;margin-top: -25px;'>\r\n" +
					"			<p style='font-size: 15px;color: white;text-align: center;width: 100%;padding-top: 180px;'>\r\n" + 
					"				워크스페이스 초대를 수락하려면 아래 버튼을 누르세요 </p>\r\n" + 
					"				<div>\r\n" + 
					"					<div style=\"background-color: rgba(255, 255, 255,0.2);width: 120px;border-radius: 10px;margin: 10px auto;text-align:center;\">\r\n" + 
					"						<a  style='color: #EB6C62;font-size: 18px;font-weight: bolder; line-height: 40.5px; text-decoration:none; display: block;' href='http://www.c0lla.com/addMember?id="+emailAddress+"&wNum="+wNum+"'> 초대 수락</a>\r\n" + 
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
