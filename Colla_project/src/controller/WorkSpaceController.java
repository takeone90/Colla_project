package controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import model.ChatRoom;
import model.Member;
import model.Workspace;
import model.WsMember;
import service.ChatRoomService;
import service.MemberService;
import service.WorkspaceService;
import service.WsMemberService;

@Controller
public class WorkSpaceController {
	@Autowired
	private MemberService mService;
	@Autowired
	private WorkspaceService wService;
	@Autowired
	private WsMemberService wsService;
	@Autowired
	private ChatRoomService crService;
	@RequestMapping("/workspace")
	public String showWsMain(Principal principal,HttpSession session,Model model) {
		//Ws메인이 보여질때 시큐리티가 갖고있는 principal 정보의 userid 를 가져와서
		String userEmail = principal.getName();
		//세션에 그 userEmail저장하고
		session.setAttribute("userEmail", userEmail);
		//이메일을 기반으로 멤버하나를 찾는다
		Member user = mService.getMemberByEmail(userEmail);
		session.setAttribute("user", user);
		//session에 user와 userEmail이 같이 담긴 상태
		
		List<Workspace> wsList = wService.getWsListByMnum(user.getNum());//유저 번호로 WS 들을 모두 꺼낸다.
		model.addAttribute("wsList", wsList);
		int wNum = 23; //선택한 workspace 번호 ->접혀있는 리스트를 누르면 나오게해야한다.                                  임시 테스트 workspace번호 23
		List<Member> mList = mService.getAllMemberByWnum(wNum);
		model.addAttribute("mList", mList);
		//해당 workspace의 모든 chatRoomList
		List<ChatRoom> crList = crService.getAllChatRoomByWnum(wNum);
		model.addAttribute("crList",crList);
		return "/workspace/wsMain";
	}
	
	//workspace가 선택됐을때(클릭만 되도) workspace의 wNum을 넘기는 뭔가가 필요하다!! 0825 12:44 수빈
	
	
	@RequestMapping("/chatMain")
	public String showChatMain(HttpSession session) { //HttpSession session,int wNum
//		session.setAttribute("currWnum", wNum); //워크스페이스 번호를 세션에 저장
		return "/chatting/chatMain";//뒤에 ?붙여서 파라미터로 채팅방번호로!
	}
	
	
	
	@RequestMapping("/addWs")
	public String addWs(String wsName,String targetUser1,String targetUser2,HttpSession session) {
		String userEmail = (String)session.getAttribute("userEmail");
		Member member = mService.getMemberByEmail(userEmail);
		//workspace 생성
		wService.addWorkspace(member.getNum(), wsName);
		//targetUser들에게 초대메일 보내기
		return "redirect:workspace";
	}
}
