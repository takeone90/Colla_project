package model;

public class BoardFile {
	private int bfNum;
	private int bNum;
	private String fileName;
	private String originName;
	private long size;
	
	public long getSize() {
		return size;
	}
	public void setSize(long size) {
		this.size = size;
	}
	public String getOriginName() {
		return originName;
	}
	public void setOriginName(String originName) {
		this.originName = originName;
	}
	public int getBfNum() {
		return bfNum;
	}
	public void setBfNum(int bfNum) {
		this.bfNum = bfNum;
	}
	public int getbNum() {
		return bNum;
	}
	public void setbNum(int bNum) {
		this.bNum = bNum;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
}
