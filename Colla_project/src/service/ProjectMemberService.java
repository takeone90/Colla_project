package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.ChatRoomDao;
import dao.ChatRoomMemberDao;
import dao.ProjectDao;
import dao.ProjectMemberDao;
import model.ChatRoomMember;
import model.Project;
import model.ProjectMember;

@Service
public class ProjectMemberService {
	@Autowired
	private ProjectDao pDao;
	@Autowired
	private ProjectMemberDao pmDao;
	@Autowired
	private ChatRoomMemberDao crmDao;
	
	public boolean addProjectMember(int pNum, int mNum) {
		boolean result = false;
		ProjectMember pm = new ProjectMember();
		pm.setmNum(mNum);
		pm.setpNum(pNum);
		if(pmDao.insertProjectMember(pm)>0) { //프로젝트에 초대 멤버들 추가
			result = true;
		}
		return result;
	}
	public boolean removeProjectMember(int pNum, int mNum) {
		boolean result1 = false;
		if(pmDao.deleteProjectMember(pNum, mNum)>0) {
			result1 = true;
		}
		boolean result2 = false;
		if(crmDao.deleteChatRoomMemberByCrNumMnum(pDao.selectProject(pNum).getCrNum(), pDao.selectProject(pNum).getmNum())>0) {
			result2 = true;
		}
		if(result1 && result2) {
			return true;
		}
		return false;
	}
	public ProjectMember getProjectMember(int pNum,int mNum) {
		return pmDao.selectProjectMember(pNum, mNum);
	}
	public List<ProjectMember> getAllProjectMemberByPnum(int pNum){
		return pmDao.selectAllProjectMemberByPnum(pNum);
	}
}
