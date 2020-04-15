package model;

public class WorkspaceInvite {
	private int wiNum;
	private String wiTargetUser;
	private int wNum;
	private int wasJoinedUs;
	
	public int getWiNum() {
		return wiNum;
	}
	public void setWiNum(int wiNum) {
		this.wiNum = wiNum;
	}
	public String getWiTargetUser() {
		return wiTargetUser;
	}
	public void setWiTargetUser(String wiTargetUser) {
		this.wiTargetUser = wiTargetUser;
	}
	public int getwNum() {
		return wNum;
	}
	public void setwNum(int wNum) {
		this.wNum = wNum;
	}
	public int getWasJoinedUs() {
		return wasJoinedUs;
	}
	public void setWasJoinedUs(int wasJoinedUs) {
		this.wasJoinedUs = wasJoinedUs;
	}
	@Override
	public String toString() {
		return "워크스페이스 초대정보 [wiNum : " + wiNum + ", 초대유저 : " + wiTargetUser + ", 초대워크스페이스번호 : " + wNum + ", 가입여부 : " + wasJoinedUs + "]";
	}
}
