package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.BoardDao;
import model.Board;

@Service
public class BoardService {
	
	@Autowired
	private BoardDao bDao;
	
	public List<Board> getAllBoardByWnum(int wNum) {
		for( Board b : bDao.selectAllBoardByWnum(wNum)) {
//			if(b.getbType()) {
//				
//			}
		}
		return bDao.selectAllBoardByWnum(wNum);
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
}
