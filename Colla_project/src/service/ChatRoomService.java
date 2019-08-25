package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.ChatRoomDao;
import model.ChatRoom;

@Service
public class ChatRoomService {
	@Autowired
	private ChatRoomDao crDao;
	public boolean addChatRoom(int wNum,int mNum,String crName) {
		boolean result = false;
		ChatRoom chatRoom = new ChatRoom();
		chatRoom.setCrName(crName);
		chatRoom.setmNum(mNum);
		chatRoom.setwNum(wNum);
		if(crDao.insertChatRoom(chatRoom)>0	) {
			result = true;
		}
		return result;
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
	public ChatRoom getChatRoomByCrNum(int crNum) {
		return crDao.selectChatRoom(crNum);
	}
	public ChatRoom getChatRoomByMnum(int mNum) {
		return crDao.selectChatRoomByMnum(mNum);
	} 
	public List<ChatRoom> getAllChatRoom(){
		return crDao.selectAll();
	}
	public List<ChatRoom> getAllChatRoomByWnum(int wNum){
		return crDao.selectAllByWnum(wNum);
	}
}
