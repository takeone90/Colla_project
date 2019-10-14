
package service;

import java.net.URI;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.format.DataFormatDetector;

import dao.PaymentDao;
import model.License;
import model.Payment;
import model.kakaoPay.KakaoPayApprovalVO;
import model.kakaoPay.KakaoPayReadyVO;

@Service
public class PaymentService {

	@Autowired
	private PaymentDao paymentDao;

	private static final String HOST = "https://kapi.kakao.com";
	private static final String COLLAPATH = "http://c0lla.com";

	private KakaoPayReadyVO kakaoPayReadyVO;
	private KakaoPayApprovalVO kakaoPayApprovalVO;
	private String orderId;

	public String kakaoPayReady(License license) {
		RestTemplate restTemplate = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "KakaoAK " + "f949333bd4f54ee3ee8399ec5697c014");
		headers.add("Accept", MediaType.APPLICATION_JSON_UTF8_VALUE);
		headers.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE);
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		orderId = dateFormat.format(new Date()) + getRandomNumber();
		MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
		params.add("cid", "TC0ONETIME");
		params.add("partner_order_id", orderId);
		params.add("partner_user_id", "admin");
		params.add("item_name", "[COLLA]" + license.getType());
		params.add("quantity", "1");
		params.add("total_amount", Integer.toString(license.getAmount()));
		params.add("tax_free_amount", "0");
		params.add("approval_url", COLLAPATH + "/payment/kakaoPaySuccess");
		params.add("cancel_url", COLLAPATH + "/payment/kakaoPay?msg=cancel");
		params.add("fail_url", COLLAPATH + "/payment/kakaoPay?msg=fail");

		HttpEntity<MultiValueMap<String, String>> body = new HttpEntity<MultiValueMap<String, String>>(params, headers);

		try {
			kakaoPayReadyVO = restTemplate.postForObject(new URI(HOST + "/v1/payment/ready"), body,
					KakaoPayReadyVO.class);

			return kakaoPayReadyVO.getNext_redirect_pc_url();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return "/WTF_ERROR";
	}

	public KakaoPayApprovalVO kakaoPayInfo(String pg_token, License license) {
		System.out.println("KakaoPayInfoVO................................................");
		RestTemplate restTemplate = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "KakaoAK " + "f949333bd4f54ee3ee8399ec5697c014");
		headers.add("Accept", MediaType.APPLICATION_JSON_UTF8_VALUE);
		headers.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charset=UTF-8");

		MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
		params.add("cid", "TC0ONETIME");
		params.add("tid", kakaoPayReadyVO.getTid());
		params.add("partner_order_id", orderId);
		params.add("partner_user_id", "admin");
		params.add("pg_token", pg_token);
		params.add("total_amount", Integer.toString(license.getAmount()));

		HttpEntity<MultiValueMap<String, String>> body = new HttpEntity<MultiValueMap<String, String>>(params, headers);

		try {
			kakaoPayApprovalVO = restTemplate.postForObject(new URI(HOST + "/v1/payment/approve"), body,
					KakaoPayApprovalVO.class);
			System.out.println("kakaoPayApprovalVO : " + kakaoPayApprovalVO);
			return kakaoPayApprovalVO;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public boolean addPaymentInfo(Payment payment) {
		if (paymentDao.insertPayment(payment) > 0) {
			return true;
		}
		return false;
	}

	public String getRandomNumber() {
		Random random = new Random(System.currentTimeMillis());
		int numberLength = 7;
		int range = (int) Math.pow(10, numberLength);
		int trim = (int) Math.pow(10, numberLength - 1);
		int result = random.nextInt(range) + trim;
		if (result > range) {
			result = result - trim;
		}
		return String.valueOf(result);
	}

}