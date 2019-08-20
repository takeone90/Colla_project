package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import service.MemberService;

@Controller
@RequestMapping("/member")
public class MemberController {

	@Autowired
	MemberService memberService;
	
	//회원가입 페이지 
	@RequestMapping(value = "join", method = RequestMethod.GET)
	public String joinForm() {
		return "joinForm";
	}
	//회원가입 로직
	@RequestMapping(value = "join", method = RequestMethod.POST)
	public String join() {
		 
		return "result";
	}
	//회원정보수정 페이지
	//회원정보수정 로직
	//로그인 페이지
	//로그인 로직
	//로그아웃 로직
	//회원 탈퇴 로직
	
}
