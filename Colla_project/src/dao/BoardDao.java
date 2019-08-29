package dao;

import java.util.List;

import model.Board;

public interface BoardDao {
	public List<Board> selectAllBoardByWnum(int wNum);
	public int insertBoard(Board board);
	public int deleteBoard(int bNum);
	public int updateBoard(Board board);
	public Board selectBoardBybNum(int bNum);
}
