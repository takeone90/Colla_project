package controller;

import java.io.IOException;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;
import org.springframework.stereotype.Component;

@Component
public class LogoutSuccessHandler extends SimpleUrlLogoutSuccessHandler{

	@Resource(name = "connectorList")
	private Map<Object,String> connectorList;//빈으로 등록된 접속자명단(email, session)

	@Override
	public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication)
			throws IOException, ServletException {
		
		HttpSession session = request.getSession();
		connectorList.remove(session);
		session.invalidate();
		
		if(request.getParameter("type").equals("duplicated")) {
			System.out.println("중복로그인되어서 기존 접속을 로그아웃합니다.");
			response.sendRedirect("/loading?info=duplicatedLogin");
		} else {
			response.sendRedirect("/main");
		}
		System.out.println("로그아웃 후 접속 중인 멤버 : "+connectorList);
		
	}
}
