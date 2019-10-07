package service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.CalendarDao;
import dao.ProjectDao;
import model.Calendar;

@Service
public class CalendarService {
	@Autowired
	private CalendarDao calendarDao;
	private ProjectDao pDao;
	
	private static final int NUM_PER_PAGE = 10; //한 페이지 당 몇 개의 일정?
	private static final int NUM_OF_NAVI_PAGE = 10; 
	
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
	public List<Calendar> getAllCalendar(int wNum) {
		return calendarDao.selectAllCalendar(wNum);
	}
	public List<Calendar> getAllCalendarByMonth(int wNum, String today) {
		String year = today.substring(2, 4);
		String month = today.substring(4, 6);
		String date = today.substring(6, 8);
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("wNum", wNum);
		param.put("startDate", year+"/"+month+"/"+date);
		param.put("endDate", year+"/"+month+"/"+01);
		List<Calendar> cListByMonth = calendarDao.selectAllCalendarByMonth(param);
//		List<Calendar> tmp = new ArrayList<Calendar>();
//		for(int i=0; i<cListByMonth.size(); i++) {
//			tmp.get(i).getcNum();
//			pDao.
//		}
		return cListByMonth;
	}
	public boolean addCalendarAnnually(Calendar calendar) {
		int result=0;
		for(int i=0; i<4; i++) {//5년 반복
			int yearOrigin = Integer.parseInt(calendar.getStartDate().substring(0, 4))+1;
			String startDateChanged = yearOrigin+calendar.getStartDate().substring(4, 10);
			calendar.setStartDate(startDateChanged);
			calendar.setEndDate(startDateChanged);
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
			calendar.setStartDate(startDateChanged);
			calendar.setEndDate(startDateChanged);
			result = calendarDao.insertCalendar(calendar);
		}
		if(result>0) {
			return true;
		}
		return false;
	}
	//검색 및 페이징 처리
	public Map<String, Object> getAllCalendarSearched(Map<String, Object> param) {
		Map<String, Object> result = new HashMap<String, Object>();
		int page = (Integer)param.get("page");
		int searchType = (Integer)param.get("searchType");
		String searchKeyword = (String)param.get("searchKeyword");
		param.put("firstRow", NUM_PER_PAGE*(page-1)+1);
		param.put("endRow", NUM_PER_PAGE*page);
		if(searchType==1) {
			param.put("title", searchKeyword);
		} else if(searchType==2) {
			param.put("content", searchKeyword);
		} else if(searchType==3) {
			param.put("title", searchKeyword);
			param.put("content", searchKeyword);
		} else if(searchType==4) {
			param.put("mName", searchKeyword);
		}
		List<Calendar> searchedCalendarList = calendarDao.selectAllCalendarSearched(param);
		for(int i=0; i<searchedCalendarList.size(); i++) {
			String SD = searchedCalendarList.get(i).getStartDate().substring(0, 10);
			searchedCalendarList.get(i).setStartDate(SD);
			String ED = searchedCalendarList.get(i).getEndDate().substring(0, 10);
			searchedCalendarList.get(i).setEndDate(ED);
		}
		result = getPageData(param);
		result.put("searchedCalendarList", searchedCalendarList);
		System.out.println("result : "+result);
		return result;
	}
	public Map<String, Object> getPageData(Map<String, Object> param) {
		Map<String, Object> result = new HashMap<String, Object>();
		int page = (Integer)param.get("page");
		result.put("startPage", getStartPage(page));
		result.put("endPage", getEndPage(page));
		result.put("totalPageCount", getTotalPage(param));
		return result;		
	}
	private int getStartPage(int pageNumber) {
		return ((pageNumber-1)/NUM_OF_NAVI_PAGE)*NUM_OF_NAVI_PAGE+1;
	}
	private int getEndPage(int pageNumber) {
		return getStartPage(pageNumber)+(NUM_OF_NAVI_PAGE-1);
	}
	private int getTotalPage(Map<String, Object> param) {
		return (int)Math.ceil(calendarDao.selectCalendarCount(param)/(double)NUM_PER_PAGE);
	}
}