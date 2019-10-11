package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import model.Alarm;
import model.ChatMessage;
import model.ChatRoom;
import model.ChatRoomMember;
import model.Member;
import model.Workspace;
import model.WsMember;
import service.AlarmService;
import service.ChatMessageService;
import service.ChatRoomMemberService;
import service.ChatRoomService;
import service.MemberService;
import service.SystemMsgService;
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
	@Autowired
	private SimpMessagingTemplate smt;
	@Autowired
	private AlarmService aService;
	@Autowired
	private SystemMsgService smService;
	
	@Resource(name = "connectorList")
	private Map<Object,Object> connectorList;
	
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
		session.setAttribute("currWnum", wNum);
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
	
	@ResponseBody
	@RequestMapping("/addOneOnOne")
	public int addOneOnOne(int mNum, HttpSession session) {	//1:1채팅방 생성 후 초대
		Member I = (Member)session.getAttribute("user"); //나
		Member you = mService.getMember(mNum); //타겟
		int wNum = (int)session.getAttribute("currWnum");
		Alarm alarm;
		if( (alarm = crService.addOneOnOne(wNum, I, you)) != null ) {
			smt.convertAndSend("/category/alarm/"+you.getNum(), aService.getAlarm(alarm.getaDnum()));
			return alarm.getaDnum();
		}else {
			return -1;
		}
	}
	
	@RequestMapping("/addChat")
	public String addChatRoom(int wNum, String crName, HttpSession session, HttpServletRequest request) {
		// 현재 로그인하고 채팅방만드는 사람을 chatroom member로 넣어준다
		Member member = (Member) session.getAttribute("user");
		int mNum = member.getNum();
		int crNum = crService.addChatRoom(wNum, mNum, crName);
		String[] mNumList = request.getParameterValues("mNumList");
		if(mNumList!=null) {
			for (String stringMnum : mNumList) {
				int num = Integer.parseInt(stringMnum);
				crmService.addChatRoomMember(crNum, num, wNum);
				int aNum = aService.addAlarm(wNum, num, member.getNum(), "cInvite", crNum);
				smt.convertAndSend("/category/alarm/"+num, aService.getAlarm(aNum));
			}
		}
		return "redirect:chatMain?crNum="+crNum;
	}
	@RequestMapping("/inviteChatMember")
	public String inviteChatMember(int crNum, int wNum, HttpSession session, HttpServletRequest request) {
		// onclick='sendAlarm(${sessionScope.currWnum},멤버들 번호,${sessionScope.user.num},'cInvite',채팅방번호);
		Member user = (Member)session.getAttribute("user");
		
		System.out.println("요청받음 crNum : "+crNum+",wNum : "+wNum);
		for (String mNum : request.getParameterValues("wsmList")) {
			Member member = mService.getMember(Integer.parseInt(mNum));
			crmService.addChatRoomMember(crNum, member.getNum(), wNum);
			ChatMessage cm = smService.joinChatRoom(crNum, member);
			smt.convertAndSend("/category/systemMsg/"+ crNum, cm);
			int aNum = aService.addAlarm(wNum, member.getNum(), user.getNum(), "cInvite", crNum);
			smt.convertAndSend("/category/alarm/"+member.getNum(),aService.getAlarm(aNum));
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
		//로그인 중인 멤버를 넣을 리스트
		List<Integer> conList = new ArrayList<Integer>();

		for( Member m : wsmList) {
			if(connectorList.containsKey(m.getEmail())) {
				conList.add(m.getNum());
			}
		}
		for( Member m : crmList) {
			if(connectorList.containsKey(m.getEmail())) {
				conList.add(m.getNum());
			}
		}
		
		Map<String, Object> listMap = new HashMap<String, Object>();
		listMap.put("wsmList", wsmList);
		listMap.put("crmList", crmList);
		listMap.put("conList", conList);
		return listMap;
	}

	@ResponseBody
	@RequestMapping("/loadMoreChat")
	public List<ChatMessage> loadMoreChat(@RequestParam("crNum") int crNum, @RequestParam("count") int count, HttpSession session){
		Member member = (Member)session.getAttribute("user");
		int mNum = member.getNum();
		System.out.println("scrollCount : " + count);
		List<ChatMessage> cmList = cmService.getMoreMessage(crNum, mNum, count);
		return cmList;
	}
	
	@ResponseBody
	@RequestMapping("/loadPastMsg")
	public List<ChatMessage> loadPastMsg(@RequestParam("crNum") int crNum,HttpSession session) {
		Member member = (Member)session.getAttribute("user");
		int mNum = member.getNum();
//		List<ChatMessage> cmList = cmService.getAllChatMessageByCrNum(crNum,mNum);
		List<ChatMessage> cmList = cmService.getRecentChatMessageByCrNum(crNum, mNum);
		return cmList;
	}
	// 일반메세지 받고 보내기
	@SendTo("/category/msg/{var2}")
	@MessageMapping("/send/{var1}/{var2}")
	public ChatMessage sendMsg(String msg,
			@DestinationVariable(value = "var1") String userEmail,
			@DestinationVariable(value = "var2") String crNum) {
		Member member = mService.getMemberByEmail(userEmail);
		msg = cmService.hyperlinkTransfer(msg);
		int cmNum = cmService.addChatMessage(Integer.parseInt(crNum), member.getNum(), msg, "message");
		ChatMessage cm = cmService.getChatMessageByCmNum(cmNum);
		
		return cm;
	}
	// 코드메세지 받고 보내기
	@SendTo("/category/msg/{var2}")
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
	@SendTo("/category/msg/{var2}")
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
		@SendTo("/category/msg/{var2}")
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
		ChatMessage cm = smService.exitChatRoom(crNum, user);
		smt.convertAndSend("/category/systemMsg/"+ crNum, cm);
		return "redirect:workspace";
	}

}
