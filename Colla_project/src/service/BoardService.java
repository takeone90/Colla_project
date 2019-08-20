package service;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.BoardDao;
import model.Board;

@Service
public class BoardService {
	@Autowired
	private BoardDao dao;
	
	public boolean addBoard(String title,String content,int mNum) {
		boolean result = false;
		Board board=  new Board();
		board.setContent(content);
		board.setmNum(mNum);
		board.setTitle(title);
		if(dao.insertBoard(board)>0) {
			result = true;
		}
		return result;
	}
	public boolean removeBoard(int num) {
		boolean result = false;
		if(dao.deleteBoard(num)>0) {
			result =true;
		}
		return result;
	}
	public boolean modifyBoard(Board board) {
		boolean result = false;
		if(dao.updateBoard(board)>0) {
			result = true;
		}
		return result;
	}
	public Board selectBoard(int num){
		return dao.selectOneBoard(num);
	}
	public List<Board> selectAll(){
		return dao.selectAllBoard();
	}
}
