package service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	public Map<String, Object> getAllCalendarSearched(Map<String, Object> param) {
		Map<String, Object> result = new HashMap<String, Object>();
		int searchType = (Integer)param.get("searchType");
		String searchKeyword = (String)param.get("searchKeyword");
		if(searchType==1) {
			param.put("title", searchKeyword);
		} else if(searchType==2) {
			param.put("content", searchKeyword);
		} else if(searchType==3) {
			param.put("mNum", searchKeyword);
		}
		List<Calendar> searchedCalendarList = calendarDao.selectAllCalendarSearched(param);
		result.put("searchedCalendarList", searchedCalendarList);
		System.out.println("service result2 : "+result);
		return result;
	}
	public boolean addCalendarAnnually(Calendar calendar) {
		int result=0;
		for(int i=0; i<4; i++) {//5년 반복
			int yearOrigin = Integer.parseInt(calendar.getStartDate().substring(0, 4))+1;
			String startDateChanged = yearOrigin+calendar.getStartDate().substring(4, 10);
			calendar.setStartDate(startDateChanged);
			System.out.println("Annually startDateChanged : "+startDateChanged);
			result = calendarDao.insertCalendar(calendar);
		}
		if(result>0) {
			return true;
		}
		return false;
	}
	public boolean addCalendarMonthly(Calendar calendar) throws ParseException {
		int result=0;
		for(int i=0; i<11; i++) { //12개월 반복
			String monthOrigin = calendar.getStartDate();
			SimpleDateFormat monthOriginTrans = new SimpleDateFormat("yyyy-MM-dd");
			Date monthOriginDate = monthOriginTrans.parse(monthOrigin);
			java.util.Calendar cal = java.util.Calendar.getInstance();
			cal.setTime(monthOriginDate);
			cal.add(java.util.Calendar.MONTH, 1);
			String startDateChanged = monthOriginTrans.format(cal.getTime());
			System.out.println("Monthly startDateChanged : "+startDateChanged);
			calendar.setStartDate(startDateChanged);
			result = calendarDao.insertCalendar(calendar);
		}
		if(result>0) {
			return true;
		}
		return false;
	}
}