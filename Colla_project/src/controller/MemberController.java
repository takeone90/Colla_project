package controller;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.aspectj.apache.bcel.classfile.InnerClass;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import mail.MailSend;
import model.EmailVerify;
import model.Member;
import service.MemberService; 

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
	
	@RequestMapping(value="/loginForm", method = RequestMethod.GET)
	public String showLoginForm() {
		return "/login/loginForm";
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
	//회원가입 완료시키기
	@RequestMapping(value="/joinMember", method = RequestMethod.POST)
	public String joinMember(Member member) {
		boolean result = memberService.addMember(member.getEmail(), member.getName(), member.getPw());
		if(result) {
			return "redirect:main";
		} else {
			return "/join/joinStep3"; //실패 시 어디로 갈지는 정의 필요
		}
	}
	//인증코드 
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
}
