package controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.StringTokenizer;

import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import model.Calendar;
import service.CalendarService;

@Controller
public class CalendarController {
	
	@Autowired
	private CalendarService calendarService;
	
	@RequestMapping(value="/calMonth", method = RequestMethod.GET)
	public String showCalMonth(Model model) {
		return "/calendar/calMonth";
	}
	
	@ResponseBody
	@RequestMapping(value="/showAllCalendar", method=RequestMethod.GET)
	public List<Calendar> showAllCalendar() {
		List<Calendar> tmp = calendarService.getAllCalendar();
		System.out.println(tmp);
		for(int i=0; i<tmp.size(); i++) {
			String dateStr = tmp.get(i).getStartDate();
			String year = dateStr.substring(0, 4);
			String month = dateStr.substring(5, 7);
			String date = dateStr.substring(8, 10);
			System.out.println("년: "+year+" 월: "+month+" 일: "+date);
		}
		
		return tmp;
	}
	
	@RequestMapping(value="/calYear", method = RequestMethod.GET)
	public String showCalYear() {
		return "/calendar/calYear";
	}
	
	@RequestMapping(value="/calSearchList", method = RequestMethod.GET)
	public String showCalSearchList() {
		return "/calendar/calSearchList";
	}
	
	@ResponseBody
	@RequestMapping(value="/addSchedule", method = RequestMethod.POST)
	public boolean addSchedule(Calendar calendar) {
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
		boolean result = calendarService.addCalendar(calendar);
		return result;
	}
	@ResponseBody
	@RequestMapping(value="/modifySchedule")
	public boolean modifySchedule(Calendar calendar) {
		return calendarService.modifyCalendar(calendar);
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
	
}
