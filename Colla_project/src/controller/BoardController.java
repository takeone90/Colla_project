package controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import service.BoardService;

@Controller
public class BoardController {
	private BoardService service;
	
	@RequestMapping("/boardList")
	public String showBoardList(Model model) {
		return "boardList";
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
