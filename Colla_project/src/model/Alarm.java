package model;

import java.sql.Timestamp;

public class Alarm {
	private int aNum;
	private int mNumTo;
	private int mNumFrom;
	private String mNameFrom;
	private String aType;
	private int wNum;
	private int aDnum;
	private Timestamp aRegDate;
	public String getmNameFrom() {
		return mNameFrom;
	}
	public void setmNameFrom(String mNameFrom) {
		this.mNameFrom = mNameFrom;
	}
	public int getmNumFrom() {
		return mNumFrom;
	}
	public void setmNumFrom(int mNumFrom) {
		this.mNumFrom = mNumFrom;
	}
	public Timestamp getaRegDate() {
		return aRegDate;
	}
	public void setaRegDate(Timestamp aRegDate) {
		this.aRegDate = aRegDate;
	}
	public int getaNum() {
		return aNum;
	}
	public void setaNum(int aNum) {
		this.aNum = aNum;
	}
	public int getmNumTo() {
		return mNumTo;
	}
	public void setmNumTo(int mNumTo) {
		this.mNumTo = mNumTo;
	}
	public String getaType() {
		return aType;
	}
	public void setaType(String aType) {
		this.aType = aType;
	}
	public int getwNum() {
		return wNum;
	}
	public void setwNum(int wNum) {
		this.wNum = wNum;
	}
	public int getaDnum() {
		return aDnum;
	}
	public void setaDnum(int aDnum) {
		this.aDnum = aDnum;
	}
	@Override
	public String toString() {
		return "Alarm [aNum : " + aNum + ", 받는사람 : " + mNumTo + " 보내는사람 : "+mNameFrom+", 알람 타입 : " + aType + ", 워크스페이스번호 : " + wNum + ", 알람파라미터 : " + aDnum
				+ ", 알람생성일 : "+aRegDate+" ]";
	}
	
}
