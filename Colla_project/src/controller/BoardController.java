package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import model.Board;
import model.Member;
import service.BoardService;
import service.MemberService;

@Controller
public class BoardController {
	@Autowired
	private BoardService bService;
	
	@Autowired
	private MemberService mService;
	
	@RequestMapping("/boardList")
	public String showBoardList(Model model) {
		model.addAttribute("bList", bService.selectAll());
		return "boardList";
	}
	@RequestMapping("/boardView")
	public String showBoardView(int num,Model model) {
		Board board = bService.selectBoard(num);
		model.addAttribute("board", board);
		Member m = mService.selectMemberByNum( board.getmNum() );
		model.addAttribute("writer", m.getmName());
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
