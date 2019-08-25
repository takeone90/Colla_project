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
		return bDao.selectAllBoardByWnum(wNum);
	}
	
}
