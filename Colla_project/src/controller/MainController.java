package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.View;

import service.FileService;

@Controller
public class MainController {
	
	@Autowired
	private FileService fService;
	
	@RequestMapping("/main")
	public String main() {
		return "/main/main";
	}
	@RequestMapping("/error")
	public String error() {
		return "/error/error";
	}
	@RequestMapping("/download")
	public View download(String name) {
		return fService.getDownload(name);
	}
}
