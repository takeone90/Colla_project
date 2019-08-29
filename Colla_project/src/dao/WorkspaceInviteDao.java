package dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.junit.runners.Parameterized.Parameters;

import model.WorkspaceInvite;

public interface WorkspaceInviteDao {
	public int insertWorkspaceInvite(WorkspaceInvite workspaceInvite);
	public int deleteWorkspaceInvite(@Param("wiTargetUser")String wiTargetUser,@Param("wNum")int wNum);
	public WorkspaceInvite selectWorkspaceInvite(@Param("wiTargetUser")String wiTargetUser,@Param("wNum")int wNum);
	public List<WorkspaceInvite> selectAllWorkspaceInvite();
}
