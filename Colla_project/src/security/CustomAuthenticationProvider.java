package security;

import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;

import service.MemberService;

public class CustomAuthenticationProvider implements AuthenticationProvider {
	public CustomAuthenticationProvider() {
		System.out.println("CustomAuthenticationProvider 객체 생성합니다.");
	}
	private MemberService memberService;
	
	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public boolean supports(Class<?> authentication) {
		// TODO Auto-generated method stub
		return false;
	}
	
}
