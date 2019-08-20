package model;

public class Member {
	int mNum;
	String mId;
	String mPassword;
	String mName;
	String mEmail;
	public int getmNum() {
		return mNum;
	}
	public void setmNum(int mNum) {
		this.mNum = mNum;
	}
	public String getmId() {
		return mId;
	}
	public void setmId(String mId) {
		this.mId = mId;
	}
	public String getmPassword() {
		return mPassword;
	}
	public void setmPassword(String mPassword) {
		this.mPassword = mPassword;
	}
	public String getmName() {
		return mName;
	}
	public void setmName(String mName) {
		this.mName = mName;
	}
	public String getmEmail() {
		return mEmail;
	}
	public void setmEmail(String mEmail) {
		this.mEmail = mEmail;
	}
	@Override
	public String toString() {
		return "Member [mNum=" + mNum + ", mId=" + mId + ", mPassword=" + mPassword + ", mName=" + mName + ", mEmail="
				+ mEmail + ", getmNum()=" + getmNum() + ", getmId()=" + getmId() + ", getmPassword()=" + getmPassword()
				+ ", getmName()=" + getmName() + ", getmEmail()=" + getmEmail() + ", getClass()=" + getClass()
				+ ", hashCode()=" + hashCode() + ", toString()=" + super.toString() + "]";
	}
}
