package controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import service.BoardService;

@Controller
public class BoardController {
	private BoardService service;
	@RequestMapping("/boardList")
	public String main(Model model) {
		return "boardList";
	}
}
