package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import model.ChatMessage;

public interface ChatMessageDao {
	//cm = 메세지번호, cr = 채팅방번호
	public int insertChatMessage(ChatMessage chatMessage);
	public int deleteChatMessage(int cmNum); //메시지번호로 메시지삭제
	public ChatMessage selectChatMessageByCmNum(int cmNum);//메시지번호로 메시지 한개 선택
	public ChatMessage selectSystemMessageByCmNum(int cmNum);//
	public List<ChatMessage> selectAllChatMessageByCrNum(int crNum,int mNum);//채팅방번호로 해당채팅방의 전체메시지 선택
	public List<ChatMessage> selectRecentChatMessageByCrNum(int crNum, int mNum); //채팅방번호로 최근 30개 메시지 가져오기
	public List<ChatMessage> selectMoreChatMessageByCrNum(int crNum, int mNum, int count);//다음 30개 메시지 더 가져오기
	
	//검색과 페이징을 위한 ...
	public List<ChatMessage> searchChatMessage(Map<String, Object> param);
	public List<ChatMessage> selectChatMessage(@Param("first")int first,@Param("end")int end);
	public int selectSearchedCmCount(Map<String, Object> param);
	
	//favorite 추가, 삭제, 조회
	public int insertFavorite(int mNum,int cmNum);
	public int deleteFavorite(int cmNum);
	public List<ChatMessage> selectChatFavoriteList(int crNum, int mNum);
	public int deleteFavoriteByMnum(int mNum);
}
