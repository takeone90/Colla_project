package dao;

import java.util.List;
import java.util.Map;

import model.Board;

public interface BoardDao {
	public List<Board> selectAllBoardByWnum(int wNum);
	public int insertBoard(Board board);
	public int deleteBoard(int bNum);
	public int updateBoard(Board board);
	public Board selectBoardBybNum(int bNum);
	public int updateReadCnt(int bNum);
	
	public List<Board> selectBoardListPage(Map<String,Object>param);
	public int selectCountAllByWnum(Map<String,Object>param);	
	public int selectCountNoticeByWnum(Map<String,Object>param);
}
