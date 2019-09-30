package interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import service.MemberService;

@Component("joinStep2Interceptor")
public class JoinStep2Interceptor extends HandlerInterceptorAdapter {
	@Autowired
	private MemberService service;
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		String emailAddress = (String)session.getAttribute("emailAddress");
		if(emailAddress != null) {
			return true;
		}else {
			response.sendRedirect(request.getContextPath()+"/joinStep1");
			return false;
		}
	}
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
	}
}
