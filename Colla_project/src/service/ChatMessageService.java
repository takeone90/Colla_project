package service;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
	
	
	
	/////////////////////////////////메세지 검색///////////////////////////////////////////
	private final static int NUM_OF_BOARD_PER_PAGE = 5;
	private final static int NUM_OF_NAVI_PAGE = 3;

	public Map<String, Object> getSearchChatMessageList(Map<String, Object> param){
		Map<String, Object> result = new HashMap<String, Object>();
		int type = (Integer)param.get("type");
		int page = (Integer)param.get("page");
		String keyword = (String)param.get("keyword");
		int crNum = (Integer)param.get("crNum");
		param.put("firstRow", getStartRow(page));
		param.put("endRow", getEndRow(page));
		param.put("crNum", crNum);
		if(type==1) {
			param.put("content", keyword);
		}else if(type==2) {
			param.put("name", keyword);
		}
		//ex) type=1이면 firstRow,endRow,crNum,name 을 담은 param을 보낸다
		result = getPageData(param);
		List<ChatMessage> searchedCmList = cmDao.searchChatMessage(param);
//		System.out.println("[검색결과 || "+searchedCmList+"]");
		result.put("searchedCmList", searchedCmList);
		return result;
	}
	

	// 페이지 번호 기준으로 게시글 목록 가져오기
	public List<ChatMessage> getMessagePage(int pageNumber) {
		int firstRow = getStartRow(pageNumber);
		int endRow = getEndRow(pageNumber);
		return cmDao.selectChatMessage(firstRow, endRow);
	}

	public int getStartRow(int pageNumber) { // 페이지 당 게시글 수 * 현재페이지
		return (pageNumber) * NUM_OF_BOARD_PER_PAGE - (NUM_OF_BOARD_PER_PAGE - 1);
	}

	public int getEndRow(int pageNumber) {
		return pageNumber * NUM_OF_BOARD_PER_PAGE;
	}

	private int getStartPage(int pageNumber) {
		int result = ((pageNumber - 1) / NUM_OF_NAVI_PAGE) * NUM_OF_NAVI_PAGE + 1;
		return result;
	}

	private int getEndPage(int pageNumber) {
		return getStartPage(pageNumber) + (NUM_OF_NAVI_PAGE - 1);
	}

	private int getTotalPage(Map<String, Object> param) {
		int totalCount = cmDao.selectSearchedCmCount(param);
		return (int) Math.ceil((totalCount / (double) NUM_OF_BOARD_PER_PAGE));
	}
	public Map<String, Object> getPageData(Map<String, Object> param){
		Map<String, Object> result = new HashMap<String, Object>();
		int page = (Integer)param.get("page");
		result.put("startPage", getStartPage(page));
		result.put("endPage", getEndPage(page));
		result.put("totalPage", getTotalPage(param));
		return result;
	}
	
}
