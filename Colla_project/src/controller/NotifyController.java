package controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import model.Alarm;
import service.AlarmService;
import service.WorkspaceService;

@Controller
public class NotifyController {
	@Autowired
	private AlarmService aService;
	@Autowired
	private WorkspaceService wService;
	@SendTo("/category/alarm/{var2}")
	@MessageMapping("/sendAlarm/{var1}/{var2}/{var3}/{var4}")
	public Alarm sendAlarm(@DestinationVariable(value="var1")int wNum,
			@DestinationVariable(value="var2")int mNumTo,
			@DestinationVariable(value="var3")int mNumFrom,
			@DestinationVariable(value="var4")int aDnum,String aType) {
		int aNum = aService.addAlarm(wNum, mNumTo, mNumFrom, aType, aDnum);
		System.out.println("받은내용 || wNum : "+wNum+", mNumTo : "+mNumTo+", mNumFrom : "+mNumFrom+", 알람 타입 : "+aType);
		return aService.getAlarm(aNum);
	}
	@ResponseBody
	@RequestMapping("/hasAlarm")
	public List<Alarm> hasAlarm(@RequestParam("mNum")int mNum){
		List<Alarm> alarmList = aService.getAllAlarm(mNum);
		return alarmList;
	}
	@RequestMapping("/goToTargetURL")
	public String goToTargetURL(int wNum,String aType,int aDnum, HttpSession session) {
		session.removeAttribute("currWnum");
		session.setAttribute("currWnum", wNum);
		session.removeAttribute("wsName");
		session.setAttribute("wsName", wService.getWorkspace(wNum).getName());
		String targetURL = "";
		if(aType.equals("reply")) {
			targetURL = "board/view?num="+aDnum;
		}
		return "redirect:"+targetURL;
	}
}
