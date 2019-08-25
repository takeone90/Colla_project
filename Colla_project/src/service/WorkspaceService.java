package service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.ChatRoomDao;
import dao.WorkspaceDao;
import dao.WsMemberDao;
import model.ChatRoom;
import model.Workspace;
import model.WsMember;

@Service
public class WorkspaceService {
	@Autowired
	private WorkspaceDao wDao;
	@Autowired
	private WsMemberDao wmDao;
	@Autowired
	private ChatRoomDao chatDao;
	public boolean addWorkspace(int mNum,String name) {
		boolean result = false;
		Workspace ws = new Workspace();
		ws.setmNum(mNum);
		ws.setName(name);
		if(wDao.insertWorkspace(ws)>0) {
			//workspace 생성에 성공했으면
			//workspace_member 테이블에 멤버를 추가해주는 작업
			WsMember wsMember = new WsMember();
			wsMember.setmNum(mNum);
			wsMember.setwNum(ws.getNum());
			wmDao.insertWsMember(wsMember);
			
			//기본채팅방 하나를 만들어주는 작업
			ChatRoom chatRoom = new ChatRoom();
//			chatRoom.setCrName(ws.getName()+"의 "+"기본채팅방");
			chatRoom.setCrName("기본채팅방");
			chatRoom.setmNum(mNum); //workspace생성자가 기본채팅방의 생성자가 된다
			chatRoom.setwNum(ws.getNum()); //workspace의 wNum을 채팅방정보에 담는다
			chatDao.insertChatRoom(chatRoom);//채팅방생성
			result = true;
		}
		return result;
		
	}
	public boolean modifyWorkspace(Workspace ws) {
		boolean result = false;
		if(wDao.updateWorkspace(ws)>0) {
			result = true;
		}
		return result;
	}
	public boolean removeWorkspace(int num) {
		boolean result = false;
		if(wDao.deleteWorkspace(num)>0) {
			result = true;
		}
		return result;
	}
	public Workspace getWorkspace(int num) {
		return wDao.selectWorkspace(num);
	}
	public List<Workspace> getAllWorkspace(){
		return wDao.selectAllWorkspace();
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
