package controller;


import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import mail.MailSend;
import model.EmailVerify;
import service.MemberService; 

@Controller
public class MemberController {
	
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
	
//	
//	@RequestMapping(value="/joinStep2", method = RequestMethod.POST)
//	public String JoinStep2() {
//		
//		return "/join/joinStep2";
//	}
	
	@ResponseBody
	@RequestMapping(value="/checkVerifyCode")
	public boolean checkVerifyCode(String inputVerifyCode, HttpSession session) {
		String emailAddress = (String)session.getAttribute("emailAddress");
		String verifyCode = (String)session.getAttribute("verifyCode");
		session.setAttribute("inputVerifyCode", inputVerifyCode);
		
//		EmailVerify emailVerify = memberService.getEmailVerify(emailAddress);

//		System.out.println("emailAddress : "+emailAddress+" emailVerify : "+emailVerify);
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
	
	@RequestMapping(value="/loginForm", method = RequestMethod.GET)
	public String showLoginForm() {
		return "/login/loginForm";
	}
	@RequestMapping(value="/testMail", method = RequestMethod.POST)
	public String testMail(String emailAddress, Model model, HttpSession session) {
		session.setAttribute("emailAddress", emailAddress); //세션에 이메일 저장(30분)
		/* model.addAttribute("emailAddress", emailAddress); */
		MailSend ms = new MailSend();
		String tmpCode = ms.MailSend(emailAddress);
		if(tmpCode != null) {
			session.setAttribute("verifyCode", tmpCode);
			System.out.println("인증 코드1 : "+tmpCode);
		}
		return "redirect:joinStep2";
	}
	
	@RequestMapping(value="/testMail2", method = RequestMethod.GET)
	public String testMail2(HttpSession session) {
		String emailAddress = (String)session.getAttribute("emailAddress");
		MailSend ms = new MailSend();
		String tmpCode = ms.MailSend(emailAddress);
		if(tmpCode != null) {
			session.setAttribute("verifyCode", tmpCode);
			System.out.println("인증 코드 재발송 : "+tmpCode);
		}
		return "redirect:joinStep2";
	}
}
