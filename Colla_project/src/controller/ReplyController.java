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
	
	@RequestMapping(value = "/add/{bNum}", method = RequestMethod.POST, produces = "application/text;charset=UTF-8")
	public String addReply(@PathVariable int bNum, HttpSession session, String content) {
		Member user = (Member)session.getAttribute("user");
		int mNum = user.getNum();
		Reply r = new Reply();
		r.setbNum(bNum);
		r.setmNum(mNum);
		r.setContent(content);
		rService.addReply(r);
		
		return null;
	}
}
