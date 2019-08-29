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
	public String showBoardList(
			HttpSession session, 
			Model model
			) {
		int wNum = (int)session.getAttribute("currWnum");
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
			String mode,
			HttpSession session
			) {
		String view = "redirect:error";
		if(bService.getBoardByBnum(bNum)!=null) {
			Board board = bService.getBoardByBnum(bNum);
			if(board.getbPw().equals(pw)) {
				//비밀번호 일치
				session.setAttribute("pwConfirmedBnum", bNum);
				if(mode.equals("modify")) {
					model.addAttribute("bNum", bNum);
					view = "redirect:modify";
				} else if(mode.equals("delete")) {
					if(bService.removeBoard(bNum)) {
						view = "redirect:list";
					}
				}
			} else {
				//비밀번호 불일치
				model.addAttribute("bNum", bNum);
				model.addAttribute("mode", mode);
				view = "redirect:checkPass?msg=false";
			}
		}
		return view;
	}

	@RequestMapping(value="/modify", method = RequestMethod.GET)
	public String showModifyForm(HttpSession session, Model model, int bNum) {
		if(session.getAttribute("pwConfirmedBnum") != null && (int)session.getAttribute("pwConfirmedBnum")==bNum) {
			model.addAttribute("board", bService.getBoardByBnum(bNum));
			
			session.removeAttribute("pwConfirmedBnum");
			return "/board/boardModifyForm";
		} else {
			return "redirect:error";
		}
	}

	@RequestMapping(value="/modify", method = RequestMethod.POST)
	public String modifyBoard(
			int bNum,
			String title,
			String content,
			String boardType
			) {
		Board board = new Board();
		board.setbNum(bNum);
		board.setbContent(content);
		board.setbTitle(title);
		board.setbType(boardType);
		
		if(bService.modifyBoard(board)) {
			return "redirect:/board/view?num="+bNum;
		}
		return "redirect:error";
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
		int wNum = (int)session.getAttribute("currWnum");
		if(boardType.equals("anonymous") || boardType.equals("default") || boardType.equals("notice")) {
			String usermail = principal.getName();
			int mNum = mService.getMemberByEmail(usermail).getNum();
			Board board = new Board();
			board.setbTitle(title);
			board.setmNum(mNum);
			board.setwNum(wNum);
			board.setbContent(content);
			board.setbPw(pw);
			board.setbType(boardType);
			
			if(bService.addBoard(board)) {
				return "redirect:/board/view?num="+board.getbNum();
			}
		}else {
			//타입 설정 오류
			return "redirct:error";
		}
		return "redirect:/board/list";
	}
}
