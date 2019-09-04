package controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import mail.MailSend;
import model.ChatMessage;
import model.ChatRoom;
import model.ChatRoomMember;
import model.Member;
import model.WsMember;
import service.ChatMessageService;
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
	private ChatMessageService cmService;
	@Autowired
	private MemberService mService;
	@Autowired
	private WsMemberService wsmService;
	
	// 전체채팅방으로 이동
	@RequestMapping("/chatMain")
	public String showChatMain(HttpSession session, int crNum, Model model) {
		ChatRoom chatRoom = crService.getChatRoomByCrNum(crNum);
		model.addAttribute("chatRoom", chatRoom);

		// 해당 workspace에 참여중인 멤버들 정보도 model에 담아야한다.
		List<WsMember> wsmList = wsmService.getAllWsMemberByCrNum(crNum); // 해당 채팅방 wsm 리스트를 꺼내와서
		List<Member> wsMemberList = new ArrayList<Member>();
		int wNum = 0;

		for (WsMember wsm : wsmList) { // wsm리스트에 있는 멤버들 길이만큼 돌면서
			Member member = mService.getMember(wsm.getmNum()); // 멤버하나를 wsm리스트의 mNum으로 조회하고
			ChatRoomMember crm = crmService.getChatRoomMemberByAnother(crNum, wsm.getwNum(), member.getNum());
			if (crm == null) { // 그 멤버가 채팅방에 없으면
				wsMemberList.add(member);// 그 멤버를 진짜 멤버리스트(아이디를 담고있는 리스트)로 바꿈
			}
			wNum = wsm.getwNum();
		}
		model.addAttribute("wsMemberList", wsMemberList);
		model.addAttribute("wNum", wNum);

		session.setAttribute("currWnum", wNum);
//		//해당 채팅방의 wNum 정보를 통해 wNum의 모든 채팅방리스트를 꺼내야한다.
//		List<ChatRoom> chatRoomList = crService.getAllChatRoomByWnum(wNum);
//		model.addAttribute("chatRoomList", chatRoomList);

		return "/chatting/chatMain";
	}

	// 채팅방 리스트 왼쪽 네비게이션에 출력
	@ResponseBody
	@RequestMapping("/getChatList")
	public List<ChatRoom> getChatList(@RequestParam("currWnum") int currWnum,HttpSession session) {
		Member user = (Member)session.getAttribute("user");
		List<ChatRoom> crList = crService.getAllChatRoomByWnumMnum(currWnum, user.getNum());
		return crList;
	}

	@ResponseBody
	@RequestMapping("/loadPastMsg")
	public List<ChatMessage> loadPastMsg(@RequestParam("crNum") int crNum) {
		List<ChatMessage> cmList = cmService.getAllChatMessageByCrNum(crNum);
		return cmList;
	}

	@RequestMapping("/addChat")
	public String addChatRoom(int wNum, String crName, HttpSession session, HttpServletRequest request) {
		// 현재 로그인하고 채팅방만드는 사람을 chatroom member로 넣어준다
		Member member = (Member) session.getAttribute("user");
		int mNum = member.getNum();
		int crNum = crService.addChatRoom(wNum, mNum, crName);// 세션에 저장된 wNum, mNum 을가져와야한다.
		String[] mNumList = request.getParameterValues("mNumList");
		if(mNumList!=null) {
			for (String stringMnum : mNumList) {
				// 멤버초대 체크리스트로 선택된 member들의 Num
				int num = Integer.parseInt(stringMnum);
				// 그 member의 num을 이용해서 chatRoomMember로 넣어준다.
				crmService.addChatRoomMember(crNum, num, wNum);
			}
		}
		

		return "redirect:chatMain?crNum="+crNum;
	}

	@RequestMapping("/inviteChatMember")
	public String inviteChatMember(int crNum, int wNum, HttpSession session, HttpServletRequest request) {
		for (String mNum : request.getParameterValues("wsmList")) {
			Member member = mService.getMember(Integer.parseInt(mNum));
			crmService.addChatRoomMember(crNum, member.getNum(), wNum);
		}
		return "redirect:chatMain?crNum=" + crNum;
	}

	// 일반메세지 받고 보내기
	@SendTo("/category/msg/{var2}")
	@MessageMapping("/send/{var1}/{var2}")
	public String sendMsg(String msg, @DestinationVariable(value = "var1") String userEmail,
			@DestinationVariable(value = "var2") String crNum) {
//		System.out.println("sendMsg 핸들러 실행");
		Member member = mService.getMemberByEmail(userEmail);
		int cmNum = cmService.addChatMessage(Integer.parseInt(crNum), member.getNum(), msg, "message");
		ChatMessage cm = cmService.getChatMessageByCmNum(cmNum);
		String jsonStr = "{\"message\":\"" + msg + "\",\"userId\":\"" + member.getName()
				+ "\",\"writeTime\":\"" + cm.getCmWriteDate()
				+ "\",\"profileImg\":\""+member.getProfileImg()
				+"\",\"isFavorite\":\"" + 0
				+"\",\"cmNum\":\""+cmNum+"\"}";
		return jsonStr;
	}

	// 파일메세지 받고 보내기
	@SendTo("/category/file/{var2}")
	@MessageMapping("/sendFile/{var1}/{var2}/{var3}/{var4}")
	public String sendFileMsg(String fileName,
			@DestinationVariable(value = "var1") String userEmail,
			@DestinationVariable(value = "var2") String crNum,
			@DestinationVariable(value="var3") int cmNum,
			@DestinationVariable(value="var4")String originName) {
		System.out.println("[sendFileMsg가 받은것 ] 파일이름 : "+fileName+",originName : "+originName+",보낸사람이메일 : "+userEmail+", 채팅방번호  :"+ crNum+",cmNum : "+cmNum);
		Member member = mService.getMemberByEmail(userEmail);
		//chatFileUpload에서 나온 cmNum이 있어야한다.
		
		ChatMessage cm = cmService.getChatMessageByCmNum(cmNum);
		String jsonStr = "{\"fileName\":\"" + fileName + "\",\"originName\" : \""+originName+"\",\"userId\":\"" + member.getName()
				+ "\",\"writeTime\":\"" + cm.getCmWriteDate()
				+ "\",\"profileImg\":\""+member.getProfileImg()
				+"\",\"isFavorite\":\""+0
				+"\",\"cmNum\":\""+cmNum+"\"}";
		return jsonStr;
	}
	
	//uploadFile ajax 요청을 받으면, db에 해당 메세지를 저장하고 c:\temp\에 파일 저장함
	@ResponseBody
	@RequestMapping("/uploadFile")
	public String chatFileUpload(MultipartHttpServletRequest request,int crNum,HttpSession session) throws IOException, ServletException {
		Iterator<String> itr = request.getFileNames();
		Member user = (Member)session.getAttribute("user");
		if (itr.hasNext()) {
			MultipartFile file = request.getFile(itr.next());
//			System.out.println("파일 이름 : "+file.getOriginalFilename());
//			System.out.println("파일 길이 : " + file.getBytes().length);
			String saveName = cmService.addFile(request, user);
			int cmNum = cmService.addChatMessage(crNum, user.getNum(), saveName, "file");
			String jsonStr = "{\"cmNum\":\"" + cmNum + "\",\"fileName\":\"" + saveName + "\",\"originName\":\""+file.getOriginalFilename()+"\"}" ; 
			return jsonStr;
		} else {
			return null;
		}
	}
	
	@RequestMapping(value = "/chatFavorite", method = RequestMethod.POST)
	public void chatFavorite(int favoriteResult, int favoriteCmNum) {
	      System.out.println("favoriteResult : " + favoriteResult);
	      System.out.println("favoriteCmNum : " + favoriteCmNum);
	}
	
	@RequestMapping("/exitChatRoom")
	public String exitChatRoom(int crNum,HttpSession session){
		Member user = (Member)session.getAttribute("user");
		crmService.removeChatRoomMemberByCrNumMnum(crNum, user.getNum());
		return "redirect:workspace";
	}
	
//	@ResponseBody
//	@RequestMapping("/removeEmptyChatRoom")
//	public String removeEmptyChatRoom(){
//		System.out.println("removeEmptyChatroom 요청받음");
//		boolean result = false;
//		if(crService.removeEmptyChatRoom()) {
//			result = true;
//		}
//		System.out.println("실행되나요");
//		return "{\"result\":"+result+"}";
//	}
}
