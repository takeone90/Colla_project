package controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import service.PaymentService;

@Controller
@RequestMapping("/payment")
public class PaymentController {

//	
//	@RequestMapping("/")
//	public String showPaymentPage() {
//		return "/main/payment";
//	}
	
	@Autowired
	private PaymentService pService;
	
	@RequestMapping(value="/kakaoPay" ,method = RequestMethod.GET)
	public String kakaoPayGet() {
		return "/main/payment";
	}
	
	@RequestMapping(value="/kakaoPay" ,method = RequestMethod.POST)
	public String kakaoPay(HttpServletRequest req) {
		return "redirect:"+ pService.kakaoPayReady();
	}
	
	@RequestMapping("/kakaoPaySuccess")
	public String kakaoPaySuccess(@RequestParam("pg_token") String pg_token, Model model) {
		System.out.println("kakaoPay Success, pg_token : " + pg_token);
		model.addAttribute("info", pService.kakaoPayInfo(pg_token));
		return "/main/loading";
	}
}
