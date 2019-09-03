package controller;

import java.io.File;
import java.io.IOException;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.View;

import model.Board;
import model.BoardFile;
import service.BoardService;
import service.FileService;
import service.MemberService;

@Controller
@RequestMapping("/board")
public class BoardController {

	private static final String UPLOAD_PATH = "c:\\temp\\";
	
	@Autowired
	private BoardService bService;
	
	@Autowired
	private FileService fService;
	
	@Autowired
	private MemberService mService;
	
	@RequestMapping("/list")
	public String showBoardList(
			HttpSession session, 
			Model model,
			@RequestParam(value="page", defaultValue = "1") int page,
			@RequestParam(value="keywordType", defaultValue = "0") int type,
			@RequestParam(value="keyword", required = false) String keyword
			) {
		int wNum = (int)session.getAttribute("currWnum");
		Map<String, Object> param = new HashMap<String, Object>();
		
		if(page<=0) {
			page=1;
		}
		param.put("wNum", wNum);
		param.put("page", page);
		param.put("type",type);
		param.put("keyword",keyword);
		
		List<Board> bList = bService.getBoardListPage(param);
		model.addAttribute("bList", bList);
		model.addAttribute("listInf", param);
		session.setAttribute("listInf", param);
		return "/board/boardList";
	}
	
	@RequestMapping("/view")
	public String showBoardView(
			HttpSession session, 
			Model model,
			int num
			) {
		bService.readCntUp(num);
		Board board = bService.getBoardByBnum(num);
//		Board board = bService.getBoardByBnumWithFile(num);
		List<BoardFile> fList = fService.getFilesByBnum(num);
		System.out.println(fList);
		model.addAttribute("board", board);
		model.addAttribute("fList", fList);
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
			String content,
			MultipartHttpServletRequest multifileReq
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
				////////////////////////////////////////// 190902 multifile upload -TK
				
				List<MultipartFile> fList = multifileReq.getFiles("file");
				String src = multifileReq.getParameter("src");
				System.out.println("src value : "+src);
				
				for(MultipartFile mf : fList) {
					String originFileName = mf.getOriginalFilename();//원본파일명
					long fileSize = mf.getSize(); //파일사이즈
					System.out.println("originFileName : " + originFileName);
					System.out.println("fileSize : " + fileSize);
					UUID uuid = UUID.randomUUID();
					
					//시스템시간(ms) + uuid + 원본파일명
					String saveFileName = "" + System.currentTimeMillis() + uuid +"_"+ originFileName;
					String saveFile = UPLOAD_PATH + saveFileName;
					
					try {
						//서버(path)에 저장
						mf.transferTo(new File(saveFile));
						
						//DB에 게시판번호, 이름 저장
						BoardFile bf = new BoardFile();
						bf.setbNum(board.getbNum());
						bf.setFileName(saveFileName);						
						fService.addFiles(bf);
						
					} catch(IllegalStateException e) {
						e.printStackTrace();
					} catch(IOException e) {
						e.printStackTrace();
					}
				}			
				/////////////////////////////////////////////
				
				return "redirect:/board/view?num="+board.getbNum();
			}
		}else {
			//타입 설정 오류
			return "redirct:error";
		}
		return "redirect:/board/list";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
