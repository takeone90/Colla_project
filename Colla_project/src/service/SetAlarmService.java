package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.SetAlarmDao;
import model.SetAlarm;

@Service
public class SetAlarmService {

	@Autowired
	SetAlarmDao setAlarmDao;
	
	//알람 설정
	public boolean addSetAlarm(SetAlarm setAlarm) {
		if(setAlarmDao.insertSetAlarm(setAlarm)>0) {
			return true;
		}
		return false;
	}
	
	public boolean modifySetWsAlarm(int result, int mNum) {
		if(setAlarmDao.updateSetWsAlarm(result,mNum)>0) {
			return true;
		}
		return false;
	}
	
	public boolean modifySetNoticeAlarm(int result, int mNum) {
		if(setAlarmDao.updateSetNoticeAlarm(result,mNum)>0) {
			return true;
		}
		return false;
	}
	
	public boolean modifySetReplyAlarm(int result, int mNum) {
		if(setAlarmDao.updateSetReplyAlarm(result,mNum)>0) {
			return true;
		}
		return false;
	}
	
	public SetAlarm getSetAlarm(int mNum){
		return setAlarmDao.selectSetAlarm(mNum);
	}	
}
