package model;

import java.util.Date;

public class ChatRoom {
	//0825 10:24 수빈
	private int crNum;
	private int mNum;
	private int wNum;
	private String crName;
	private Date crRegDate;
	private int crIsDefault;
	public int getCrIsDefault() {
		return crIsDefault;
	}
	public void setCrIsDefault(int crIsDefault) {
		this.crIsDefault = crIsDefault;
	}
	public int getCrNum() {
		return crNum;
	}
	public void setCrNum(int crNum) {
		this.crNum = crNum;
	}
	public int getmNum() {
		return mNum;
	}
	public void setmNum(int mNum) {
		this.mNum = mNum;
	}
	public int getwNum() {
		return wNum;
	}
	public void setwNum(int wNum) {
		this.wNum = wNum;
	}
	public String getCrName() {
		return crName;
	}
	public void setCrName(String crName) {
		this.crName = crName;
	}
	public Date getCrRegDate() {
		return crRegDate;
	}
	public void setCrRegDate(Date crRegDate) {
		this.crRegDate = crRegDate;
	}
	public String toString() {
		return "채팅방정보 [채팅방번호 : " + crNum + ", 생성자 : " + mNum + ", 워크스페이스번호 : " + wNum + ", 채팅방이름 : " + crName + ", 채팅방생성일 : "
				+ crRegDate + ", 1이면 기본채팅방 : "+crIsDefault+"]";
	}
	
}
