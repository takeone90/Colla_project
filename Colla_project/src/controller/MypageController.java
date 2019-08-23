package controller;

import java.security.Principal;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import model.Member;
import service.LicenseService;
import service.MemberService;

@Controller
public class MypageController {
	// myPageMainForm(Model model, Principal principal, HttpSession session):String > 마이페이지 메인화면 (로그인한 멤버 정보 출력)
	// myPageModifyForm(Model model, HttpSession session, String checkPass):String > 비밀번호 입력 화면
	// myPageCheckPassForm(String pw, HttpSession session):String > 회원정보관리 화면
	// myPageLicenseForm() 
	// myPageAlarmForm()
	// myPageCheckPass(String pw, HttpSession session):String > 비밀번호 확인 로직
	// modifyMember(Member member):String > 회원 정보 업데이트 로직
 
	@Autowired
	private MemberService memberService;
	@Autowired
	private LicenseService licenseService;
	
	@RequestMapping(value = "/myPageMainForm", method = RequestMethod.GET)
	public String myPageMainForm(Model model, Principal principal, HttpSession session) {
		String emailAddress = principal.getName();
		session.setAttribute("emailAddress", emailAddress);
		model.addAttribute("member",memberService.getMemberByEmail(emailAddress));
		return "/myPage/myPageMain";
	}

	@RequestMapping(value = "/myPageCheckPassForm", method = RequestMethod.GET)
	public String myPageCheckPassForm(String pw, HttpSession session) {
		return "/myPage/myPageCheckPass";
	}

	@RequestMapping(value = "/myPageModifyForm", method = RequestMethod.GET)
	public String myPageModifyForm(Model model, HttpSession session, String checkPass) {
		String emailAddress = (String)session.getAttribute("emailAddress");
		model.addAttribute("member",memberService.getMemberByEmail(emailAddress));
		if(checkPass!=null && checkPass.equals("fail")) {
			return "/myPage/myPageModifyForm?checkPass=fail";
		}
		return "/myPage/myPageModifyForm";
	}	
	
	@RequestMapping(value = "/myPageLicenseForm", method = RequestMethod.GET)
	public String myPageLicenseForm(HttpSession session, Model model) {
		String emailAddress = (String)session.getAttribute("emailAddress");
		int mNum = memberService.getMemberByEmail(emailAddress).getNum();
		model.addAttribute("useLicense",licenseService.getUseLicense(mNum));
		model.addAttribute("licenseList", licenseService.getLicenseList(mNum));
		return "/myPage/myPageLicense";
	}
	
	@RequestMapping(value = "/myPageAlarmForm", method = RequestMethod.GET)
	public String myPageAlarmForm() {
		return "/myPage/myPageAlarm";
	}
	
	@RequestMapping(value = "/myPageCheckPass", method = RequestMethod.POST)
	public String myPageCheckPass(String pw, HttpSession session) {
		String emailAddress = (String)session.getAttribute("emailAddress");
		boolean result = memberService.checkPass(emailAddress, pw);
		if(result) { //비밀번호 일치
			return "redirect:myPageModifyForm";
		}else { //비밀번호 불일치
			return "redirect:myPageCheckPassForm?checkPass=fail";
		}
	}
	
	@RequestMapping(value = "/modifyMember", method = RequestMethod.POST)
	public String modifyMember(Member member) {
		Member tmpMember = memberService.getMemberByEmail(member.getEmail());
		member.setNum(tmpMember.getNum());
		System.out.println(member);
		if(memberService.modifyMember(member)) {
			return "redirect:myPageMainForm";
		}else {
			return "redirect:myPageModifyForm";
		}
	}	
}
