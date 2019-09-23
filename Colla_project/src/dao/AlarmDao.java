package dao;

import java.util.List;

import model.Alarm;

public interface AlarmDao {
	public int insertAlarm(Alarm alarm);
	public int deleteAlarm(int aNum);
	public int deleteAllAlarmByMnum(int mNum);
	public Alarm selectAlarm(int aNum);
	public List<Alarm> selectAllAlarm(int mNum);
}
