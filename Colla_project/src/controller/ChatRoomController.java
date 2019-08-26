package controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import model.ChatRoom;
import model.Member;
import service.ChatRoomService;

@Controller
public class ChatRoomController {
	@Autowired
	private ChatRoomService crService;
	//전체채팅방으로 이동
	@RequestMapping("/chatMain")
	public String showChatMain(HttpSession session) {
		return "/chatting/chatMain";
	}
	//개별채팅방으로 이동
	@RequestMapping("/chatOther")
	public String showChatOther(int crNum,Model model) {
		ChatRoom chatRoom = crService.getChatRoomByCrNum(crNum);
		model.addAttribute("chatRoom", chatRoom);
		return "/chatting/chatOther";
	}
	@RequestMapping("/addChat")
	public String addChatRoom(int wNum,String crName,String targetUser1,String targetUser2,HttpSession session) {
		Member member = (Member)session.getAttribute("user");
		int mNum = member.getNum();
		crService.addChatRoom(wNum, mNum, crName);//세션에 저장된 wNum, mNum 을가져와야한다.                          
		return "redirect:workspace";
	}
	
}
