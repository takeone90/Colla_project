package controller;


import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;

import java.io.IOException;
import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.aspectj.apache.bcel.classfile.InnerClass;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.converter.StringMessageConverter;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SubscribeMapping;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mail.MailSend;
import model.ChatMessage;
import model.EmailVerify;
import model.Member;
import service.ChatRoomMemberService;
import service.MemberService;
import service.WsMemberService; 

@Controller
public class MemberController {
	
	//showJoinStep1():String > step1 화면 요청
	//showJoinStep2():String > step2 화면 요청
	//showJoinStep3():String > step3 화면 요청
	//showLoginForm():String > 로그인 화면 요청
	
	//checkEmailDuplication(String emailAddress, HttpSession session):boolean > step1에서 이메일 중복체크(ajax)
	//sendVerifyMail(HttpSession session):String > 인증메일 전송과 동시에 joinStep2요청을 redirect (step1에서 step2로 이동)
	//resendVerifyMail(HttpSession session):String > 인증메일 재발송 (step2 화면에서 step2 리로딩)
	//checkVerifyCode(String inputVerifyCode, HttpSession session):boolean > 인증코드 확인 
	//joinMember(Member member):String > 회원가입(멤버추가) 로직 
	
	//setCode():String > 인증메일의 코드를 생성
	//class inner > 메일전송을 쓰레드로 생성하기 위해 만든 이너클래스
	
	@Autowired
	private MemberService memberService;
	@Autowired
	private WsMemberService wsmService;
	@Autowired
	private ChatRoomMemberService crmService;
	@Autowired
	private SimpMessagingTemplate smt;

	@Resource(name = "connectorList")
	private Map<Object,String> connectorList;//빈으로 등록된 접속자명단(email, session)
	
//	private static Map<String, Object> loginMember = new HashMap<>(); //로그인한 멤버를 담기위한 map	

	@RequestMapping(value="/joinStep1", method = RequestMethod.GET)
	public String showJoinStep1() {
		return "/join/joinStep1";
	}
	
	@RequestMapping(value="/joinStep2", method = RequestMethod.GET)
	public String showJoinStep2() {
		return "/join/joinStep2";
	}
	
	@RequestMapping(value="/joinStep3", method = RequestMethod.GET)
	public String showJoinStep3() {
		return "/join/joinStep3";
	}
	
	@RequestMapping(value="/loginForm")
	public String showLoginForm() {
		return "/login/loginForm";
	}
	

	@RequestMapping(value="/callBackJoin", method = RequestMethod.GET) // 네이버 API 회원가입
	public String showCallBackJoin() {
		return "/join/callBackJoin";
	}
	
	@RequestMapping(value="/joinMemberAPI", method = RequestMethod.POST) // API 회원가입
	public String joinMemberAPI(Member member) {
		memberService.addMember(member);
		return "redirect:main";
	}
	
	@RequestMapping(value="/callBackLogin", method = RequestMethod.GET) // 네이버 API 로그인	
	public String showCallBackLogin() {
		return "/login/callBackLogin";
	}
	
	@ResponseBody
	@RequestMapping(value="/checkEmailDuplication", method = RequestMethod.POST)
	public boolean checkEmailDuplication(String emailAddress, HttpSession session) {		
		if(memberService.getMemberByEmail(emailAddress) != null) {
			return true;
		} else {
			session.setAttribute("emailAddress", emailAddress);
			return false;
		}
	}

	@RequestMapping(value="/sendVerifyMail", method = RequestMethod.GET)
	public String sendVerifyMail(HttpSession session) {
		String emailAddress = (String)session.getAttribute("emailAddress");
		Thread innerTest = new Thread(new inner(emailAddress, session));
		innerTest.start();
		return "redirect:joinStep2";
	}

	@RequestMapping(value="/resendVerifyMail", method = RequestMethod.GET)
	public String resendVerifyMail(HttpSession session) {
		String emailAddress = (String)session.getAttribute("emailAddress");
		Thread innerTest = new Thread(new inner(emailAddress, session));
		innerTest.start();
		System.out.println();
		return "redirect:joinStep2";
	}
	
	@ResponseBody
	@RequestMapping(value="/checkVerifyCode")
	public boolean checkVerifyCode(String inputVerifyCode, HttpSession session) {
		String emailAddress = (String)session.getAttribute("emailAddress");
		String verifyCode = (String)session.getAttribute("verifyCode");
		session.setAttribute("inputVerifyCode", inputVerifyCode);
		if(verifyCode.equals(inputVerifyCode)) {
			return true;
		}else {
			//false면 joinStep2 페이지 보여주는 요청생성
			return false;
		}	
	}
	
	@RequestMapping(value="/joinMember", method = RequestMethod.POST)
	public String joinMember(Member member,HttpSession session) {
		System.out.println("member : "+member);
		boolean result = memberService.addMember(member);
		
		String inviteUserEmail = (String)session.getAttribute("inviteUserEmail");
		int inviteWnum = (Integer)session.getAttribute("inviteWnum");
		
		if(inviteUserEmail!=null && member.getEmail().equals(inviteUserEmail) && session.getAttribute("inviteWnum")!=null) {
			//이게 차있다면 초대받은사람임
			//wsmember로 추가
			wsmService.addWsMember(inviteWnum, member.getNum());
			System.out.println("초대받은사람이네요 inviteUserEmail : "+inviteUserEmail+", 초대받은wNum : "+inviteWnum);
		}
		session.removeAttribute("InviteUserEmail");
		session.removeAttribute("inviteWnum");
		if(result) {
			return "redirect:main";
		} else {
			return "/join/joinStep3"; //실패 시 어디로 갈지는 정의 필요
		}
	}
	
	@RequestMapping(value="/loginDuplication", method = RequestMethod.GET)
	public String loginDuplication() {
		return "/login/loginDuplication";
	}
	
	public String setCode() {
		StringBuffer sb = new StringBuffer();
		int a = 0;
		for (int i = 0; i < 10; i++) {
			a = (int) (Math.random() * 122 + 1);
			if ((a >= 48 && a <= 57) || (a >= 65 && a <= 90) || (a >= 97 && a <= 122))
				sb.append((char) a);
			else
				i--;
		}
		return sb.toString();
	}

	//메일발송과 화면전환 처리를 위한 스레드 
	public class inner implements Runnable {
		String emailAddress;
		HttpSession session;
		public inner(String emailAddress, HttpSession session) {
			this.emailAddress = emailAddress;
			this.session = session;
		}
		@Override
		public void run() {
			MailSend ms = new MailSend();
			String tmpCode = setCode();
			ms.MailSend(emailAddress, tmpCode);
			if(tmpCode != null) {
				session.setAttribute("verifyCode", tmpCode);
			}
		}
	}
	
	public String sendConList(
			@DestinationVariable(value="wNum")int wNum
			) {
		System.out.println("중복아이디 로그아웃 메시지 전송");
		smt.convertAndSend("/category/loginMemberList/"+wNum,connectorList);
		
		return "duplicated";
	}
	public HttpSession deleteSessionFromConList(String email) {
		HttpSession session = (HttpSession)getKey(connectorList, email);
		connectorList.remove(session);
		return session;
	}
	 //중복 로그인 체크 (기존 사용자 로그아웃 처리)
	@RequestMapping("/checkLoginDuplication")
	public String checkLoginDuplication(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession();
		String userEmail = (String)request.getSession().getAttribute("userEmail");
		Member user = memberService.getMemberByEmail(userEmail);
		
		boolean isDuplicate = false;
		System.out.println("중복체크 전 접속 중인 멤버 : "+connectorList);
		
		if (getKey(connectorList, userEmail) != null) {
			isDuplicate = true; // 중복으로 로그인
		}
		
		if (!isDuplicate) { // 정상적인 로그인의 경우
			System.out.println("정상적인 로그인입니다.");
		} else { // 중복 로그인의 경우
			System.out.println("중복 로그인입니다.");
			sendLoginDuplicatedMsg(user.getNum());
			deleteSessionFromConList(userEmail);
		}
		
		connectorList.put(request.getSession(), userEmail); // 해당 email, session 추가 또는 교체
//		response.sendRedirect("/workspace"); //워크스페이스로 이동한다	
		return "redirect:workspace";
	}
	
	//회원 탈퇴버튼
	@RequestMapping("/removeMember")
	public String removeMember(HttpSession session) {
		Member member = (Member)session.getAttribute("user");
		memberService.removeMember(member.getNum()); //멤버테이블에서 해당멤버 삭제
		crmService.removeAllChatRoomMemberByMnum(member.getNum()); //chatroom_member 테이블에서 해당 멤버가 들어간 튜플 모두 제거
		wsmService.removeAllWsMemberByMnum(member.getNum()); //workspace_member 테이블에서 해당 멤버가 들어간 튜플 모두 제거
		//favorite 모델에서도 m_num을 기준으로 모두 지우는거 만들어야함
		
		return "redirect:main";
	}

	@RequestMapping("/dropSession") //로그아웃 성공 후, 처리
	public String dropSession(HttpSession session,String userEmail) {
		//loginMember.remove(session.getAttribute("userEmail"));
		session.invalidate();
		return "redirect:main";
	}
	
	/*
	 * public Map<String, Object> getLoginMemberList(){ return loginMember; }
	 */
	@ResponseBody
	@RequestMapping("/getMemberInfoForProfileImg")
	public Member getMemberInfoForProfileImg(@RequestParam("mNum")int mNum) {
		Member member = memberService.getMember(mNum);
		return member;
	}
	
	/* 맵에서 Value값으로  key 찾기*/
    public static <K, V> K getKey(Map<K, V> map, V value) {
        // 찾을 hashmap 과 주어진 단서 value
        for (K key : map.keySet()) {
            if (value.equals(map.get(key))) {
                return key;
            }
        }
        return null;
    }

	public String sendLoginDuplicatedMsg(
			@DestinationVariable(value="mNum")int mNum
			) {
		System.out.println("중복아이디 로그아웃 메시지 전송");
		smt.convertAndSend("/category/loginMsg/"+mNum,"duplicated");
		
		return "duplicated";
	}
}
