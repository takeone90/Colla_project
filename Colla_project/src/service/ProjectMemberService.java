package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.ProjectMemberDao;
import model.ProjectMember;

@Service
public class ProjectMemberService {
	@Autowired
	private ProjectMemberDao pmDao;
	public boolean addProjectMember(int pNum,int mNum) {
		boolean result = false;
		ProjectMember pm = new ProjectMember();
		pm.setmNum(mNum);
		pm.setpNum(pNum);
		if(pmDao.insertProjectMember(pm)>0) {
			result = true;
		}
		return result;
	}
	public boolean removeProjectMember(int pNum,int mNum) {
		boolean result = false;
		if(pmDao.deleteProjectMember(pNum, mNum)>0) {
			result = true;
		}
		return result;
	}
	public ProjectMember getProjectMember(int pNum,int mNum) {
		return pmDao.selectProjectMember(pNum, mNum);
	}
	public List<ProjectMember> getAllProjectMemberByPnum(int pNum){
		return pmDao.selectAllProjectMemberByPnum(pNum);
	}
}
