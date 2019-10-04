package controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.Principal;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import model.Member;
import model.SetAlarm;
import service.SetAlarmService;
import service.LicenseService;
import service.MemberService;

@Controller
public class MypageController {
	// myPageMainForm(Model model, Principal principal, HttpSession session):String
	// > 마이페이지 메인화면 (로그인한 멤버 정보 출력)
	// myPageCheckPassForm(String pw, HttpSession session):String > 비밀번호 입력 화면
	// myPageModifyForm(Model model, HttpSession session, String checkPass):String >
	// 회원정보관리 화면
	// myPageLicenseForm(HttpSession session, Model model) : 라이선스 화면
	// myPageAlarmForm(HttpSession session, Model model) : 알림 설정 화면
	// modifysetAlarm(HttpSession session, int type,int result) : 알림 설정값 수정시 업데이트 로직
	// myPageCheckPass(String pw, HttpSession session):String > 비밀번호 확인 로직
	// modifyMember(Member member):String > 회원 정보 업데이트 로직
	// updateProfileImg(MultipartFile[] profileImg, HttpSession session) : 프로필 이미지

	@Autowired
	private MemberService memberService;
	@Autowired
	private LicenseService licenseService;
	@Autowired
	private SetAlarmService setAlarmService;

	@RequestMapping(value = "/myPageMainForm", method = RequestMethod.GET)
	public String myPageMainForm(Model model, HttpSession session) {
		Member member = memberService.getMemberByEmail((String) session.getAttribute("userEmail"));
		model.addAttribute("member", member);
		return "/myPage/myPageMain";
	}

	@RequestMapping(value = "/myPageAccountForm", method = RequestMethod.GET)
	public String myPageAccountForm(Model model, HttpSession session) {
		Member member = memberService.getMemberByEmail((String) session.getAttribute("userEmail"));
		model.addAttribute("member", member);
		return "/myPage/myPageAccount";
	}

	@RequestMapping(value = "/profileImgModifyForm", method = RequestMethod.GET)
	public String profileImgModifyForm() {
		return "/myPage/profileImgModify";
	}

	@RequestMapping(value = "/nameModifyForm", method = RequestMethod.GET)
	public String nameModifyForm() {
		return "/myPage/nameModify";
	}

	@RequestMapping(value = "/checkPassForm", method = RequestMethod.GET)
	public String checkPassForm() {
		return "/myPage/myPageCheckPass";
	}

	@RequestMapping(value = "/pwModifyForm", method = RequestMethod.GET)
	public String pwModifyForm() {
		return "/myPage/pwModify";
	}

	@RequestMapping(value = "/phoneModifyForm", method = RequestMethod.GET)
	public String phoneModifyForm() {
		return "/myPage/phoneModify";
	}

	@RequestMapping(value = "/myPageModifyForm", method = RequestMethod.POST)
	public String myPageModifyForm(Model model, HttpSession session, String checkPass) {
		Member member = memberService.getMemberByEmail((String) session.getAttribute("userEmail"));
		model.addAttribute("member", member);
		if (checkPass != null && checkPass.equals("fail")) {
			return "/myPage/myPageModifyForm?checkPass=fail";
		}
		return "/myPage/myPageModifyForm";
	}

	@RequestMapping(value = "/myPageLicenseForm", method = RequestMethod.GET)
	public String myPageLicenseForm(HttpSession session, Model model) {
		Member member = memberService.getMemberByEmail((String) session.getAttribute("userEmail"));
		model.addAttribute("member", member);
		model.addAttribute("useLicense", licenseService.getUseLicense(member.getNum()));

		model.addAttribute("licenseList", licenseService.getLicenseList(member.getNum()));
		return "/myPage/myPageLicense";
	}

	@RequestMapping(value = "/myPageAlarmForm", method = RequestMethod.GET)
	public String myPageAlarmForm(HttpSession session, Model model) {
		Member member = memberService.getMemberByEmail((String) session.getAttribute("userEmail"));
		model.addAttribute("member", member);
		model.addAttribute("setAlarm", setAlarmService.getSetAlarm(member.getNum()));
		return "/myPage/myPageAlarm";
	}

	@RequestMapping(value = "/modifysetAlarm", method = RequestMethod.GET)
	@ResponseBody
	public void modifysetAlarm(HttpSession session, int type, int result) {
		// type > 0:워크스페이스 설정, 1:공지 설정, 2:댓글설정
		// result > 0:설정ON, 1:설정OFF
		Member member = memberService.getMemberByEmail((String) session.getAttribute("userEmail"));
		String typeStr = null;
		if (type == 0) {
			typeStr = "SA_WORKSPACE";
		} else if (type == 1) {
			typeStr = "SA_NOTICE";
		} else if (type == 2) {
			typeStr = "SA_REPLY";
		} else if (type == 3) {
			typeStr = "SA_PROJECT_INVITE";
		} else if (type == 4) {
			typeStr = "SA_TODO";
		}
		setAlarmService.modifySetAlarm(typeStr, result, member.getNum());
	}

	@RequestMapping(value = "/modifyName", method = RequestMethod.POST)
	public String modifyName(String name, HttpSession session) {
		String email = (String) session.getAttribute("userEmail");
		if (memberService.modifyMemberName(name, email)) {
			session.setAttribute("user", memberService.getMemberByEmail(email));
			return "redirect:myPageAccountForm";
		}
		return "redirect:nameModifyForm";
	}

	@ResponseBody
	@RequestMapping(value = "/myPageCheckPass", method = RequestMethod.POST)
	public boolean myPageCheckPass(String pw, HttpSession session) {
		String emailAddress = (String) session.getAttribute("userEmail");
		boolean result = memberService.checkPass(emailAddress, pw);
		if (result) { // 비밀번호 일치
			// return "redirect:pwModifyForm";
			return true;
		} else { // 비밀번호 불일치
			// return "redirect:checkPassForm?checkPass=fail";
			return false;
		}
	}

	@RequestMapping(value = "/modifyPw", method = RequestMethod.POST)
	public String modifyPw(String pw, HttpSession session) {
		String email = (String) session.getAttribute("userEmail");
		if (memberService.modifyMemberPw(pw, email)) {
			session.setAttribute("user", memberService.getMemberByEmail(email));
			return "redirect:myPageAccountForm";
		}
		return "redirect:pwModifyForm";
	}

	@RequestMapping(value = "/modifyPhone", method = RequestMethod.POST)
	public String modifyPhone(String phone, HttpSession session) {
		String email = (String) session.getAttribute("userEmail");
		if (memberService.modifyMemberPhone(phone, email)) {
			session.setAttribute("user", memberService.getMemberByEmail(email));
			return "redirect:myPageAccountForm";
		}
		return "redirect:phoneModifyForm";
	}

	@ResponseBody
	@RequestMapping(value = "/modifyProfileImg", method = RequestMethod.POST)
	public boolean modifyProfileImg(MultipartFile[] croppedImage, String profileImgType, HttpSession session) {
		boolean result = false;
		Member member = memberService.getMemberByEmail((String) session.getAttribute("userEmail"));
		result = memberService.updateProfileImg(croppedImage, profileImgType, member);
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "/showProfileImg")
	public byte[] showProfileImg(HttpSession session, HttpServletRequest request,
			@RequestParam(value = "num", defaultValue = "0") int mNum) {
		Member member = null;
		if (mNum == 0) {
			member = memberService.getMemberByEmail((String) session.getAttribute("userEmail"));
			return memberService.getProfileImg(member, request);
		} else {
			member = memberService.getMember(mNum);
			return memberService.getProfileImg(member, request);
		}
	}
}
