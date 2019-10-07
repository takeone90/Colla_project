package dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import model.ChatRoom;
import model.Workspace;

public interface ChatRoomDao {
	public int insertChatRoom(ChatRoom chatRoom);
	public int updateChatRoom(ChatRoom chatRoom);//채팅방 이름만 바뀌게
	public int deleteChatRoom(int crNum);
	public int deleteEmptyChatRoom();//비어있는 채팅방 삭제
	public int deleteAllChatRoomByWnum(int wNum);
	public ChatRoom selectChatRoom(int crNum);//채팅방번호로 조회
	public ChatRoom selectChatRoomByMnum(int mNum); //채팅방생성자 번호로 조회
	public ChatRoom selectDefaultChatRoomByWnum(int wNum); //wNum을 받아서 그 workspace의 기본채팅방을 조회
	public List<ChatRoom> selectAll();//모든 채팅방조회
	public List<ChatRoom> selectAllByWnum(int wNum);//워크스페이스 번호로 해당워크스페이스의 채팅방조회
	public List<ChatRoom> selectAllChatRoomByWnumMnum(@Param("wNum")int wNum,@Param("mNum")int mNum);
}
