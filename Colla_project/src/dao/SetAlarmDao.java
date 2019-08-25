package dao;

import model.SetAlarm;

public interface SetAlarmDao {
	public int insertSetAlarm(SetAlarm setAlarm);
	public int updateSetAlarm(int type, int result,int mNum);
	public int updateSetWsAlarm(int result, int mNum);
	public int updateSetNoticeAlarm(int result, int mNum);
	public int updateSetReplyAlarm(int result, int mNum);
	public int deleteSetAlarm(int num);
	public SetAlarm selectSetAlarm(int mNum);
}
