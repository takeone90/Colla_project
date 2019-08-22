package controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WorkSpaceController {
	@RequestMapping("/workspace")
	public String showWsMain() {
		return "/workspace/wsMain";
	}
	@RequestMapping("/chatMain")
	public String chatMain() {
		return "/chatting/chatMain";
	}
}
