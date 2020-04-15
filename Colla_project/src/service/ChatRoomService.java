package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dao.AlarmDao;
import dao.ChatRoomDao;
import dao.ChatRoomMemberDao;
import model.Alarm;
import model.ChatRoom;
import model.ChatRoomMember;
import model.Member;

@Service
public class ChatRoomService {
	@Autowired
	private ChatRoomDao crDao;
	@Autowired
	private ChatRoomMemberDao crmDao;
	@Autowired
	private AlarmDao aDao;
	
	//1:1채팅 생성 및 초대
	@Transactional
	public Alarm addOneOnOne(int wNum, Member I, Member you) {
		int crNum = addChatRoom(wNum, I.getNum(), I.getName()+"-"+you.getName());
		ChatRoomMember crm = new ChatRoomMember();
		Alarm alarm = null;
		
		crm.setCrNum(crNum);
		crm.setmNum(you.getNum());
		crm.setwNum(wNum);
		if(crmDao.insertChatRoomMember(crm)>0) {
			alarm = new Alarm();
			alarm.setaDnum(crNum);
			alarm.setaType("cInvite");
			alarm.setmNumTo(you.getNum());
			alarm.setmNumFrom(I.getNum());
			alarm.setwNum(wNum);
			aDao.insertAlarm(alarm);
		}
		return alarm;
	}
	public int addChatRoom(int wNum,int mNum,String crName) {
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
