package dao;

import java.util.List;

import model.ChatRoom;
import model.ChatRoomMember;

public interface ChatRoomMemberDao {
	//crmNum = 채팅방+멤버 번호, crNum = 채팅방번호, mNum = 멤버번호
	public int insertChatRoomMember(ChatRoomMember chatRoomMember);
	public int updateChatRoomMember(ChatRoomMember chatRoomMember);
	public int deleteChatRoomMember(int crmNum);
	public ChatRoomMember selectChatRoomMember(int crmNum);
	public List<ChatRoomMember> selectAllChatRoomMember();
	public List<ChatRoomMember> selectAllChatRoomMemberByCrNum(int crNum);
}
