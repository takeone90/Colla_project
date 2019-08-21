package commons;

import org.springframework.security.core.GrantedAuthority;

public class Role implements GrantedAuthority{

	private String authority;
	public Role(String authority) {
		this.authority = authority;
	}
	@Override
	public String getAuthority() {
		// TODO Auto-generated method stub
		return authority;
	}
	@Override
	public String toString() {
		return "[" + authority + "]";
	}
	
}
