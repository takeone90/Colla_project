package service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.BoardDao;
import model.Board;

@Service
public class BoardService {
	
	private static final int ITEMS_PER_PAGE = 13;
	private static final int PAGE_NUM = 5;
	
	@Autowired
	private BoardDao bDao;
	
	public List<Board> getAllBoardByWnum(int wNum) {
		return bDao.selectAllBoardByWnum(wNum);
	}
	
	public List<Board> getBoardListPage(Map<String,Object> param){
		List<Board> bList = null;
		int page = (Integer) param.get("page");
		int type = (Integer) param.get("type");
		String keyword = (String)param.get("keyword");
		
		if (type == 1) {
			param.put("title", keyword);
		} else if (type == 2) {
			param.put("content", keyword);
		} else if (type == 3) {
			param.put("title", keyword);
			param.put("content", keyword);
		} else if (type == 4) {
			param.put("name", keyword);
		}
		param.put("firstItem", getFirstItem(page));
		param.put("lastItem", getLastItem(page));
		param.put("startNum", getStartNum(page));
		param.put("endNum", getEndNum(page));
		param.put("totalPage", getTotalPage(param));
		param.put("lastStartNum", (((int) param.get("totalPage") - 1) / PAGE_NUM) * PAGE_NUM + 1);
		bList = bDao.selectBoardListPage(param);
		return bList;
	}
	public boolean addBoard(Board board) {
		return bDao.insertBoard(board)>0?true:false;
	}
	public boolean modifyBoard(Board board) {
		return bDao.updateBoard(board)>0?true:false;
	}
	public boolean removeBoard(int bNum) {
		return bDao.deleteBoard(bNum)>0?true:false;
	}
	public Board getBoardByBnum(int bNum) {
		return bDao.selectBoardBybNum(bNum);
	}
	public boolean readCntUp(int bNum) {
		return bDao.updateReadCnt(bNum)>0? true:false;
	}
	
////////////////////////////////////////////////////////////////////////////
	
	public int getFirstItem(int page) {
		return (page * ITEMS_PER_PAGE) -  (ITEMS_PER_PAGE - 1);
	}

	public int getLastItem(int page) {
		return (page * ITEMS_PER_PAGE);
	}

	public int getStartNum(int page) {
		return ((page - 1) / PAGE_NUM) * PAGE_NUM + 1;
	}

	public int getEndNum(int page) {
		return ((page - 1) / PAGE_NUM) * PAGE_NUM + PAGE_NUM;
	}

	public int getTotalPage(Map<String, Object> param) {
		int notice = getNoticeCnt(param);
		param.put("boardCnt", getBoardCnt(param));
		int totalPage= (int)Math.ceil(getBoardCnt(param)/ ((double) ITEMS_PER_PAGE - notice));
		return totalPage<=0?1:totalPage;
	}
	public int getNoticeCnt(Map<String, Object> param) {
		int notice = bDao.selectCountNoticeByWnum(param);
		return notice > 10? 10: notice;
	}
	public int getBoardCnt(Map<String, Object> param) {		
		return bDao.selectCountAllByWnum(param);
	}
}
