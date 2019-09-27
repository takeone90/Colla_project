package model;

import java.util.Date;

public class Todo {
	private int tdNum;
	private String tdTitle;
	private String tdContent;
	private int pNum;
	private int mNumTo;
	private int mNumFrom;
	private Date tdStartDate;
	private Date tdEndDate;
	private int isComplete;
	private Date completeDate;
	private int priority;
	public int getTdNum() {
		return tdNum;
	}
	public void setTdNum(int tdNum) {
		this.tdNum = tdNum;
	}
	public String getTdTitle() {
		return tdTitle;
	}
	public void setTdTitle(String tdTitle) {
		this.tdTitle = tdTitle;
	}
	public String getTdContent() {
		return tdContent;
	}
	public void setTdContent(String tdContent) {
		this.tdContent = tdContent;
	}
	public int getpNum() {
		return pNum;
	}
	public void setpNum(int pNum) {
		this.pNum = pNum;
	}
	public int getmNumTo() {
		return mNumTo;
	}
	public void setmNumTo(int mNumTo) {
		this.mNumTo = mNumTo;
	}
	public int getmNumFrom() {
		return mNumFrom;
	}
	public void setmNumFrom(int mNumFrom) {
		this.mNumFrom = mNumFrom;
	}
	public Date getTdStartDate() {
		return tdStartDate;
	}
	public void setTdStartDate(Date tdStartDate) {
		this.tdStartDate = tdStartDate;
	}
	public Date getTdEndDate() {
		return tdEndDate;
	}
	public void setTdEndDate(Date tdEndDate) {
		this.tdEndDate = tdEndDate;
	}
	public int getIsComplete() {
		return isComplete;
	}
	public void setIsComplete(int isComplete) {
		this.isComplete = isComplete;
	}
	public Date getCompleteDate() {
		return completeDate;
	}
	public void setCompleteDate(Date completeDate) {
		this.completeDate = completeDate;
	}
	public int getPriority() {
		return priority;
	}
	public void setPriority(int priority) {
		this.priority = priority;
	}
	@Override
	public String toString() {
		return "Todo [tdNum=" + tdNum + ", tdTitle=" + tdTitle + ", tdContent=" + tdContent + ", pNum=" + pNum
				+ ", mNumTo=" + mNumTo + ", mNumFrom=" + mNumFrom + ", tdStartDate=" + tdStartDate + ", tdEndDate="
				+ tdEndDate + ", isComplete=" + isComplete + ", completeDate=" + completeDate + ", priority=" + priority
				+ "]";
	}
}
