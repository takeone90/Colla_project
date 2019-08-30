package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.ChatMessageDao;
import model.ChatMessage;

@Service
public class ChatMessageService {
	@Autowired
	private ChatMessageDao cmDao;
	public int addChatMessage(int crNum,int mNum,String cmContent) {
//		boolean result = false;
		ChatMessage chatMessage = new ChatMessage();
		chatMessage.setCrNum(crNum);
		chatMessage.setCmContent(cmContent);
		chatMessage.setmNum(mNum);
		int cmNum = 0;
		if(cmDao.insertChatMessage(chatMessage)>0) {
			cmNum = chatMessage.getCmNum();
//			result = true;
		}
		return cmNum;
	}
	public boolean removeChatMessage(int cmNum) {
		boolean result = false;
		if(cmDao.deleteChatMessage(cmNum)>0) {
			result = true;
		}
		return result;
	}
	public ChatMessage getChatMessageByCmNum(int cmNum) {
		return cmDao.selectChatMessageByCmNum(cmNum);
	}
	public List<ChatMessage> getAllChatMessageByCrNum(int crNum){
		return cmDao.selectAllChatMessageByCrNum(crNum);
	}
}
