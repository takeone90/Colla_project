package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import model.ChatMessage;
import model.Member;

@Service
public class SystemMsgService {
	@Autowired
	private ChatMessageService cmService;
	
	public ChatMessage joinChatRoom(int crNum, Member member) {
		int cmNum = cmService.addChatMessage(crNum, -1, member.getName() + " 님이 채팅에 참여하셨습니다.", "systemMsg");
		return cmService.getSystemMessageByCmNum(cmNum);
	}
	
	public ChatMessage exitChatRoom(int crNum, Member member) {
		int cmNum = cmService.addChatMessage(crNum, -1, member.getName() + " 님이 채팅에서 나가셨습니다.", "systemMsg");
		return cmService.getSystemMessageByCmNum(cmNum);
	}
}
