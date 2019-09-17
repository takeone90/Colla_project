package controller;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;

import java.io.IOException;
import java.security.Principal;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import model.Member;
import service.MemberService;
import test.test;

@Component
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

	@Autowired
	private MemberService memberService;
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
		String userEmail = request.getParameter("m_email"); //사용자에게 입력받은 이메일을 파라미터를
		if(request.getSession()!=null) {
			request.getSession().invalidate();
		}
		System.out.println(request.getSession());
		response.sendRedirect("checkLoginDuplication?userEmail="+userEmail); //checkLoginDuplication로 요청을 보냄(MemberContoroller)
		request.getSession().setAttribute("userEmail", userEmail);
		request.getSession().setAttribute("user", memberService.getMemberByEmail(userEmail));
		
			
	}
}
