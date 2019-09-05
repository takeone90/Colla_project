package service;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.Part;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import dao.ChatMessageDao;
import model.ChatMessage;
import model.Member;

@Service
public class ChatMessageService {
	private static final String PATH = "c:\\temp\\";
	@Autowired
	private ChatMessageDao cmDao;
	public int addChatMessage(int crNum,int mNum,String cmContent,String cmType) {
		ChatMessage chatMessage = new ChatMessage();
		chatMessage.setCrNum(crNum);
		chatMessage.setCmContent(cmContent);
		chatMessage.setmNum(mNum);
		chatMessage.setCmType(cmType);
		int cmNum = 0;
		if(cmDao.insertChatMessage(chatMessage)>0) {
			cmNum = chatMessage.getCmNum();
		}
		return cmNum;
	}
	public String addFile(MultipartHttpServletRequest request,Member member) throws IOException, ServletException {
		
		String saveName = "";
		Collection<Part> parts = request.getParts();
		for(Part part : parts) {
			String content = part.getHeader("content-Disposition");
			if(content.contains("filename=")) {
				UUID uuid = UUID.randomUUID();
				String fileName = part.getSubmittedFileName();
				saveName = uuid.toString()+"_"+fileName;
				if(part.getSize()>0) {
					part.write("c:\\temp\\"+saveName);
//					System.out.println("파일 저장 완료");
				}
			}
			
		}
		return saveName;
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
	public List<ChatMessage> getAllChatMessageByCrNum(int crNum,int mNum){
		
		return cmDao.selectAllChatMessageByCrNum(crNum,mNum);
	}
	
	public int modifyChatFavorite(int favoriteResult, int mNum, int cmNum) {
		if(favoriteResult==1) {
			return cmDao.insertFavorite(mNum, cmNum);
		}else {
			return cmDao.deleteFavorite(cmNum);
		}
	}
	
	public List<ChatMessage> getChatFavoriteList(int crNum, int mNum){
		return cmDao.selectChatFavoriteList(crNum, mNum);
	}
}
