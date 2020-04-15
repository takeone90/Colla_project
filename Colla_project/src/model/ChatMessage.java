package model;

import java.sql.Timestamp;

public class ChatMessage {
	private int cmNum;
	private int crNum;
	private int mNum;
	private String cmContent;
	private Timestamp cmWriteDate;
	private String mName;
	private String profileImg;
	private int isFavorite;
	private String cmType;
	
	public int getIsFavorite() {
		return isFavorite;
	}
	public void setIsFavorite(int isFavorite) {
		this.isFavorite = isFavorite;
	}
	public String getProfileImg() {
		return profileImg;
	}
	public void setProfileImg(String profileImg) {
		this.profileImg = profileImg;
	}
	
	public String getCmType() {
		return cmType;
	}
	public void setCmType(String cmType) {
		this.cmType = cmType;
	}
	public String getmName() {
		return mName;
	}
	public void setmName(String mName) {
		this.mName = mName;
	}
	public int getCmNum() {
		return cmNum;
	}
	public void setCmNum(int cmNum) {
		this.cmNum = cmNum;
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
	public String getCmContent() {
		return cmContent;
	}
	public void setCmContent(String cmContent) {
		this.cmContent = cmContent;
	}
	public Timestamp getCmWriteDate() {
		return cmWriteDate;
	}
	public void setCmWriteDate(Timestamp cmWriteDate) {
		this.cmWriteDate = cmWriteDate;
	}
	@Override
	public String toString() {
		return "채팅메세지 [메세지번호 : " + cmNum + ", 채팅방번호 : " + crNum + ", 작성자번호 : " + mNum + ", 작성자 : "+mName+", 메세지내용 : " + cmContent
				+ ", 작성시간 : " + cmWriteDate + ", 메세지 타입 :"+cmType+", 프로필이미지 : "+profileImg+", 즐겨찾기? : "+isFavorite+"]";
	}
}
