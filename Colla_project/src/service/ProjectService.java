package service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.ChatRoomDao;
import dao.ChatRoomMemberDao;
import dao.ProjectDao;
import dao.ProjectMemberDao;
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
	
	public int addProject(String pName,int wNum,String pDetail,String pStartDate,String pEndDate,int mNum) {
		ChatRoom chatRoom = new ChatRoom();
		chatRoom.setCrName(pName); //프로젝트 이름 = 채팅방 이름
		chatRoom.setmNum(mNum);
		chatRoom.setwNum(wNum);
		if(crDao.insertChatRoom(chatRoom)>0) { //프로젝트 멤버를 채팅방 멤버 추가..
			ChatRoomMember crm = new ChatRoomMember();
			crm.setCrNum(chatRoom.getCrNum());
			crm.setwNum(wNum);
			crmDao.insertChatRoomMember(crm);
			
		} // 채팅방 추가 끝
		// 채팅방을 먼저 추가하고 그 채팅방의 crNum을 가져온다. 
		int pNum = 0;
		Project project = new Project();
		project.setpName(pName);
		project.setwNum(wNum);
		project.setCrNum(chatRoom.getCrNum());
		project.setmNum(mNum);
		project.setpDetail(pDetail);
		project.setpEndDate(pEndDate);
		project.setpStartDate(pStartDate);
		if(pDao.insertProject(project)>0) { //프로젝트 멤버 추가
			pNum = project.getpNum();
			chatRoom.setpNum(pNum); //채팅방에 pNum 넣어주기
			ProjectMember pm = new ProjectMember();
			pm.setpNum(pNum);
			pm.setmNum(mNum);
			pmDao.insertProjectMember(pm);
		} // 프로젝트 추가 끝
		return pNum;
	}
	
	public boolean removeProject(int pNum) {
		boolean result = false;
		if(pDao.deleteProject(pNum)>0) {
			result = true;
		}
		return result;
	}
	public boolean modifyProject(Project project) {
		boolean result = false;
		if(pDao.updateProject(project)>0) {
			result = true;
		}
		return result;
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
}

