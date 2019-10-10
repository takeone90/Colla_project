package service;

import java.awt.Color;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.ChatRoomDao;
import dao.ChatRoomMemberDao;
import dao.ProjectDao;
import dao.ProjectMemberDao;
import model.Calendar;
import model.ChatRoom;
import model.ChatRoomMember;
import model.Project;
import model.ProjectMember;

@Service
public class ProjectService {
	@Autowired
	private ProjectDao pDao;
	@Autowired
	private ProjectMemberDao pmDao;
	@Autowired
	private ChatRoomDao crDao;
	@Autowired
	private ChatRoomMemberDao crmDao;
	@Autowired
	private CalendarService cService;
	
	public int addProject(String pName,int wNum,String pDetail,Date pStartDate,Date pEndDate,int mNum) {
		ChatRoom chatRoom = new ChatRoom();
		chatRoom.setwNum(wNum);
		chatRoom.setCrName(pName); //프로젝트 이름 = 채팅방 이름
		chatRoom.setmNum(mNum);
		if(crDao.insertChatRoom(chatRoom)>0) {
			ChatRoomMember crm = new ChatRoomMember();
			crm.setwNum(wNum);
			crm.setCrNum(chatRoom.getCrNum());
			crm.setmNum(mNum);
			crmDao.insertChatRoomMember(crm); //프로젝트 만든 사람을 채팅방 멤버로 추가	
		} // 채팅방 추가 끝
		Calendar calendar = new Calendar();
		SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd");
		calendar.setTitle(pName);
		calendar.setContent(pDetail);
		calendar.setStartDate(dt.format(pStartDate)); //Date -> String
		calendar.setEndDate(dt.format(pEndDate));
		calendar.setmNum(mNum);
		calendar.setwNum(wNum);
		calendar.setType("project");
		calendar.setYearCalendar("0");
		calendar.setMonthly("0");
		calendar.setAnnually("0");
		calendar.setColor(getRandomColor()); //랜덤 컬러
		cService.addCalendar(calendar); //캘린더 추가 끝
		int pNum = 0;
		Project project = new Project();
		project.setwNum(wNum);
		project.setCrNum(chatRoom.getCrNum());
		project.setCalNum(calendar.getcNum());
		project.setmNum(mNum);
		project.setpName(pName);
		project.setpDetail(pDetail);
		project.setpStartDate(pStartDate);
		project.setpEndDate(pEndDate);
		if(pDao.insertProject(project)>0) { //프로젝트 멤버 추가
			pNum = project.getpNum();
			pDao.updateChatRoomPnum(pNum, project.getCrNum()); //채팅방에 pNum 넣어주기
			ProjectMember pm = new ProjectMember();
			pm.setpNum(pNum);
			pm.setmNum(mNum); 
			pmDao.insertProjectMember(pm); //프로젝트 만든 사람을.. 프로젝트 멤버에 추가
		} // 프로젝트 추가 끝
		return pNum;
	}
	public boolean removeProject(int pNum) {
		boolean result1 = false;
		if(pDao.deleteProject(pNum)>0) {
			result1 = true;
		}
//		boolean result2 = false;
//		if(crmDao.deleteChatRoomMemberByCrNumMnum(pDao.selectProject(pNum).getCrNum(), pDao.selectProject(pNum).getmNum())>0) {
//			result2 = true;
//		}
//		if(result1 && result2) {
//			return true;
//		}
		return result1;
	}
	public boolean removeEmptyProject(){
		boolean result = false;
		if(pDao.deleteEmptyProject()>0) {
			
			
			result = true;
		}
		return result;
	}
	public boolean removeAllProjectByWnum(int wNum) {
		boolean result = false;
		if(pDao.deleteAllProjectByWnum(wNum)>0) {
			result = true;
		}
		return result;
	}
	public boolean modifyProject(int pNum, String pName, String pDetail, Date pStartDate, Date pEndDate, int mNum) {
		Project project = pDao.selectProject(pNum);
		project.setpName(pName);
		project.setpDetail(pDetail);
		project.setpEndDate(pEndDate);
		project.setpStartDate(pStartDate);	
		project.setmNum(mNum);
		boolean result1 = false;
		if(pDao.updateProject(project)>0) {
			result1 = true;
		}
		//채팅방 이름 바꾸기
		ChatRoom chatRoom = crDao.selectChatRoom(project.getCrNum());
		chatRoom.setCrName(pName);
		boolean result2 = false;
		if(crDao.updateChatRoom(chatRoom)>0) {
			result2 = true;
		}
		//캘린더 수정
		Calendar calendar = cService.getCalendar(project.getCalNum());
		SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd");
		calendar.setTitle(pName);
		calendar.setContent(pDetail);
		calendar.setStartDate(dt.format(pStartDate)); //Date -> String
		calendar.setEndDate(dt.format(pEndDate));
		calendar.setmNum(mNum);
		cService.modifyCalendar(calendar);
		if(result1 && result2) {
			return true;
		}
		return false;
	}
	public Project getProject(int pNum) {
		return pDao.selectProject(pNum);
	}
	public Project getProjectByCrNum(int crNum) {
		return pDao.selectProjectByCrNum(crNum);
	}
	public List<Project> getAllProjectByMnum(int mNum){
		return pDao.selectAllProjectByMnum(mNum);
	}
	public List<Project> getAllProjectByWnum(int wNum){
		return pDao.selectAllProjectByWnum(wNum);
	}
	public List<Project> getAllProject(){
		return pDao.selectAllProject();
	}
	public List<Project> getAllProjectByMnumWnum(int mNum,int wNum){
		return pDao.selectAllProjectByMnumWnum(mNum, wNum);
	}
	public double calcProgress(int pNum,int completeCount,int allCount) {
		double result = ((double)completeCount/allCount*100);
		double calcProgress = Math.round(result*10)/10.0;
		Project p = pDao.selectProject(pNum);
		p.setProgress(calcProgress);
		pDao.updateProject(p);
		return calcProgress;
	}
	public static String getRandomColor() {
        String[] letters = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"};
        String color = "#";
        for (int i = 0; i < 6; i++ ) {
           color += letters[(int) Math.round(Math.random() * 15)];
        }
        return color;
   }
	//혜선 추가
	public int getPnumByCnum(int calNum){
		return pDao.selecPNumByCalNum(calNum);
	}
}

