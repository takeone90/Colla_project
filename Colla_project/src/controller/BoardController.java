package controller;

import java.security.Principal;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import model.Board;
import model.Member;
import service.BoardService;
import service.MemberService;

@Controller
@RequestMapping("/board")
public class BoardController {
	
	@Autowired
	private BoardService bService;
	
	@Autowired
	private MemberService mService;
	
	@RequestMapping("/list")
	public String showBoardList(HttpSession session, Model model) {
//		int wNum = (int)session.getAttribute("currWnum");
		int wNum = 1;
		List<Board> bList = bService.getAllBoardByWnum(wNum);
		System.out.println(bList);		
		model.addAttribute("bList", bList);
		return "/board/boardList";
	}

	
	@RequestMapping(value="/write", method = RequestMethod.GET)
	public String showWriteForm(HttpSession session, Model model) {
		return "/board/boardWriteForm";
	}
	
	@RequestMapping(value="/write", method = RequestMethod.POST)
	public String writeNewBoard(
			Principal principal,
			HttpSession session, 
			Model model,
			String boardType,
			String pw,
			String title,
			String content
			) {
		System.out.println("글쓰기요청");
//		int wNum = (int)session.getAttribute("currWnum");
		int wNum = 1;
		
		if(!boardType.equals("anonymous")) {
			String usermail = principal.getName();
			System.out.println(usermail);
			Member user = mService.getMemberByEmail(usermail);
			int mNum = user.getNum();
//			System.out.println(mNum);
			Board board = new Board();
			board.setbTitle(title);
			board.setmNum(mNum);
			board.setwNum(wNum);
			board.setbContent(content);
			
			bService.addDefaultBoard(board);
		}
		
		return "redirect:/board/list";
	}
}
