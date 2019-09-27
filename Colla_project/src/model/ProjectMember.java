package model;

import java.util.Date;

public class ProjectMember {
	private int pNum;
	private int mNum;
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
	@Override
	public String toString() {
		return "ProjectMember [pNum=" + pNum + ", mNum=" + mNum + "]";
	}
	
	
}
