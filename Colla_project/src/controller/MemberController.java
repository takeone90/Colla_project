package controller;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import model.Member;
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
	public String join(Member member, Model model, HttpServletRequest request) {
		boolean result = memberService.addMember(member);
		String url = request.getContextPath()+"login";
		String msg = "회원가입 실패";
		if(result) {
			msg = "회원가입 성공! 로그인 후 사용하세요!";
		}
		model.addAttribute("url",url);
		model.addAttribute("msg",msg);
		return "result";
	}
	
	//로그인 페이지
	@RequestMapping(value = "loginForm", method = RequestMethod.GET)
	public String loginForm() {
		return "login";
	}
	
	//로그아웃 로직
	
	//회원정보수정 페이지
	//회원정보수정 로직
	
	//회원 탈퇴 로직
	
}
