package dao;

import java.util.List;
import java.util.Map;

import model.License;

public interface LicenseDao {
	public int insertLicense(License license);
	public int deleteLicense(int mNum);
	public License selectLicense(int num);
	public License selectUseLicense(int mNum);
	public List<Map<String,Object>> selectAllLicense(int mNum);
}
