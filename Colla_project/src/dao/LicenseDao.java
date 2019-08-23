package dao;

import java.util.List;

import model.License;

public interface LicenseDao {
	//public int insertLicense(License license);
	//public int updateLicense(License license);
	//public int deleteLicense(int num);
	public License selectLicense(int num);
	public License selectUseLicense(int mNum);
	public List<License> selectAllLicense(int mNum);
}
