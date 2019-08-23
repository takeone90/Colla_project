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
	private WorkspaceDao dao;
	@Autowired
	private wsMemberDao wmDao;
	//workspace 의 w_num 이랑 wsMember 테이블의 w_num이랑 다르다.
	//insertWorkspace가 되면서 wsMember 테이블에  wNum과 mNum을 묶는 기능이 필요하다
	public boolean addWorkspace(int mNum,String name) {
		boolean result = false;
		Workspace ws = new Workspace();
		ws.setmNum(mNum);
		ws.setName(name);
		if(dao.insertWorkspace(ws)>0) { //이때 ws에 wNum이 들어갈까?
			//어떻게 w_num을 가져올까
			WsMember wsMember = new WsMember();
			wsMember.setmNum(mNum);
			wsMember.setwNum(ws.getNum());
			wmDao.insertWsMember(wsMember);
			result = true;
		}
		return result;
		
	}  
	public void addWsMember() {
		
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
