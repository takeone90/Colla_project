package dao;

import java.util.List;

import model.Board;

public interface BoardDao {
	public List<Board> selectAllBoardByWnum(int wNum);
	public int insertDefaultBoard(Board board);
	public Board selectBoardBybNum(int bNum);
}
