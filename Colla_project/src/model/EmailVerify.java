package model;

import java.util.Date;

public class EmailVerify {
	private int num;
	private String email;
	private String verifyCode;
	private Date regDate;
	
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getVerifyCode() {
		return verifyCode;
	}
	public void setVerifyCode(String verifyCode) {
		this.verifyCode = verifyCode;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	@Override
	public String toString() {
		return "EmailVerify [num=" + num + ", email=" + email + ", verifyCode=" + verifyCode + ", regDate=" + regDate
				+ "]";
	}
}
