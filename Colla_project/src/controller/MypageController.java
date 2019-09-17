package controller;

import java.io.File;
import java.io.FileOutputStream;
import java.security.Principal;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

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
	// updateProfileImg(MultipartFile[] profileImg, HttpSession session) : 프로필 이미지 추가

	@Autowired
	private MemberService memberService;
	@Autowired
	private LicenseService licenseService;
	@Autowired
	private SetAlarmService setAlarmService;
	
	@RequestMapping(value = "/myPageMainForm", method = RequestMethod.GET)
	public String myPageMainForm(Model model, HttpSession session) {
		Member member = memberService.getMemberByEmail((String)session.getAttribute("userEmail"));
		model.addAttribute("member", member);
		return "/myPage/myPageMain";
	}
	
	@RequestMapping(value = "/myPageAccountForm", method = RequestMethod.GET)
	public String myPageAccountForm(Model model, HttpSession session) {
		Member member = memberService.getMemberByEmail((String)session.getAttribute("userEmail"));
		model.addAttribute("member", member);
		return "/myPage/myPageAccount";
	}

	/*
	@RequestMapping(value = "/myPageCheckPassForm", method = RequestMethod.GET)
	public String myPageCheckPassForm() {
		return "/myPage/myPageCheckPass";
	}
	*/
	@RequestMapping(value = "/profileImgModifyForm", method = RequestMethod.GET)
	public String profileImgModifyForm() {
		return "/myPage/profileImgModify";
	}
	@RequestMapping(value = "/nameModifyForm", method = RequestMethod.GET)
	public String nameModifyForm() {
		return "/myPage/nameModify";
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
		Member member = memberService.getMemberByEmail((String)session.getAttribute("userEmail"));
		model.addAttribute("member", member); 
		if (checkPass != null && checkPass.equals("fail")) {
			return "/myPage/myPageModifyForm?checkPass=fail";
		}
		return "/myPage/myPageModifyForm";
	}

	@RequestMapping(value = "/myPageLicenseForm", method = RequestMethod.GET)
	public String myPageLicenseForm(HttpSession session, Model model) {
		Member member = memberService.getMemberByEmail((String)session.getAttribute("userEmail"));
		model.addAttribute("member", member);
		model.addAttribute("useLicense", licenseService.getUseLicense(member.getNum()));
		model.addAttribute("licenseList", licenseService.getLicenseList(member.getNum()));
		return "/myPage/myPageLicense";
	}

	@RequestMapping(value = "/myPageAlarmForm", method = RequestMethod.GET)
	public String myPageAlarmForm(HttpSession session, Model model) {
		Member member = memberService.getMemberByEmail((String)session.getAttribute("userEmail"));
		model.addAttribute("member", member);
		SetAlarm setAlarm = setAlarmService.getSetAlarm(member.getNum());
		model.addAttribute("wsAlarm", setAlarm.getWorkspace());
		model.addAttribute("boardAlarm", setAlarm.getNotice());
		model.addAttribute("replyAlarm", setAlarm.getReply());
		return "/myPage/myPageAlarm";
	}
	

	@RequestMapping(value = "/modifysetAlarm", method = RequestMethod.GET)
	@ResponseBody
	public void modifysetAlarm(HttpSession session, int type, int result) {
		// type > 0:워크스페이스 설정, 1:공지 설정, 2:댓글설정
		// result > 0:설정ON, 1:설정OFF
		Member member = memberService.getMemberByEmail((String)session.getAttribute("userEmail"));
		String typeStr = null;
		if (type == 0) {
			typeStr = "SA_WORKSPACE"; 
		} else if (type == 1) {
			typeStr = "SA_NOTICE";
		} else if (type == 2) {
			typeStr = "SA_REPLY";
		}
		setAlarmService.modifySetAlarm(typeStr, result, member.getNum());
	}

	@RequestMapping(value = "/myPageCheckPass", method = RequestMethod.POST)
	public String myPageCheckPass(String pw, HttpSession session) {
		String emailAddress = (String)session.getAttribute("userEmail");
		boolean result = memberService.checkPass(emailAddress, pw);
		if (result) { // 비밀번호 일치
			return "redirect:myPageModifyForm";
		} else { // 비밀번호 불일치
			return "redirect:myPageCheckPassForm?checkPass=fail";
		}
	}

	@RequestMapping(value = "/modifyMember", method = RequestMethod.POST)
	public String modifyMember(Member member,String type,HttpSession session) {
		member.setNum(((Member)session.getAttribute("user")).getNum());
		if (memberService.modifyMember(member)) {
			session.setAttribute("user", member);
			return "redirect:myPageMainForm";
		} else {
			return "redirect:myPageModifyForm";//에러페이지로 변경해야함
		}
	}
	
	@RequestMapping(value = "/modifyProfileImg", method = RequestMethod.POST)
	public String modifyProfileImg(MultipartFile[] profileImg, String profileImgType, HttpSession session) {
		boolean result = false;
		System.out.println("profileImgType:" + profileImgType);
		System.out.println("profileImg:" + profileImg);
		Member member = memberService.getMemberByEmail((String)session.getAttribute("userEmail"));
		result = memberService.updateProfileImg(profileImg,profileImgType,member);
		if(result) {
			return "redirect:myPageMainForm";
		}else {
			return "redirect:myPageMainForm"; //에러 페이지로 변경
		}
	}
	
	@ResponseBody
	@RequestMapping(value = "/showProfileImg")
	public byte[] showProfileImg(HttpSession session, HttpServletRequest request, @RequestParam(value = "num", defaultValue = "0")int mNum) {
		Member member = null;
		if(mNum == 0) {
			member = memberService.getMemberByEmail((String)session.getAttribute("userEmail"));
			return memberService.getProfileImg(member,request); 
		} else {
			member = memberService.getMember(mNum);
			return memberService.getProfileImg(member, request);
		}
	}
}
