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
	@RequestMapping(value="/collaInfo")
	public String showColla() {
		return "/main/collaInfo";
	}
	@RequestMapping(value="/pricing")
	public String showPricing() {
		return "/main/pricing";
	}
	@RequestMapping(value="/faq")
	public String showFaq() {
		return "/main/faq";
	}
	@RequestMapping(value="/aboutUs")
	public String showAboutUs() {
		return "/main/aboutUs";
	}
}
