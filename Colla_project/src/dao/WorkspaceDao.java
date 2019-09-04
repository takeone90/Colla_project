package dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import model.Workspace;

public interface WorkspaceDao {
	public int insertWorkspace(Workspace workspace);
	public int updateWorkspace(Workspace workspace);
	public int deleteWorkspace(int num);
	public Workspace selectWorkspace(int num);
	public List<Workspace> selectAllWorkspace();
	
}
