package model;

public class ChatRoomMember {
	private int crmNum;
	private int crNum;
	private int mNum;
	private int wNum;
	public int getwNum() {
		return wNum;
	}
	public void setwNum(int wNum) {
		this.wNum = wNum;
	}
	public int getCrmNum() {
		return crmNum;
	}
	public void setCrmNum(int crmNum) {
		this.crmNum = crmNum;
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
	@Override
	public String toString() {
		return "채팅방회원정보 [채팅방+회원번호 : " + crmNum + ", 채팅방번호 : " + crNum + ", 회원번호 : " + mNum + ", 워크스페이스 번호 : "+wNum+"]";
	}
	
}
