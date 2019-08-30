package controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import model.Member;
import model.Reply;
import service.ReplyService;

@RestController
@RequestMapping("/reply")
public class ReplyController {
	
	@Autowired
	private ReplyService rService;
	
	@RequestMapping("/all/{bNum}")
	public List<Reply> getReplyByBnum(@PathVariable int bNum) {
		List<Reply> rList = rService.getReplyByBnum(bNum);
		return rList;
	}
	@RequestMapping(value = "/remove/{rNum}", method = RequestMethod.POST, produces = "application/text;charset=UTF-8")
	public String removeReply(@PathVariable int rNum, HttpSession session) {
		String result = "DB 오류 발생";
		if(rService.removeReply(rNum)) {
			result = "댓글이 삭제되었습니다.";
		}
		return result;
	}
	@RequestMapping(value = "/modify/{rNum}", method = RequestMethod.POST, produces = "application/text;charset=UTF-8")
	public String modifyReply(@PathVariable int rNum, HttpSession session, String rContent) {
		String result = "DB 오류 발생";
		Reply r = new Reply();
		r.setrNum(rNum);
		r.setContent(rContent);
		if(rService.modifyReply(r)) {
			result = "댓글이 수정되었습니다.";
		}
		return result;
	}
	@RequestMapping(value = "/add/{bNum}", method = RequestMethod.POST, produces = "application/text;charset=UTF-8")
	public String addReply(@PathVariable int bNum, HttpSession session, String rContent) {
		String result = "DB 오류 발생";
		Member user = (Member)session.getAttribute("user");
		int mNum = user.getNum();
		Reply r = new Reply();
		r.setbNum(bNum);
		r.setmNum(mNum);
		r.setContent(rContent);
		if(rService.addReply(r)) {
			result = "댓글이 추가되었습니다.";
		}
		return result;
	}
}
