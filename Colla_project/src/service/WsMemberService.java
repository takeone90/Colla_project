package service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.ChatRoomDao;
import dao.ChatRoomMemberDao;
import dao.WsMemberDao;
import model.ChatRoom;
import model.ChatRoomMember;
import model.Workspace;
import model.WsMember;

@Service
public class WsMemberService {
	@Autowired
	private WsMemberDao dao;
	@Autowired
	private ChatRoomMemberDao crmDao;
	@Autowired
	private ChatRoomDao crDao;
	public boolean addWsMember(int wNum,int mNum) {
		boolean result = false;
		WsMember wsMember = new WsMember();
		wsMember.setmNum(mNum);
		wsMember.setwNum(wNum);
		
		if(dao.insertWsMember(wsMember)>0) {
			//워크스페이스에 멤버가 들어오면 기본채팅방에서 해당 멤버를 담아줘야한다.
			//wNum으로 cr_isdefault가 1인 chatroom을 선택하고 그 chatroom의 cr_num을 가져와야한다.
			ChatRoom cr = crDao.selectDefaultChatRoomByWnum(wNum);
			ChatRoomMember crm = new ChatRoomMember();
			crm.setCrNum(cr.getCrNum());
			crm.setmNum(mNum);
			crm.setwNum(wNum);
			crmDao.insertChatRoomMember(crm);
			
			result = true;
		}
		return result; 
	}
	public boolean removeWsMember(int wNum,int mNum) {
		boolean result = false;
		if(dao.deleteWsMember(wNum, mNum)>0) {
			result = true;
		}
		return result;
	}
	public boolean removeAllWsMemberByMnum(int mNum) {
		boolean result = false;
		if(dao.deleteAllWsMemberByMnum(mNum)>0) {
			result = true;
		}
		return result;
	}
	public WsMember getWsMember(int wNum,int mNum) {
		return dao.selectWsMember(wNum, mNum);
	}
	public List<Integer> getWnumByMnum(int mNum){
		return dao.selectAllWnumByMnum(mNum);
	}
	public List<Integer> getMnumByWnum(int wNum){
		return dao.selectAllMnumByWnum(wNum);
	}
	public List<WsMember> getAllWsMember(){
		return dao.selectAllWsMember();
	}
	public List<WsMember> getAllWsMemberByCrNum(int crNum){
		return dao.selectAllWsMemberByCrNum(crNum);
	}
	public List<WsMember> getAllWsMemberByWnum(int wNum){
		return dao.selectAllWsMemberByWnum(wNum);
	}
	
}
