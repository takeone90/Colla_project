package controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
}
