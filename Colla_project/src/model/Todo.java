package model;

import java.sql.Timestamp;

public class Todo {
	private int tdNum;
	private String tdContent;
	private int pNum;
	private int mNum;
	private int isComplete;
	private int priority;
	private Timestamp deadLine;
	private Timestamp completeDate;
	public int getTdNum() {
		return tdNum;
	}
	public void setTdNum(int tdNum) {
		this.tdNum = tdNum;
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
	public int getmNum() {
		return mNum;
	}
	public void setmNum(int mNum) {
		this.mNum = mNum;
	}
	public int getIsComplete() {
		return isComplete;
	}
	public void setIsComplete(int isComplete) {
		this.isComplete = isComplete;
	}
	public int getPriority() {
		return priority;
	}
	public void setPriority(int priority) {
		this.priority = priority;
	}
	public Timestamp getDeadLine() {
		return deadLine;
	}
	public void setDeadLine(Timestamp deadLine) {
		this.deadLine = deadLine;
	}
	public Timestamp getCompleteDate() {
		return completeDate;
	}
	public void setCompleteDate(Timestamp completeDate) {
		this.completeDate = completeDate;
	}
	@Override
	public String toString() {
		return "할일 [tdNum : " + tdNum + ", 할일 내용 : " + tdContent + ", 프로젝트번호  :" + pNum + ", 멤버번호  : " + mNum
				+ ", 완료여부 : " + isComplete + ", 우선순위 : " + priority + ", 마감일 : " + deadLine + ", 완료일 : "
				+ completeDate + "]";
	}
	
}
