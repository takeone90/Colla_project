package service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.WorkspaceDao;
import dao.wsMemberDao;
import model.Workspace;
import model.WsMember;

@Service
public class WorkspaceService {
	@Autowired
	private WspaceDao dao;
	@Autowired
	private wsMemberDao wmDao;
	public boolean addWorkspace(int mNum,String name) {
		boolean result = false;
		Workspace ws = new Workspace();
		ws.setmNum(mNum);
		ws.setName(name);
		if(dao.insertWorkspace(ws)>0) { 
			WsMember wsMember = new WsMember();
			wsMember.setmNum(mNum);
			wsMember.setwNum(ws.getNum());
			wmDao.insertWsMember(wsMember);
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
	//멤버가 가진 모든 workspace 리스트 반환
	public List<Workspace> getWsListByMnum(int mNum){
		List<Integer> wNumList = wmDao.selectAllWnumByMnum(mNum); //이 멤버가 가진 모든 workspace번호 리스트
		List<Workspace> wsList = new ArrayList<Workspace>(); 
		for(int wNum : wNumList) {
			wsList.add(getWorkspace(wNum));
		}
		return wsList;
	}
}
