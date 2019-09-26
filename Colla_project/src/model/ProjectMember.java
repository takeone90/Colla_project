package model;

import java.util.Date;

public class ProjectMember {
	private int pNum;
	private int mNum;
	private Date pmRegDate;
	public int getpNum() {
		return pNum;
	}
	public void setpNum(int pNum) {
		this.pNum = pNum;
	}
	public int getmNum() {
		return mNum;
	}
	public void setmNum(int mNum) {
		this.mNum = mNum;
	}
	public Date getPmRegDate() {
		return pmRegDate;
	}
	public void setPmRegDate(Date pmRegDate) {
		this.pmRegDate = pmRegDate;
	}
	@Override
	public String toString() {
		return "프로젝트참여멤버 [프로젝트 번호 : " + pNum + ", 멤버번호 : " + mNum + ", 가입일 : " + pmRegDate + "]";
	}
	
}
