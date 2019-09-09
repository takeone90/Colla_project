package model;

import java.util.Date;

public class Calendar {
	private int cNum;
	private int mNum;
	private String mName;
	private int wNum;
	private String type;
	private String startDate;
	private String endDate;
	private String title;
	private String content;
	private Date regDate;
	private String annually; //table에서는 int
	private String monthly; //table에서는 int
	private String yearCalendar; //table에서는 int
	private String color;
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
	public String getmName() {
		return mName;
	}
	public void setmName(String mName) {
		this.mName = mName;
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
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
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
	public String getAnnually() {
		return annually;
	}
	public void setAnnually(String annually) {
		this.annually = annually;
	}
	public String getMonthly() {
		return monthly;
	}
	public void setMonthly(String monthly) {
		this.monthly = monthly;
	}
	public String getYearCalendar() {
		return yearCalendar;
	}
	public void setYearCalendar(String yearCalendar) {
		this.yearCalendar = yearCalendar;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	@Override
	public String toString() {
		return "Calendar [cNum=" + cNum + ", mNum=" + mNum + ", wNum=" + wNum + ", type=" + type + ", startDate="
				+ startDate + ", endDate=" + endDate + ", title=" + title + ", content=" + content + ", regDate="
				+ regDate + ", annually=" + annually + ", monthly=" + monthly + ", yearCalendar=" + yearCalendar
				+ ", color=" + color + "]";
	}
}
