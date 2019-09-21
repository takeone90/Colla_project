package controller;


import java.io.IOException;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.converter.StringMessageConverter;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import model.ChatMessage;
import model.Member;
import service.MemberService;

@Component
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

	@Resource(name = "connectorList")
	private Map<Object,String> connectorList;//빈으로 등록된 접속자명단(email, session)
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
		String userEmail = request.getParameter("m_email"); //사용자에게 입력받은 이메일을 파라미터를
		request.getSession().setAttribute("userEmail", userEmail);
		request.getRequestDispatcher("/checkLoginDuplication").forward(request, response);
	}
}
