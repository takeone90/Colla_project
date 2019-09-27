
package service;

import java.net.URI;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import model.License;
import model.kakaoPay.KakaoPayApprovalVO;
import model.kakaoPay.KakaoPayReadyVO;

@Service
public class PaymentService {

	private static final String HOST = "https://kapi.kakao.com";
	private static final String COLLAPATH = "http://localhost:8081/Colla_project";

	private KakaoPayReadyVO kakaoPayReadyVO;
	private KakaoPayApprovalVO kakaoPayApprovalVO;

	public String kakaoPayReady(License license) {
		RestTemplate restTemplate = new RestTemplate();

		HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "KakaoAK " + "f949333bd4f54ee3ee8399ec5697c014");
		headers.add("Accept", MediaType.APPLICATION_JSON_UTF8_VALUE);
		headers.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE);

		MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
		params.add("cid", "TC0ONETIME");
		params.add("partner_order_id", "1001");
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

	public KakaoPayApprovalVO kakaoPayInfo(String pg_token) {
		System.out.println("KakaoPayInfoVO................................................");

		RestTemplate restTemplate = new RestTemplate();

		HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "KakaoAK " + "f949333bd4f54ee3ee8399ec5697c014");
		headers.add("Accept", MediaType.APPLICATION_JSON_UTF8_VALUE);
		headers.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charset=UTF-8");

		MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
		params.add("cid", "TC0ONETIME");
		params.add("tid", kakaoPayReadyVO.getTid());
		params.add("partner_order_id", "1001");
		params.add("partner_user_id", "admin");
		params.add("pg_token", pg_token);
		params.add("total_amount", "10000");

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

}