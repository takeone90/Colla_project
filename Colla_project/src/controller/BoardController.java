package controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import model.Board;
import service.BoardService;

@Controller
public class BoardController {
	
	@Autowired
	private BoardService bService;
	
	@RequestMapping("/boardList")
	public String boardList(HttpSession session) {
		int wNum = (int)session.getAttribute("currWnum");
		
		List<Board> bList = bService.getAllBoardByWnum(wNum);
		
		return "/board/boardList";
	}
}
