package service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.LicenseDao;
import model.License;

@Service
public class LicenseService {

	@Autowired
	LicenseDao licenseDao;
	
	public boolean insertLicense(License license) {
		if(licenseDao.insertLicense(license)>0) {
			return true;
		}
		return false;
	}

	public License getUseLicense(int mNum) {
		return licenseDao.selectUseLicense(mNum);
	}
	
	public List<Map<String,Object>> getLicenseList(int mNum){
		return licenseDao.selectAllLicense(mNum);
	}
}
