package controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import model.License;
import model.Member;
import service.LicenseService;
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
	@Autowired
	private LicenseService licenseService;
	private License license;
	
	@RequestMapping(value="/kakaoPay" ,method = RequestMethod.GET)
	public String kakaoPayGet(String type, HttpSession session, Model model) {
		Member member = (Member)session.getAttribute("user");
		int mNum = member.getNum();
		int amount = 0;
		if(type.equals("personal")){ //라이센스에 따른 금액을 셋팅한뒤
			amount = 10000;
		}else if(type.equals("business")){
			amount = 50000;
		}else if(type.equals("enterprise")){
			amount = 100000;
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("type", type);
		param.put("amount", amount);
		param.put("mNum", mNum);
		model.addAllAttributes(param);
		return "/main/payment";
	}
	
	@RequestMapping(value="/kakaoPay" ,method = RequestMethod.POST)
	public String kakaoPay(HttpServletRequest req, License license) {
		this.license = license;
		return "redirect:"+ pService.kakaoPayReady(license);
	}
	
	@RequestMapping("/kakaoPaySuccess")
	public String kakaoPaySuccess(@RequestParam("pg_token") String pg_token, Model model) {
		System.out.println("kakaoPay Success, pg_token : " + pg_token);
		licenseService.insertLicense(license);
		JSONObject json = new JSONObject(pService.kakaoPayInfo(pg_token));
		model.addAttribute("info", json);
		return "/main/kakaoPaySuccess";
	}
	
	@RequestMapping("/result")
	public String paymentResult() {
		return "/main/paymentResult";
	}
}
