package dao;

import java.util.List;
import java.util.Map;

import model.Calendar;

public interface CalendarDao {
	public int insertCalendar(Calendar calendar);
	public int updateCalendar(Calendar calendar);
	public int deleteCalendar(int cNum);
	public Calendar selectCalendar(int cNum);
	public List<Calendar> selectAllCalendar();
	public List<Calendar> selectAllCalendarByMonth();
	public List<Calendar> selectAllCalendarSearched(Map<String, Object> param);
//	public int insertCalendarAnnually(Calendar calendar);
//	public int insertCalendarMonthly(Calendar calendar);
}