package controller;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

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
	
	@RequestMapping(value="/joinStep3", method = RequestMethod.GET)
	public String showJoinStep3() {
		return "/join/joinStep3";
	}
	
	@RequestMapping(value="/loginForm", method = RequestMethod.GET)
	public String showLoginForm() {
		return "/login/loginForm";
	}
	@RequestMapping("/testMail")
	public String testMail(String emailAddress,Model model,HttpSession session) {
		session.setAttribute("emailAddress", emailAddress);//세션에 이메일 저장(30분)
		model.addAttribute("emailAddress", emailAddress);
		return "/join/test_mail";
	}
}
