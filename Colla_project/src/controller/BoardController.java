package controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
		model.addAttribute("bList", bList);
		return "/board/boardList";
	}
	
	@RequestMapping("/view")
	public String showBoardView(
			HttpSession session, 
			Model model,
			int num
			) {
		Board board = bService.getBoardByBnum(num);
		model.addAttribute("board", board);
		return "/board/boardView";
	}

	@RequestMapping(value="/checkPass", method = RequestMethod.GET)
	public String showCheckPass(
			Model model,
			String mode,
			int bNum
			) {
		Map<String, Object> updateMap = new HashMap<String, Object>();
		if(mode.equals("modify") || mode.equals("delete")) {
			updateMap.put("mode", mode);
			updateMap.put("bNum", bNum);
			model.addAttribute("updateMap", updateMap);
			return "/board/boardCheckPass";
		} else {
			return "redirect:error";
		}
	}
	
	@RequestMapping(value="/checkPass", method = RequestMethod.POST)
	public String showUpdate(
			Model model,
			String pw,
			int bNum,
			String mode
			) {
		System.out.println("pw  : "+pw+", bNum : "+bNum );
		if(bService.getBoardByBnum(bNum)!=null) {
			Board board = bService.getBoardByBnum(bNum);
			if(board.getbPw().equals(pw)) {
				//비밀번호 일치
				return "redirect:"+mode;
			} else {
				//비밀번호 불일치
				System.out.println("글 암호 불일치....글번호:"+ bNum);
				model.addAttribute("bNum", bNum);
				model.addAttribute("mode", mode);
				return "redirect:checkPass?msg=false";
			}
		}else {
			return "redirect:error";
		}
	}

	@RequestMapping(value="/modify", method = RequestMethod.GET)
	public String showModifyForm() {
		return "/board/boardModifyForm";
	}

	@RequestMapping(value="/modify", method = RequestMethod.POST)
	public String modifyBoard() {
		return "/board/boardModifyForm";
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
//		int wNum = (int)session.getAttribute("currWnum");
		int wNum = 1;
		if(!boardType.equals("anonymous")) {
			String usermail = principal.getName();
			int mNum = mService.getMemberByEmail(usermail).getNum();
			Board board = new Board();
			board.setbTitle(title);
			board.setmNum(mNum);
			board.setwNum(wNum);
			board.setbContent(content);
			board.setbPw(pw);
			
			bService.addDefaultBoard(board);
		}
		return "redirect:/board/list";
	}
}
