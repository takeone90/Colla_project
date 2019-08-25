package service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import dao.LicenseDao;
import dao.SetAlarmDao;
import model.License;

@Service
public class LicenseService {

	@Autowired
	LicenseDao licenseDao;
	
	public License getUseLicense(int mNum) {
		return licenseDao.selectUseLicense(mNum);
	}
	
	public List<License> getLicenseList(int mNum){
		return licenseDao.selectAllLicense(mNum);
	}
	
}
