package service;

import java.util.HashMap;
import java.util.Map;

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
	
	public boolean modifySetAlarm(String type, int result,int mNum) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("type", type);
		param.put("result", result);
		param.put("mNum", mNum);
		System.out.println("type : " + type);
		System.out.println("result : " + result);
		System.out.println("mNum : " + mNum);
		if(setAlarmDao.updateSetAlarm(param)>0) {
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
