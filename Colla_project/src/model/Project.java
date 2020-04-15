package model;

import java.util.Date;

public class Project {
	private int pNum;
	private String pName;
	private double progress;
	private int wNum;
	private Date pRegDate;
	private String pDetail;
	private Date pStartDate;
	private Date pEndDate;
	private int crNum;
	private int mNum;
	private int calNum;
	
	public int getCalNum() {
		return calNum;
	}
	public void setCalNum(int calNum) {
		this.calNum = calNum;
	}
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
	public double getProgress() {
		return progress;
	}
	public void setProgress(double progress) {
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
	public String getpDetail() {
		return pDetail;
	}
	public void setpDetail(String pDetail) {
		this.pDetail = pDetail;
	}
	public Date getpStartDate() {
		return pStartDate;
	}
	public void setpStartDate(Date pStartDate) {
		this.pStartDate = pStartDate;
	}
	public Date getpEndDate() {
		return pEndDate;
	}
	public void setpEndDate(Date pEndDate) {
		this.pEndDate = pEndDate;
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
		return "Project [pNum=" + pNum + ", pName=" + pName + ", progress=" + progress + ", wNum=" + wNum
				+ ", pRegDate=" + pRegDate + ", pDetail=" + pDetail + ", pStartDate=" + pStartDate + ", pEndDate="
				+ pEndDate + ", crNum=" + crNum + ", mNum=" + mNum + ",calNum : "+calNum+"]";
	}
}
