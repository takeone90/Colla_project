package dao;

import java.util.List;

import model.Project;

public interface ProjectDao {
	public int insertProject(Project project);
	public int deleteProject(int pNum);
	public int updateProject(Project project);
	public Project selectProject(int pNum);
	public List<Project> selectAllProjectByMnum(int mNum);
	public List<Project> selectAllProjectByWnum(int wNum);
	public List<Project> selectAllProject();
}
