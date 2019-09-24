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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import model.Alarm;
import model.Member;
import model.Workspace;
import model.WsMember;
import service.AlarmService;
import service.MemberService;
import service.WorkspaceService;
import service.WsMemberService;

@Controller
public class NotifyController {
	@Autowired
	private AlarmService aService;
	@Autowired
	private WorkspaceService wService;
	@Autowired
	private MemberService mService;
	@Autowired
	private WsMemberService wsmService;
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
	public String goToTargetURL(int aNum,int wNum,String aType,int aDnum, HttpSession session) {
		Alarm alarm = aService.getAlarm(aNum);
		int mNumTo = alarm.getmNumTo();
		Member member = mService.getMember(mNumTo);
		session.removeAttribute("currWnum");
		session.setAttribute("currWnum", wNum);
		session.removeAttribute("wsName");
		session.setAttribute("wsName", wService.getWorkspace(wNum).getName());
		String targetURL = "";
		if(aType.equals("reply") || aType.equals("notice")) {
			targetURL = "board/view?num="+aDnum;
		}else if(aType.equals("cInvite")) {
			targetURL = "chatMain?crNum="+aDnum;
		}else if(aType.equals("wInvite")) {
			targetURL = "addMember?id="+member.getEmail()+"&wNum="+wNum;
		}
		
		aService.removeAlarm(aNum);			
		return "redirect:"+targetURL;
	}
	@ResponseBody
	@RequestMapping("/deleteThisAlarm")
	public List<Alarm> deleteThisAlarm(@RequestParam("aNum")int aNum,@RequestParam("mNum")int mNum) {
		aService.removeAlarm(aNum);
		List<Alarm> alarmList = aService.getAllAlarm(mNum);
		return alarmList;
	}
	
	@ResponseBody
	@RequestMapping(value="/getWname")
	public Map<String,Object> getWname(@RequestParam("wNum")int wNum) {
		Map<String, Object> inviteInfoMap = new HashMap<String, Object>();
		Workspace ws = wService.getWorkspace(wNum);
		String wsName = ws.getName();
		List<WsMember> wsmList = wsmService.getAllWsMemberByWnum(wNum);
		List<Member> realWsmList = new ArrayList<Member>();
		for(WsMember wsm : wsmList) {
			Member member = mService.getMember(wsm.getmNum());
			realWsmList.add(member);
		}
		inviteInfoMap.put("wName", ws.getName());
		inviteInfoMap.put("wsmList", realWsmList);
		return inviteInfoMap;
	}
}
