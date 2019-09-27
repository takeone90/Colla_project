package controller;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import model.Project;
import service.ProjectService;

@Controller
public class ProjectController {
	@Autowired
	private ProjectService projectService;
	
	@RequestMapping("/projectMain") //projectMain으로 이동
	public String showProjectMain(int wNum) {
		return "/project/projectMain";
	}
	
	//-------------------------------------------------------------------------------CRUD 
	
	@ResponseBody
	@RequestMapping(value="/addProject", method = RequestMethod.POST)
	public int addProject(String pName, int wNum, String pDetail, Date pStartDate, Date pEndDate, int crNum, int mNum) {
		int pNum = projectService.addProject(pName, wNum, pDetail, pStartDate, pEndDate, crNum, mNum);
		return pNum;
	}
	@ResponseBody
	@RequestMapping(value="/removeProject", method = RequestMethod.POST)
	public boolean removeProject(int pNum) {
		boolean result = projectService.removeProject(pNum);
		return result;
	}
	@ResponseBody
	@RequestMapping(value="/modifyProject", method = RequestMethod.POST)
	public boolean modifyProject(Project project) {
		boolean result = projectService.modifyProject(project);
		return result;
	}
	@ResponseBody
	@RequestMapping(value="/getProject", method = RequestMethod.POST)
	public Project getProject(int pNum) {
		Project projectTmp = projectService.getProject(pNum);
		return projectTmp;
	}
	@ResponseBody
	@RequestMapping(value="/getProjectByCrNum", method = RequestMethod.POST)
	public Project getProjectByCrNum(int crNum) {
		Project projectTmp = projectService.getProjectByCrNum(crNum);
		return projectTmp;
	}
	@ResponseBody
	@RequestMapping(value="/getAllProjectByMnum", method = RequestMethod.POST)
	public List<Project> getAllProjectByMnum(int mNum) {
		List<Project> projectList = projectService.getAllProjectByMnum(mNum);
		return projectList;
	}
	@ResponseBody
	@RequestMapping(value="/getAllProjectByWnum", method = RequestMethod.POST)
	public List<Project> getAllProjectByWnum(int wNum) {
		List<Project> projectList = projectService.getAllProjectByWnum(wNum);
		return projectList;
	}
	@ResponseBody
	@RequestMapping(value="/getAllProject", method = RequestMethod.POST)
	public List<Project> getAllProject() {
		List<Project> projectList = projectService.getAllProject();
		return projectList;
	}
}
