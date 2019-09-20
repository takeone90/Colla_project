package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.AlarmDao;
import model.Alarm;

@Service
public class AlarmService {
	@Autowired
	private AlarmDao aDao;
	public int addAlarm(int wNum,int mNumTo,int mNumFrom,String aType,int aDnum) {
		Alarm alarm = new Alarm();
		alarm.setaDnum(aDnum);
		alarm.setaType(aType);
		alarm.setmNumTo(mNumTo);
		alarm.setmNumFrom(mNumFrom);
		alarm.setwNum(wNum);
		aDao.insertAlarm(alarm);
		int aNum = alarm.getaNum();
		return aNum;
	}
	public boolean removeAlarm(int aNum) {
		boolean result = false;
		if(aDao.deleteAlarm(aNum)>0) {
			result = true;
		}
		return result;
	}
	public Alarm getAlarm(int aNum) {
		return aDao.selectAlarm(aNum);
	}
	public List<Alarm> getAllAlarm(int mNum){
		return aDao.selectAllAlarm(mNum);
	}
}
