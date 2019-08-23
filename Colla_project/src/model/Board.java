package model;

import java.sql.Timestamp;

public class Board {
	private int bNum;
	private int mNum;
	private int wNum;
	private String bTitle;
	private String bContent;
	private Timestamp bRegDate;
	
	public int getwNum() {
		return wNum;
	}
	public void setwNum(int wNum) {
		this.wNum = wNum;
	}
	public int getbNum() {
		return bNum;
	}
	public void setbNum(int bNum) {
		this.bNum = bNum;
	}
	public int getmNum() {
		return mNum;
	}
	public void setmNum(int mNum) {
		this.mNum = mNum;
	}
	public String getbTitle() {
		return bTitle;
	}
	public void setbTitle(String bTitle) {
		this.bTitle = bTitle;
	}
	public String getbContent() {
		return bContent;
	}
	public void setbContent(String bContent) {
		this.bContent = bContent;
	}
	public Timestamp getbRegDate() {
		return bRegDate;
	}
	public void setbRegDate(Timestamp bRegDate) {
		this.bRegDate = bRegDate;
	}
	
	
}
