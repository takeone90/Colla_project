package controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import model.Calendar;
import service.CalendarService;

@Controller
public class CalendarController {
	
	@Autowired
	private CalendarService calendarService;
	
	@RequestMapping(value="/calMonth", method = RequestMethod.GET)
	public String showCalMonth() {
		return "/calendar/calMonth";
	}
	@RequestMapping(value="/calDetail", method = RequestMethod.GET)
	public String showCalDetail() {
		return "/calendar/calDetail";
	}
	
	@ResponseBody
	@RequestMapping(value="/showAllCalendar", method=RequestMethod.GET)
	public List<Calendar> showAllCalendar(boolean t1, boolean t2, boolean t3) {
		List<Calendar> tmp = calendarService.getAllCalendar();
		List<Calendar> tmpList = new ArrayList<Calendar>();
		for(int i=0; i<tmp.size(); i++) {
			if(t1) {
				String typeTmp = tmp.get(i).getType();
				if(typeTmp.equals("project")) {
					tmpList.add(tmp.get(i));
				}
			}
			if(t2) {
				String typeTmp = tmp.get(i).getType();
				if(typeTmp.equals("vacation")) {
					tmpList.add(tmp.get(i));
				}
			}
			if(t3) {
				String typeTmp = tmp.get(i).getType();
				if(typeTmp.equals("event")) {
					tmpList.add(tmp.get(i));
				}
			}
//			System.out.println(getWeekOfMonth(tmp.get(i).getStartDate()));
//			tmpMap.put("weekCount"+tmp.get(i).getcNum(), getWeekOfMonth(tmp.get(i).getStartDate()));
		}
		return tmpList;
	}
	
	private int getWeekOfMonth(String date) {
		System.out.println(date);
		java.util.Calendar tmpCalendar = java.util.Calendar.getInstance();
		int year = Integer.parseInt(date.substring(0, 4));
		int month = Integer.parseInt(date.substring(5, 7));
		int day = Integer.parseInt(date.substring(8, 10));
		System.out.println(year+" "+month+" "+day);
		tmpCalendar.set(year, month - 1, day);
		return tmpCalendar.get(java.util.Calendar.WEEK_OF_MONTH);
	}
	
	@ResponseBody
	@RequestMapping(value="/showYearCheckedCalendar", method=RequestMethod.GET)
	public List<Calendar> showYearCheckedCalendar(boolean t1, boolean t2, boolean t3) {
		List<Calendar> tmp = calendarService.getAllCalendar();
		List<Calendar> yearCheckedCalendarList = new ArrayList<Calendar>();
		for(int i=0; i<tmp.size(); i++) {
			String yearChecked = tmp.get(i).getYearCalendar();
			if(yearChecked.equals("1")) {
				yearCheckedCalendarList.add(tmp.get(i));
			}
		}
		List<Calendar> tmpList = new ArrayList<Calendar>();
		for(int i=0; i<yearCheckedCalendarList.size(); i++) {
			if(t1) {
				String typeTmp = yearCheckedCalendarList.get(i).getType();
				if(typeTmp.equals("project")) {
					tmpList.add(yearCheckedCalendarList.get(i));
				}
			}
			if(t2) {
				String typeTmp = yearCheckedCalendarList.get(i).getType();
				if(typeTmp.equals("vacation")) {
					tmpList.add(yearCheckedCalendarList.get(i));
				}
			}
			if(t3) {
				String typeTmp = yearCheckedCalendarList.get(i).getType();
				if(typeTmp.equals("event")) {
					tmpList.add(yearCheckedCalendarList.get(i));
				}
			}
		}
		System.out.println(tmpList);
		return tmpList;
	}
	@RequestMapping(value="/calYear", method = RequestMethod.GET)
	public String showCalYear() {
		return "/calendar/calYear";
	}

//검색-----------------------------------------------------------------------
	@RequestMapping(value="/calSearchList", method = RequestMethod.GET)
	public String showCalSearchList(Model model, @RequestParam(required=false)String searchKeyword, @RequestParam(defaultValue="0")int searchType) {	
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchType", searchType);
		param.put("searchKeyword", searchKeyword);
		System.out.println("param : "+param);
		Map<String, Object> result = calendarService.getAllCalendarSearched(param);
		System.out.println("controller result : "+result);
		model.addAttribute("searchedCalendarList", result.get("searchedCalendarList"));
		return "/calendar/calSearchList";
	}
	
	@ResponseBody
	@RequestMapping(value="/addSchedule", method = RequestMethod.POST)
	public boolean addSchedule(Calendar calendar) throws ParseException {
		if(calendar.getYearCalendar()!=null && calendar.getYearCalendar().equals("yearCalendar")) {
			calendar.setYearCalendar("1");
		} else {
			calendar.setYearCalendar("0");
		}
		if(calendar.getAnnually()!=null && calendar.getAnnually().equals("annually")) {
			calendar.setAnnually("1");
		} else {
			calendar.setAnnually("0");
		}
		if(calendar.getMonthly()!=null && calendar.getMonthly().equals("monthly")) {
			calendar.setMonthly("1");
		} else {
			calendar.setMonthly("0");
		}
		boolean result = calendarService.addCalendar(calendar);
		String startDateTmp = calendar.getStartDate();
		if(calendar.getAnnually().equals("1")) {
			calendarService.addCalendarAnnually(calendar);
		} 
		calendar.setStartDate(startDateTmp);
		if(calendar.getMonthly().equals("1")) {
			calendarService.addCalendarMonthly(calendar);
		}
		return result;
	}
	@ResponseBody
	@RequestMapping(value="/modifySchedule")
	public boolean modifySchedule(Calendar calendar) {
		System.out.println("modifySchedule");
		if(calendar.getAnnually()!=null && calendar.getAnnually().equals("annually")) {
			calendar.setAnnually("1");
		} else {
			calendar.setAnnually("0");
		}
		if(calendar.getYearCalendar()!=null && calendar.getYearCalendar().equals("yearCalendar")) {
			calendar.setYearCalendar("1");
		} else {
			calendar.setYearCalendar("0");
		}
		if(calendar.getMonthly()!=null && calendar.getMonthly().equals("monthly")) {
			calendar.setMonthly("1");
		} else {
			calendar.setMonthly("0");
		}
		System.out.println(calendar);
		boolean result = calendarService.modifyCalendar(calendar);
		return result;
	}
	@ResponseBody
	@RequestMapping(value="/removeSchedule", method = RequestMethod.POST)
	public boolean removeSchedule(Calendar calendar) {
		System.out.println(calendar);
		int cNum = calendar.getcNum();
		System.out.println(cNum);
		return calendarService.removeCalendar(cNum);
	}
	@ResponseBody
	@RequestMapping(value="/selectSchedule", method = RequestMethod.POST)
	public Calendar selectSchedule(Calendar calendar) {
		System.out.println(calendar);
		int cNum = calendar.getcNum();
		System.out.println(cNum);
		return calendarService.getCalendar(cNum);
	}
//	@ResponseBody
//	@RequestMapping(value="/selectSchedule", method = RequestMethod.POST)
//	public Calendar selectAllScheduleByMonth(Calendar calendar) {
//		System.out.println(calendar);
//		int cNum = calendar.getcNum();
//		System.out.println(cNum);
//		return calendarService.getCalendar(cNum);
//	}
}
