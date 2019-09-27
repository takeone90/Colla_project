package service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.ProjectDao;
import model.Project;

@Service
public class ProjectService {
	@Autowired
	private ProjectDao pDao;
	public int addProject(String pName,int wNum,String pDetail,Date pStartDate,Date pEndDate,int crNum,int mNum) {
		int pNum = 0;
		Project project = new Project();
		project.setpName(pName);
		project.setwNum(wNum);
		project.setCrNum(crNum);
		project.setmNum(mNum);
		project.setpDetail(pDetail);
		project.setpEndDate(pEndDate);
		project.setpStartDate(pStartDate);
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

