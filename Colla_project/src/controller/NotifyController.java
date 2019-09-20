package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import model.Alarm;
import service.AlarmService;

@Controller
public class NotifyController {
	@Autowired
	private AlarmService aService;
	
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
}
