package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import model.Member;
import model.MemberDetails;

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
		member.setUserid(email);
		member.setPassword(pw);
		for(String auth:authList) {
			member.addAuth(auth);
		}
		return member;
	}

}
