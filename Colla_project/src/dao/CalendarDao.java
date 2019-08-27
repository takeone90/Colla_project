package dao;

import java.util.List;
import model.Calendar;

public interface CalendarDao {
	public int insertCalendar(Calendar calendar);
	public int updateCalendar(Calendar calendar);
	public int deleteCalendar(int cNum);
	public Calendar selectCalendar(int cNum);
	public List<Calendar> selectAllCalendar();
	public List<Calendar> selectAllCalendarByMonth();
}