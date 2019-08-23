package service;

import java.util.List;

import org.springframework.stereotype.Service;

import dao.WorkspaceDao;
import model.Workspace;

@Service
public class WorkspaceService {
	private WorkspaceDao dao;
	public boolean addWorkspace(int mNum,String name) {
		boolean result = false;
		Workspace ws = new Workspace();
		ws.setmNum(mNum);
		ws.setName(name);
		if(dao.insertWorkspace(ws)>0) {
			result = true;
		}
		return result;
		
	}
	public boolean modifyWorkspace(Workspace ws) {
		boolean result = false;
		if(dao.updateWorkspace(ws)>0) {
			result = true;
		}
		return result;
	}
	public boolean removeWorkspace(int num) {
		boolean result = false;
		if(dao.deleteWorkspace(num)>0) {
			result = true;
		}
		return result;
	}
	public Workspace getWorkspace(int num) {
		return dao.selectWorkspace(num);
	}
	public List<Workspace> getAllWorkspace(){
		return dao.selectAllWorkspace();
	}
}
