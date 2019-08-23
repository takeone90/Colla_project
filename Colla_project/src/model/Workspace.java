package model;

import java.sql.Date;

public class Workspace {
	private int num;
	private int mNum;
	private String name;
	private Date regDate;
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public int getmNum() {
		return mNum;
	}
	public void setmNum(int mNum) {
		this.mNum = mNum;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	@Override
	public String toString() {
		return "Workspace [워크스페이스번호 : " + num + ", 멤버번호 : " + mNum + ", 워크스페이스 이름 : " + name + ", regDate=" + regDate + "]";
	}
	
}
