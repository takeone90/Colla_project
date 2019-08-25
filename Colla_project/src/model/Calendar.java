package model;

import java.util.Date;

public class Calendar {
	private int cNum;
	private int mNum;
	private int wNum;
	private String type;
	private Date startDate;
	private Date endDate;
	private String title;
	private String content;
	private Date regDate;
	private int annually;
	private int monthly;
	private int yearCalendar;
	public int getcNum() {
		return cNum;
	}
	public void setcNum(int cNum) {
		this.cNum = cNum;
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
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	public int getAnnually() {
		return annually;
	}
	public void setAnnually(int annually) {
		this.annually = annually;
	}
	public int getMonthly() {
		return monthly;
	}
	public void setMonthly(int monthly) {
		this.monthly = monthly;
	}
	public int getYearCalendar() {
		return yearCalendar;
	}
	public void setYearCalendar(int yearCalendar) {
		this.yearCalendar = yearCalendar;
	}
	@Override
	public String toString() {
		return "Calendar [cNum=" + cNum + ", mNum=" + mNum + ", wNum=" + wNum + ", type=" + type + ", startDate="
				+ startDate + ", endDate=" + endDate + ", title=" + title + ", content=" + content + ", regDate="
				+ regDate + ", annually=" + annually + ", monthly=" + monthly + ", yearCalendar=" + yearCalendar + "]";
	}
}
