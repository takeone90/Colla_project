package model;

import java.sql.Date;

public class License {
	int num;
	int mNum;
	String type;
	Date startDate;
	Date endDate;
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public int getmNum() {
		return mNum;
	}
	public void setmNum(int mNum) {
		this.mNum = mNum;
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
	@Override
	public String toString() {
		return "License [num=" + num + ", mNum=" + mNum + ", type=" + type + ", startDate=" + startDate + ", endDate="
				+ endDate + "]";
	}
}
