package controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import mail.MailSend;
import model.ChatRoom;
import model.ChatRoomMember;
import model.Member;
import model.WsMember;
import service.ChatRoomMemberService;
import service.ChatRoomService;
import service.MemberService;
import service.WsMemberService;

@Controller
public class ChatRoomController {
	@Autowired
	private ChatRoomService crService;
	@Autowired
	private ChatRoomMemberService crmService;
	@Autowired
	private MemberService mService;
	@Autowired
	private WsMemberService wsmService;
	//전체채팅방으로 이동
	@RequestMapping("/chatMain")
	public String showChatMain(HttpSession session,int crNum, Model model) {
		ChatRoom chatRoom = crService.getChatRoomByCrNum(crNum);
		model.addAttribute("chatRoom", chatRoom);
		
		//해당 workspace에 참여중인 멤버들 정보도 model에 담아야한다.
		List<WsMember> wsmList = wsmService.getAllWsMemberByCrNum(crNum); //해당 채팅방 wsm 리스트를 꺼내와서
		List<Member> wsMemberList = new ArrayList<Member>();
		int wNum = 0;
		
		for(WsMember wsm : wsmList) { //wsm리스트에 있는 멤버들 길이만큼 돌면서
			Member member = mService.getMember(wsm.getmNum()); //멤버하나를 wsm리스트의 mNum으로 조회하고
			ChatRoomMember crm = crmService.getChatRoomMemberByAnother(crNum, wsm.getwNum(),member.getNum());
			if(crm==null) { //그 멤버가 채팅방에 없으면
				wsMemberList.add(member);//그 멤버를 진짜 멤버리스트(아이디를 담고있는 리스트)로 바꿈				
			}
			wNum = wsm.getwNum();
		}
		model.addAttribute("wsMemberList", wsMemberList);
		model.addAttribute("wNum", wNum);
		//해당 채팅방의 wNum 정보를 통해 wNum의 모든 채팅방리스트를 꺼내야한다.
		session.setAttribute("currWnum", wNum);
		List<ChatRoom> chatRoomList = crService.getAllChatRoomByWnum(wNum);
		model.addAttribute("chatRoomList", chatRoomList);
		
		return "/chatting/chatMain";
	}
	@RequestMapping("/addChat")
	public String addChatRoom(int wNum,String crName,HttpSession session,HttpServletRequest request) {
		//현재 로그인하고 채팅방만드는 사람을 chatroom member로 넣어준다
		Member member = (Member)session.getAttribute("user");
		int mNum = member.getNum();
		int crNum = crService.addChatRoom(wNum, mNum, crName);//세션에 저장된 wNum, mNum 을가져와야한다.
		
		for(String stringMnum : request.getParameterValues("mNumList")) {
			//멤버초대 체크리스트로 선택된 member들의 Num
			int num = Integer.parseInt(stringMnum);
			//그 member의 num을 이용해서 chatRoomMember로 넣어준다.
			crmService.addChatRoomMember(crNum, num, wNum);
		}
		
		
		return "redirect:workspace";
	}
	@RequestMapping("/inviteChatMember")
	public String inviteChatMember(int crNum,int wNum,HttpSession session,HttpServletRequest request) {
		for(String mNum : request.getParameterValues("wsmList")) {
			Member member = mService.getMember(Integer.parseInt(mNum));
			crmService.addChatRoomMember(crNum, member.getNum(), wNum);
		}
		return "redirect:chatMain?crNum="+crNum;
	}
}
