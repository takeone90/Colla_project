package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import model.Board;
import service.BoardService;

@Controller
public class BoardController {
	@Autowired
	private BoardService service;
	
	@RequestMapping("/boardList")
	public String showBoardList(Model model) {
		model.addAttribute("bList", service.selectAll());
		return "boardList";
	}
	@RequestMapping("/boardView")
	public String showBoardView(int num,Model model) {
		Board board = service.selectBoard(num);
		model.addAttribute("board", board);
		return "boardView";
	}
	@RequestMapping("/boardWriteForm")
	public String showBoardWriteForm() {
		return "boardWriteForm";
	}
	
	@RequestMapping("/boardModifyForm")
	public String showBoardModifyForm() {
		return "boardModifyForm";
	}
}
