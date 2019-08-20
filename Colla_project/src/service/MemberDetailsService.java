package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import model.Member;
import model.MemberDetails;

@Component
public class MemberDetailsService implements UserDetailsService{

	@Autowired
	private MemberService memberService;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		Member originMember = memberService.selectMemberById(username);
		String userid = originMember.getmId(); 
		String password = originMember.getmPassword();
		int num = originMember.getmNum();
		List<String> authStrList = memberService.getMemberAuthorities(num);
		MemberDetails member = new MemberDetails();
		member.setUserid(userid);
		member.setPassword(password);
		for(String auth:authStrList) {
			member.addAuth(auth);
		}	
		return member;
	}

}
