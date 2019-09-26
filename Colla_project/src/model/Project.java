package model;

import java.util.Date;

public class Project {
	private int pNum;
	private String pName;
	private int progress;
	private int wNum;
	private Date pRegDate;
	public int getpNum() {
		return pNum;
	}
	public void setpNum(int pNum) {
		this.pNum = pNum;
	}
	public String getpName() {
		return pName;
	}
	public void setpName(String pName) {
		this.pName = pName;
	}
	public int getProgress() {
		return progress;
	}
	public void setProgress(int progress) {
		this.progress = progress;
	}
	public int getwNum() {
		return wNum;
	}
	public void setwNum(int wNum) {
		this.wNum = wNum;
	}
	public Date getpRegDate() {
		return pRegDate;
	}
	public void setpRegDate(Date pRegDate) {
		this.pRegDate = pRegDate;
	}
	@Override
	public String toString() {
		return "프로젝트 정보 [pNum : " + pNum + ", 프로젝트이름 : " + pName + ", 진행률 : " + progress + ", 워크스페이스 번호 : " + wNum
				+ ", 프로젝트 등록일 : " + pRegDate + "]";
	}
	
}
