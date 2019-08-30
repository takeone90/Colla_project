package controller;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;

import java.io.IOException;
import java.security.Principal;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import test.test;

@Component
public class LoginSuccessHandler implements AuthenticationSuccessHandler{
	Principal principal;
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		LoginManager loginManager = new LoginManager();
		boolean result = loginManager.checkLoginDuplication(request);
		if(result) {
			response.sendRedirect("workspace");
		}else {
			System.out.println("로그아웃 확인여부 물어보기");
			response.sendRedirect("loginDuplication");
		}
	}
	
}
