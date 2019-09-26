package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.ProjectDao;
import model.Project;

@Service
public class ProjectService {
	@Autowired
	private ProjectDao pDao;
	public int addProject(String pName,int wNum) {
		int pNum = 0;
		Project project = new Project();
		project.setpName(pName);
		project.setwNum(wNum);
		if(pDao.insertProject(project)>0) {
			pNum = project.getpNum();
		}
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

