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
//		System.out.println("username : "+username);
		Member originMember = memberService.selectMemberById(username);
		String mId = originMember.getmId(); 
		String mPassword = originMember.getmPassword();
//		int num = originMember.getmNum();
//		System.out.println("password : "+password);
//		System.out.println("num : "+num);
		List<String> authStrList = memberService.getMemberAuthorities(originMember.getmNum());
		
		System.out.println("authStrList : ");
		MemberDetails member = new MemberDetails();
		member.setUserid(mId);
		member.setPassword(mPassword);
		for(String auth:authStrList) {
			member.addAuth(auth);
		}	
		return member;
	}

}
