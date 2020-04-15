
package controller;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import model.Payment;
import model.kakaoPay.KakaoPayApprovalVO;
import service.LicenseService;
import service.PaymentService;

@Controller
@RequestMapping("/payment")
public class PaymentController {

	@Autowired
	private PaymentService pService;
	@Autowired
	private LicenseService licenseService;
	private License license;
	private Member member;
	
	@RequestMapping(value="/kakaoPay" ,method = RequestMethod.GET)
	public String kakaoPayGet(String type, HttpSession session, Model model) {
		member = (Member)session.getAttribute("user");
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
	public String kakaoPay(HttpServletRequest req, License license, Member member) {
		this.license = license;
		this.member = member;
		return "redirect:"+ pService.kakaoPayReady(license);
	}
	
	@RequestMapping("/kakaoPaySuccess")
	public String kakaoPaySuccess(@RequestParam("pg_token") String pg_token, Model model) {
		System.out.println("kakaoPay Success, pg_token : " + pg_token);
		KakaoPayApprovalVO payInfo = pService.kakaoPayInfo(pg_token,license);
		Date tmpDate = payInfo.getApproved_at();
		int hours = tmpDate.getHours()-9;
		tmpDate.setHours(hours);
		Payment payment = new Payment();
		payment.setAmount(payInfo.getAmount().getTotal());
		payment.setDate(tmpDate);
		payment.setItem(payInfo.getItem_name());
		payment.setName(member.getName());
		payment.setOrderId(payInfo.getPartner_order_id());	
		payment.setPaymentMethod("kakaoPay");
		payment.setPhone(member.getPhone());
		payment.setmNum(member.getNum());
		license.setOrderId(payInfo.getPartner_order_id());
		license.setmNum(member.getNum());
		licenseService.insertLicense(license);
		pService.addPaymentInfo(payment);
		JSONObject json = new JSONObject(payInfo);
		model.addAttribute("info", json);
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		String dateStr = dateFormat.format(payInfo.getApproved_at());
		model.addAttribute("DateStr", dateStr);
		return "/main/kakaoPaySuccess";
	}
	
	@RequestMapping("/result")
	public String paymentResult() {
		return "/main/paymentResult";
	}
}