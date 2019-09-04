package dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.junit.runners.Parameterized.Parameters;

import model.ChatRoom;
import model.ChatRoomMember;

public interface ChatRoomMemberDao {
	//crmNum = 채팅방+멤버 번호, crNum = 채팅방번호, mNum = 멤버번호
	public int insertChatRoomMember(ChatRoomMember chatRoomMember);
	public int updateChatRoomMember(ChatRoomMember chatRoomMember);
	public int deleteChatRoomMember(int crmNum);
	public int deleteChatRoomMemberByWnumMnum(@Param("wNum")int wNum,@Param("mNum")int mNum);
	public int deleteChatRoomMemberByCrNumMnum(@Param("crNum")int crNum,@Param("mNum")int mNum);
	public ChatRoomMember selectChatRoomMember(int crmNum);
	public ChatRoomMember selectChatRoomMemberByCrNumMnum(@Param("crNum")int crNum,@Param("mNum")int mNum);
	public ChatRoomMember selectChatRoomMemberByAnother(@Param("crNum")int crNum,@Param("wNum")int wNum,@Param("mNum")int mNum);
	public List<ChatRoomMember> selectAllChatRoomMember();
	public List<ChatRoomMember> selectAllChatRoomMemberByCrNum(int crNum);
	public List<ChatRoomMember> selectAllChatRoomMemberBywNum(int wNum);
}
