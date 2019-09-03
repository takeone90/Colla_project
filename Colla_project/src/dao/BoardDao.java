package dao;

import java.util.List;
import java.util.Map;

import model.Board;

public interface BoardDao {
	public List<Board> selectAllBoardByWnum(int wNum);
	public List<Board> selectBoardListPage(Map<String,Object>param);
	public int insertBoard(Board board);
	public int selectCountAllByWnum(int wNum);
	public int deleteBoard(int bNum);
	public int updateBoard(Board board);
	public Board selectBoardBybNum(int bNum);
//	public Board selectBoardBybNumWithFile(int bNum);
	public int updateReadCnt(int bNum);
}
