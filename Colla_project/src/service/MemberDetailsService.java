package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import model.Member;
import model.MemberDetails;
@Service
public class MemberDetailsService implements UserDetailsService{
	@Autowired
	private MemberService memberService;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		Member originMember = memberService.getMemberByEmail(username);
		String email = originMember.getEmail();
		String pw = originMember.getPw();
		int num = originMember.getNum();
		List<String> authList = memberService.getMemberAuthorities(num);
		MemberDetails member = new MemberDetails();
		member.setEmail(email);
		member.setPw(pw);
		System.out.println("[로그인 정보 || 아이디 : "+member.getEmail()+", 비밀번호 : "+member.getPw()+"]");
		for(String auth:authList) {
			member.addAuth(auth);
		}
		return member;
	}
}
