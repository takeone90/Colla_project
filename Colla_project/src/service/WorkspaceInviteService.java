package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.WorkspaceInviteDao;
import model.WorkspaceInvite;

@Service
public class WorkspaceInviteService {
	@Autowired
	private WorkspaceInviteDao wiDao;
	public boolean addWorkspaceInvite(String targetUser,int wNum) {
		boolean result = false;
		return result;
	}
	public void isAccept(String targetUser) {
		WorkspaceInvite wi = getWorkspaceInviteByTargetUser(targetUser);
		wi.setIsAccept(1);
	}
	public void wasJoinedUs(String targetUser) {
		WorkspaceInvite wi = getWorkspaceInviteByTargetUser(targetUser);
		wi.setWasJoinedUs(1);
	}
	public WorkspaceInvite getWorkspaceInviteByTargetUser(String targetUser) {
		return wiDao.selectWorkspaceInvite(targetUser);
	}
	public List<WorkspaceInvite> getAllWiList(){
		return wiDao.selectAllWorkspaceInvite();
	}
}
