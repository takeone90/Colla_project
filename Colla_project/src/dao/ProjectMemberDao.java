package dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import model.ProjectMember;

public interface ProjectMemberDao {
	public int insertProjectMember(ProjectMember pm);
	public int deleteProjectMember(@Param("pNum")int pNum,@Param("mNum")int mNum);
	public ProjectMember selectProjectMember(@Param("pNum")int pNum,@Param("mNum")int mNum);
	public List<ProjectMember> selectAllProjectMemberByPnum(int pNum);
}
