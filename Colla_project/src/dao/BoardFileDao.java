package dao;

import java.util.List;

import model.BoardFile;

public interface BoardFileDao {
	public int insertFile(BoardFile file);
	public int deleteFile(int bNum);
	public List<BoardFile> selectFilesByBnum(int bNum);
}
