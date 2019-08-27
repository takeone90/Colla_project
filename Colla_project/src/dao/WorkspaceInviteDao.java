package dao;

import java.util.List;

import model.WorkspaceInvite;

public interface WorkspaceInviteDao {
	public int insertWorkspaceInvite(WorkspaceInvite workspaceInvite);
	public WorkspaceInvite selectWorkspaceInvite(String wiTargetUser);
	public List<WorkspaceInvite> selectAllWorkspaceInvite();
}
