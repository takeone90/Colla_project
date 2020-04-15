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

import model.Member;

@Component
public class LogoutSuccessHandler extends SimpleUrlLogoutSuccessHandler{

	@Resource(name = "connectorList")
	private Map<Object,Object> connectorList;//빈으로 등록된 접속자명단(email, session)
	
	@Override
	public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication)
			throws IOException, ServletException {
		
		HttpSession session = request.getSession();
		Member user = (Member)session.getAttribute("user");
		if(request.getParameter("type") != null) {
			if(request.getParameter("type").equals("duplicated")) {
				response.sendRedirect("/loading?info=duplicatedLogin");
				return;
			}
		}
		connectorList.remove(session.getAttribute("userEmail"));
		session.invalidate();
		request.getRequestDispatcher("/logoutSomeone?mNum="+user.getNum()+"&isLogin="+false).forward(request, response);
	}
}
