package dao;

import java.util.List;

import model.Board;

public interface BoardDao {
	public int insertBoard(Board board);
	public int updateBoard(Board board);
	public int deleteBoard(int num);
	public Board selectOneBoard(int num);
	public List<Board> selectAllBoard();
}
