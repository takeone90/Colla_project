package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.CalendarDao;
import model.Calendar;



@Service
public class CalendarService {
	@Autowired
	private CalendarDao calendarDao;
	
	public boolean addCalendar(Calendar calendar) {
		if(calendarDao.insertCalendar(calendar)>0) {
			return true;
		}
		return false;
	}
	public boolean modifyCalendar(Calendar calendar) {
		if(calendarDao.updateCalendar(calendar)>0) {
			return true;
		}
		return false;
	}
	public boolean removeCalendar(int cNum) {
		if(calendarDao.deleteCalendar(cNum)>0) {
			return true;
		}
		return false;
	}
	public Calendar getCalendar(int cNum) {
		return calendarDao.selectCalendar(cNum);
	}
	public List<Calendar> getAllCalendar() {
		return calendarDao.selectAllCalendar();
	}
	public List<Calendar> getAllCalendarByMonth() {
		return calendarDao.selectAllCalendarByMonth();
	}
}
