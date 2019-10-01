package model;

public class WsMember {
	private int wmNum;
	private int wNum;
	private int mNum;
	private String mName;
	public int getWmNum() {
		return wmNum;
	}
	public void setWmNum(int wmNum) {
		this.wmNum = wmNum;
	}
	public String getmName() {
		return mName;
	}
	public void setmName(String mName) {
		this.mName = mName;
	}
	public int getWsNum() {
		return wmNum;
	}
	public void setWsNum(int wmNum) {
		this.wmNum = wmNum;
	}
	public int getwNum() { 
		return wNum;
	}
	public void setwNum(int wNum) {
		this.wNum = wNum;
	}
	public int getmNum() {
		return mNum;
	}
	public void setmNum(int mNum) {
		this.mNum = mNum;
	}
	@Override
	public String toString() {
		return "워크스페이스참여자정보 [wsMember정보테이블 번호 : " + wmNum + ", workspace번호 : " + wNum + ", 참여멤버번호 : " + mNum + ", 참여멤버이름 : "+mName+"]";
	}
	
}
