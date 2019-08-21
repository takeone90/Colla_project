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
	private MemberService service;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

		Member originMember = service.selectMemberById(username);
		MemberDetails member = new MemberDetails();
		member.setUserid(originMember.getmId());
		member.setPassword(originMember.getmPassword());
		System.out.println("아이디 : "+member.getUserid()+", 비밀번호 : "+member.getPassword());
//		int num = originMember.getmNum();
//		System.out.println("password : "+password);
//		System.out.println("num : "+num);
		List<String> authStrList = service.getMemberAuthorities(originMember.getmNum());
		for(String auth:authStrList) {
			member.addAuth(auth);
		}
		System.out.println("권한 : "+member.getAuthorities());
		return member;
	}

}
