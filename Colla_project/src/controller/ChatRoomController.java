package controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import model.Member;
import service.ChatRoomService;

@Controller
public class ChatRoomController {
	@Autowired
	private ChatRoomService crService;
	@RequestMapping("/addChat")
	public String addChatRoom(String crName,String targetUser1,String targetUser2,HttpSession session) {
		Member member = (Member)session.getAttribute("user");
		int mNum = member.getNum();
		crService.addChatRoom(23, mNum, crName);//세션에 저장된 wNum, mNum 을가져와야한다.                          임시 테스트 workspace번호 23
		return "redirect:workspace";
	}
}
