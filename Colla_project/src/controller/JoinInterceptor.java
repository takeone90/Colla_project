package controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import model.EmailVerify;
import service.MemberService;
@Component("joinInterceptor")
public class JoinInterceptor extends HandlerInterceptorAdapter{
	@Autowired
	private MemberService service;
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		System.out.println("joinInterceptor 실행!");
		HttpSession session = request.getSession();
		
//		String emailAddress = (String)session.getAttribute("emailAddress");
		String verifyCode = (String)session.getAttribute("verifyCode");

		String inputVerifyCode = (String)session.getAttribute("inputVerifyCode");
		if(verifyCode!=null && verifyCode.equals(inputVerifyCode)) {
			return true;
		}else {
			response.sendRedirect(request.getContextPath()+"/joinStep1");
			return false;
		}
		
//		EmailVerify emailVerify = service.getEmailVerify((String)session.getAttribute("emailAddress"));
//		String verifyCode = (String)session.getAttribute("verifyCode");
//		if(verifyCode.equals(emailVerify.getVerifyCode())) {
//			return true;
//		}
//		return false;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
	}
	
}
