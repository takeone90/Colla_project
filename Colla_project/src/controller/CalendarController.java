package controller;

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
	public String showCalMonth() {
		return "/calendar/calMonth";
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
	@RequestMapping(value="/addSchedule", method = RequestMethod.GET)
	public boolean addSchedule(Calendar data, int yearCalendar, int annually, int monthly) {
		System.out.println("addSchedule");
		System.out.println(data);
		return calendarService.addCalendar(data);
	}
	@ResponseBody
	@RequestMapping(value="/modifySchedule")
	public boolean modifySchedule(Calendar calendar) {
		return calendarService.modifyCalendar(calendar);
	}
	@ResponseBody
	@RequestMapping(value="/removeSchedule")
	public boolean removeSchedule(int cNum) {
		return calendarService.removeCalendar(cNum);
	}
}
