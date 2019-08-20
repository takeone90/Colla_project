package service;


import java.util.List;

import org.springframework.stereotype.Service;

import model.Board;

@Service
public class BoardService {
	public boolean addBoard(String title,String content,int mNum) {
		boolean result = false;
		return result;
	}
	public boolean removeBoard(int num) {
		boolean result = false;
		return result;
	}
	public boolean modifyBoard(Board board) {
		boolean result = false;
		return result;
	}
	public Board selectBoard(int num){
		return null;
	}
	public List<Board> selectAll(){
		return null;
	}
}
