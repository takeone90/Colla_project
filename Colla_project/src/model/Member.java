package model;

import java.sql.Date;

public class Member {
	private int num;
	private String email;
	private String name;
	private String pw;
	private Date regDate;
	private String phone;
	private String profileImg;
	private int crNum;
	private int pNum;
	private String mType;
	
	public int getpNum() {
		return pNum;
	}
	public void setpNum(int pNum) {
		this.pNum = pNum;
	}
	public int getCrNum() {
		return crNum;
	}
	public void setCrNum(int crNum) {
		this.crNum = crNum;
	}
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
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getProfileImg() {
		return profileImg;
	}
	public void setProfileImg(String profileImg) {
		this.profileImg = profileImg;
	}
	public String getmType() {
		return mType;
	}
	public void setmType(String mType) {
		this.mType = mType;
	}
	@Override
	public String toString() {
		return "Member [num=" + num + ", email=" + email + ", name=" + name + ", pw=" + pw + ", regDate=" + regDate
				+ ", phone=" + phone + ", profileImg=" + profileImg + ", crNum=" + crNum + ", pNum=" + pNum + ", mType="
				+ mType + "]";
	}
}
