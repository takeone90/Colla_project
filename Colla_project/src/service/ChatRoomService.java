package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.ChatRoomDao;
import dao.ChatRoomMemberDao;
import model.ChatRoom;
import model.ChatRoomMember;

@Service
public class ChatRoomService {
	@Autowired
	private ChatRoomDao crDao;
	@Autowired
	private ChatRoomMemberDao crmDao;
	public int addChatRoom(int wNum,int mNum,String crName) {
//		boolean result = false;
		ChatRoom chatRoom = new ChatRoom();
		chatRoom.setCrName(crName);
		chatRoom.setmNum(mNum);
		chatRoom.setwNum(wNum);
		if(crDao.insertChatRoom(chatRoom)>0	) {
			//채팅방 내 해당 생성자를 추가시킨다
			ChatRoomMember crm = new ChatRoomMember();
			crm.setCrNum(chatRoom.getCrNum());
			crm.setmNum(mNum);
			crm.setwNum(wNum);
			crmDao.insertChatRoomMember(crm);//채팅방 멤버한명 생성(채팅방 생성자)
//			result = true;
		}
		return chatRoom.getCrNum();
	}
	public boolean modifyChatRoom(ChatRoom chatRoom) {
		boolean result = false;
		if(crDao.updateChatRoom(chatRoom)>0) {
			result = true;
		}
		return result;
	}
	public boolean removeChatRoom(int crNum) {
		boolean result = false;
		if(crDao.deleteChatRoom(crNum)>0) {
			result = true;
		}
		return result;
	}
	public boolean removeEmptyChatRoom() {
		boolean result = false;
		if(crDao.deleteEmptyChatRoom()>0) {
			result = true;
		}
		return result;
	}
	public boolean removeAllChatRoomByWnum(int wNum) {
		boolean result = false;
		if(crDao.deleteAllChatRoomByWnum(wNum)>0) {
			result =true;
		}
		return result;
	}
	public ChatRoom getChatRoomByCrNum(int crNum) {
		return crDao.selectChatRoom(crNum);
	}
	public ChatRoom getChatRoomByMnum(int mNum) {
		return crDao.selectChatRoomByMnum(mNum);
	} 
	public ChatRoom getDefaultChatRoomByWnum(int wNum) {
		return crDao.selectDefaultChatRoomByWnum(wNum);
	}
	public List<ChatRoom> getAllChatRoom(){
		return crDao.selectAll();
	}
	public List<ChatRoom> getAllChatRoomByWnum(int wNum){
		return crDao.selectAllByWnum(wNum);
	}
	public List<ChatRoom> getAllChatRoomByMnum(int mNum){
		return crDao.selectAllChatRoomByMnum(mNum);
	}
	public List<ChatRoom> getAllChatRoomByWnumMnum(int wNum,int mNum){
		return crDao.selectAllChatRoomByWnumMnum(wNum, mNum);
	}
}
