package dao;

import java.util.Map;

import model.SetAlarm;

public interface SetAlarmDao {
	public int insertSetAlarm(SetAlarm setAlarm);
	public int updateSetAlarm(Map<String,Object> param);
	public int updateSetWsAlarm(int result, int mNum);
	public int updateSetNoticeAlarm(int result, int mNum);
	public int updateSetReplyAlarm(int result, int mNum);
	public int deleteSetAlarm(int num);
	public SetAlarm selectSetAlarm(int mNum);
}
