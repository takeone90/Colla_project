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
	@Autowired
	private MemberService memberService;
	
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
				System.out.println("인증 코드1 : "+tmpCode);
			}
		}
	}

	@RequestMapping(value="/testMail", method = RequestMethod.GET)
	public String testMail(HttpSession session) {
//		session.setAttribute("emailAddress", emailAddress); //세션에 이메일 저장(30분)
//		model.addAttribute(emailAddress);
		String emailAddress = (String)session.getAttribute("emailAddress");
		Thread innerTest = new Thread(new inner(emailAddress, session));
		innerTest.start();
//		MailSend ms = new MailSend();
//		String tmpCode = ms.MailSend(emailAddress);
//		if(tmpCode != null) {
//			session.setAttribute("verifyCode", tmpCode);
//			System.out.println("인증 코드1 : "+tmpCode);
//		}
		return "redirect:joinStep2";
	}
	@RequestMapping(value="/testMail2", method = RequestMethod.GET)
	public String testMail2(HttpSession session) {
		String emailAddress = (String)session.getAttribute("emailAddress");
		Thread innerTest = new Thread(new inner(emailAddress, session));
		innerTest.start();
//		MailSend ms = new MailSend();
//		String tmpCode = ms.MailSend(emailAddress);
//		if(tmpCode != null) {
//			session.setAttribute("verifyCode", tmpCode);
//			System.out.println("인증 코드 재발송 : "+tmpCode);
//		}
		return "redirect:joinStep2";
	}
	
	@ResponseBody
	@RequestMapping(value="/emailDuplicationCheck", method = RequestMethod.POST)
	public boolean emailDuplicationCheck(String emailAddress, HttpSession session) {
		System.out.println("emailAddress : "+emailAddress);
		System.out.println("emailAddress : "+emailAddress);
		
		if(memberService.getMemberByEmail(emailAddress) != null) {
			return true;
		} else {
			session.setAttribute("emailAddress", emailAddress);
			return false;
		}
	}
	
	@RequestMapping(value="/joinStep1", method = RequestMethod.GET)
	public String showJoinStep1() {
		return "/join/joinStep1";
	}
	@RequestMapping(value="/joinStep2", method = RequestMethod.GET)
	public String showJoinStep2() {
		return "/join/joinStep2";
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
	@RequestMapping(value="/joinStep3", method = RequestMethod.GET)
	public String showJoinStep3() {
		return "/join/joinStep3";
	}
	@RequestMapping(value="/joinMember", method = RequestMethod.POST)
	public String joinMember(Member member) {
		boolean result = memberService.addMember(member.getEmail(), member.getName(), member.getPw());
		if(result) {
			return "redirect:main";
		} else {
			return "/join/joinStep3"; //실패 시 어디로 갈지는 정의 필요
		}
	}
	@RequestMapping(value="/loginForm", method = RequestMethod.GET)
	public String showLoginForm() {
		return "/login/loginForm";
	}

}
