package dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import model.Project;

public interface ProjectDao {
	public int insertProject(Project project);
	public int updateChatRoomPnum(@Param("pNum")int pNum, @Param("crNum")int crNum);
	public int deleteProject(int pNum);
	public int deleteEmptyProject();
	public int deleteAllProjectByWnum(int wNum);
	public int updateProject(Project project);
	public Project selectProject(int pNum);
	public Project selectProjectByCrNum(int crNum);
	public List<Project> selectAllProjectByMnum(int mNum);
	public List<Project> selectAllProjectByWnum(int wNum);
	public List<Project> selectAllProjectByMnumWnum(@Param("mNum")int mNum,@Param("wNum")int wNum);
	public List<Project> selectAllProject();
}
