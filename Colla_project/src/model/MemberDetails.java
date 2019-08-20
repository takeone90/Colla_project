package model;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import commons.Role;

public class MemberDetails implements UserDetails {
	private String userid; 
	private String password;
	private List<Role> authorities;
	private boolean isAccountNonExpired;
	private boolean isAccountNonLocked;
	private boolean isCredentialNonExpired;
	private boolean isEnabled;
	public MemberDetails() {
		authorities = new ArrayList<Role>();
		isAccountNonExpired=true;
		isAccountNonLocked=true;
		isCredentialNonExpired=true;
		isEnabled=true;
	}
	public void addAuth(String auth) {
		Role role = new Role(auth);
		authorities.add(role);
	}
	
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return authorities;
	}
	public String getPassword() {
		return password;
	}
	public String getUsername() {
		return userid;
	}
	public boolean isAccountNonExpired() {
		return isAccountNonExpired;
	}
	public boolean isAccountNonLocked() {
		return isAccountNonLocked;
	}
	public boolean isCredentialsNonExpired() {
		return isCredentialNonExpired;
	}
	public boolean isEnabled() {
		return isEnabled;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public boolean isCredentialNonExpired() {
		return isCredentialNonExpired;
	}
	public void setCredentialNonExpired(boolean isCredentialNonExpired) {
		this.isCredentialNonExpired = isCredentialNonExpired;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public void setAuthorities(List<Role> authorities) {
		this.authorities = authorities;
	}
	public void setAccountNonExpired(boolean isAccountNonExpired) {
		this.isAccountNonExpired = isAccountNonExpired;
	}
	public void setAccountNonLocked(boolean isAccountNonLocked) {
		this.isAccountNonLocked = isAccountNonLocked;
	}
	public void setEnabled(boolean isEnabled) {
		this.isEnabled = isEnabled;
	}
}
