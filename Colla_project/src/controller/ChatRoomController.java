package controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
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
import model.Workspace;
import model.WsMember;
import service.ChatMessageService;
import service.ChatRoomMemberService;
import service.ChatRoomService;
import service.MemberService;
import service.WorkspaceService;
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
	@Autowired
	private WorkspaceService wService;
	// 전체채팅방으로 이동
	@RequestMapping("/chatMain")
	public String showChatMain(HttpSession session, int crNum, Model model) {
		ChatRoom chatRoom = crService.getChatRoomByCrNum(crNum);
		
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
		Workspace ws = wService.getWorkspace(wNum);
		model.addAttribute("chatRoom", chatRoom);
		model.addAttribute("wsMemberList", wsMemberList);
		model.addAttribute("wNum", wNum);
		session.setAttribute("wsName", ws.getName());
		session.setAttribute("currWnum", wNum);
		session.setAttribute("sessionChatRoom", chatRoom);
		return "/chatting/chatMain";
	}
	@ResponseBody
	@RequestMapping("/searchChatList")
	public Map<String, Object> searchChatList(@RequestParam(required = false)String keyword,
			@RequestParam(defaultValue = "0")int keywordType,
			@RequestParam(defaultValue = "1")int page,
			@RequestParam("crNum")int crNum){
//		System.out.println("[검색내용 || keyword : "+keyword +", type : "+keywordType+", page : "+page+", crNum : "+crNum+"]");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("keyword",keyword);
		param.put("type",keywordType);
		param.put("page",page);
		param.put("crNum", crNum);
		Map<String, Object> result = cmService.getSearchChatMessageList(param);
		return result;
	}
	@RequestMapping("/defaultChatMain")
	public String showDefaultChatMain(int wNum, Model model,HttpSession session) {
		
		ChatRoom chatRoom = crService.getDefaultChatRoomByWnum(wNum);
		int crNum = chatRoom.getCrNum();
		// 해당 workspace에 참여중인 멤버들 정보도 model에 담아야한다.
		List<WsMember> wsmList = wsmService.getAllWsMemberByCrNum(crNum); // 해당 채팅방 wsm 리스트를 꺼내와서
		List<Member> wsMemberList = new ArrayList<Member>();
		for (WsMember wsm : wsmList) { // wsm리스트에 있는 멤버들 길이만큼 돌면서
			Member member = mService.getMember(wsm.getmNum()); // 멤버하나를 wsm리스트의 mNum으로 조회하고
			ChatRoomMember crm = crmService.getChatRoomMemberByAnother(crNum, wsm.getwNum(), member.getNum());
			if (crm == null) { // 그 멤버가 채팅방에 없으면
				wsMemberList.add(member);// 그 멤버를 진짜 멤버리스트(아이디를 담고있는 리스트)로 바꿈
			}
			wNum = wsm.getwNum();
		}
		Workspace ws = wService.getWorkspace(wNum);
		session.removeAttribute("wsName");
		session.removeAttribute("currWnum");
		session.removeAttribute("sessionChatRoom");
		session.setAttribute("wsName", ws.getName());
		session.setAttribute("currWnum", ws.getNum());
		session.setAttribute("sessionChatRoom", chatRoom);
		model.addAttribute("chatRoom", chatRoom);
		model.addAttribute("wsMemberList", wsMemberList);
		model.addAttribute("wNum", wNum);
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
		System.out.println("요청받음 crNum : "+crNum+",wNum : "+wNum);
		for (String mNum : request.getParameterValues("wsmList")) {
			Member member = mService.getMember(Integer.parseInt(mNum));
			crmService.addChatRoomMember(crNum, member.getNum(), wNum);
		}
		return "redirect:chatMain?crNum=" + crNum;
	}
	
	@ResponseBody
	@RequestMapping("/showMemberListInChatRoom")
	public Object showMemberListInChatRoom(@RequestParam("wNum")int wNum,@RequestParam("crNum")int crNum,Model model) {
		//여기서 현재 채팅방 멤버와 채팅방에 없는 멤버 리스트로 나눠서 뿌려야된다.
		//채팅방에 없는 워크스페이스 멤버 리스트
		List<Member> wsmList = mService.getAllNotMemberByWnumCrNum(wNum,crNum);
		//채팅방에 있는 워크스페이스 멤버 리스트
		List<Member> crmList = mService.getAllMemberByCrNum(crNum); 
		Map<String, Object> listMap = new HashMap<String, Object>();
		listMap.put("wsmList", wsmList);
		listMap.put("crmList", crmList);
		return listMap;
	}
	
	

	@ResponseBody
	@RequestMapping("/loadPastMsg")
	public List<ChatMessage> loadPastMsg(@RequestParam("crNum") int crNum,HttpSession session) {
		Member member = (Member)session.getAttribute("user");
		int mNum = member.getNum();
		List<ChatMessage> cmList = cmService.getAllChatMessageByCrNum(crNum,mNum);
		return cmList;
	}
	// 일반메세지 받고 보내기
	@SendTo("/category/msg/{var2}")
	@MessageMapping("/send/{var1}/{var2}")
	public ChatMessage sendMsg(String msg,
			@DestinationVariable(value = "var1") String userEmail,
			@DestinationVariable(value = "var2") String crNum) {
		Member member = mService.getMemberByEmail(userEmail);
		int cmNum = cmService.addChatMessage(Integer.parseInt(crNum), member.getNum(), msg, "message");
		ChatMessage cm = cmService.getChatMessageByCmNum(cmNum);
//		System.out.println("cm :" + cm);
		return cm;
	}
	// 코드메세지 받고 보내기
	@SendTo("/category/code/{var2}")
	@MessageMapping("/sendCode/{var1}/{var2}/{var3}")
	public ChatMessage sendCode(String code,
			@DestinationVariable(value="var1")String userEmail,
			@DestinationVariable(value="var2")String crNum,
			@DestinationVariable(value="var3")String type) {
		Member member = mService.getMemberByEmail(userEmail);
		if(type.equals("java")) {
			type = "text/x-java";
		}
//		System.out.println("code : "+code+", type : "+type+", crNum : "+crNum+", mNum : "+member.getNum());
		int cmNum = cmService.addChatMessage(Integer.parseInt(crNum), member.getNum(), code, "code_"+type);
		ChatMessage cm = cmService.getChatMessageByCmNum(cmNum);
		
		return cm;
	}
	// 파일메세지 받고 보내기
	@SendTo("/category/file/{var2}")
	@MessageMapping("/sendFile/{var1}/{var2}/{var3}/{var4}")
	public ChatMessage sendFileMsg(String fileName,
			@DestinationVariable(value = "var1") String userEmail,
			@DestinationVariable(value = "var2") String crNum,
			@DestinationVariable(value="var3") int cmNum,
			@DestinationVariable(value="var4")String originName) {
		ChatMessage cm = cmService.getChatMessageByCmNum(cmNum);
		return cm;
	}
	// Map메세지 받고 보내기
		@SendTo("/category/map/{var2}")
		@MessageMapping("/sendMap/{var1}/{var2}")
		public ChatMessage sendMap(String addressId,
				@DestinationVariable(value = "var1") String userEmail,
				@DestinationVariable(value = "var2") String crNum) {
			Member member = mService.getMemberByEmail(userEmail);
			int cmNum = cmService.addChatMessage(Integer.parseInt(crNum), member.getNum(), addressId, "map");
			ChatMessage cm = cmService.getChatMessageByCmNum(cmNum);
			return cm;
		}

	//uploadFile ajax 요청을 받으면, db에 해당 메세지를 저장하고 c:\temp\에 파일 저장함
	@ResponseBody
	@RequestMapping("/uploadFile")
	public String chatFileUpload(MultipartHttpServletRequest request,int crNum,HttpSession session) throws IOException, ServletException {
		Iterator<String> itr = request.getFileNames();
		Member user = (Member)session.getAttribute("user");
		if (itr.hasNext()) {
			MultipartFile file = request.getFile(itr.next());
			String saveName = cmService.addFile(request, user);
			int cmNum = cmService.addChatMessage(crNum, user.getNum(), saveName, "file");
			String jsonStr = "{\"cmNum\":\"" + cmNum + "\",\"fileName\":\"" + saveName + "\",\"originName\":\""+file.getOriginalFilename()+"\"}" ; 
			return jsonStr;
		} else {
			return null;
		}
	}
	
	@ResponseBody
	@RequestMapping(value = "/chatFavorite", method = RequestMethod.POST)
	public void chatFavorite(int favoriteResult, int cmNum, HttpSession session) {
	      Member member = (Member)session.getAttribute("user");
	      int mNum = member.getNum();
	      cmService.modifyChatFavorite(favoriteResult, mNum, cmNum);     
	}
	
	@ResponseBody
	@RequestMapping(value = "/showChatFavoriteList", method = RequestMethod.POST)
	public List<ChatMessage> showChatFavoriteList(@RequestParam("crNum") int crNum,HttpSession session) {
		Member member = (Member)session.getAttribute("user");
		int mNum = member.getNum();
		return cmService.getChatFavoriteList(crNum, mNum);
	}
		
	@RequestMapping("/exitChatRoom")
	public String exitChatRoom(int crNum,HttpSession session){
		Member user = (Member)session.getAttribute("user");
		crmService.removeChatRoomMemberByCrNumMnum(crNum, user.getNum());
		return "redirect:workspace";
	}

	
}
