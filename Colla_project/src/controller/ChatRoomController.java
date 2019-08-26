package controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

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
		return "/chatting/chatMain";
	}
	@RequestMapping("/addChat")
	public String addChatRoom(int wNum,String crName,String targetUser1,String targetUser2,HttpSession session) {
		Member member = (Member)session.getAttribute("user");
		int mNum = member.getNum();
		crService.addChatRoom(wNum, mNum, crName);//세션에 저장된 wNum, mNum 을가져와야한다.                          
		return "redirect:workspace";
	}
	@RequestMapping("/inviteChatMember")
	public String inviteChatMember(int crNum,String targetUser,HttpSession session) {
		String userEmail = targetUser;
		Member member = mService.getMemberByEmail(userEmail);
//		targetUser가 wsMember 인지 확인후 wsMember인채로 wNum을 가져와야 chatroomMember에 추가가능
//		WsMember wsMember = wsmService.get
//		crmService.addChatRoomMember(crNum, member.getNum(), wNum)
		return "redirect:chatMain?crNum="+crNum;
	}
}
