package controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import service.MemberService;

@Controller
public class MemberController {
	
	@Autowired
	private MemberService memberService;
	
	@RequestMapping(value="/joinStep1", method = RequestMethod.GET)
	public String showJoinStep1() {
		return "joinStep1";
	}
	
	@RequestMapping(value="/joinStep2", method = RequestMethod.GET)
	public String showJoinStep2() {
		return "joinStep2";
	}
	
	@RequestMapping(value="/joinStep3", method = RequestMethod.GET)
	public String showJoinStep3() {
		return "joinStep3";
	}
	
	@RequestMapping(value="/loginForm", method = RequestMethod.GET)
	public String showLoginForm() {
		return "loginForm";
	}
}
