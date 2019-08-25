package controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class CalendarController {
	
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
	
	@RequestMapping(value="/addSchedule")
	public String addSchedule() {
		
		return "";
	}
}
