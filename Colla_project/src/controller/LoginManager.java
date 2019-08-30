package controller;

import java.util.Hashtable;

import javax.security.auth.message.callback.PrivateKeyCallback.Request;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionBindingEvent;


public class LoginManager {
	
	
	private boolean isContinue;
	private static Hashtable<String, HttpSession> loginUsers = new Hashtable<String, HttpSession>();
	
	public LoginManager() {
		isContinue = false;
	}
	
	//로그인 중복체크
	public boolean checkLoginDuplication(HttpServletRequest request) {
		String userEmail = request.getParameter("m_email");
		request.getSession().setAttribute("userEmail", userEmail);
		for(String key : loginUsers.keySet()) {
			if(key.equals(userEmail)) {
				loginUsers.get(userEmail).invalidate();
				loginUsers.put(userEmail, request.getSession());
				return false;
			}
		}
		loginUsers.put(userEmail, request.getSession());
		return true;
	}
		
	//session 삭제
	public void removeLoginSession() {
		
	}
	
	/*
	public void valueBound(HttpSessionBindingEvent event) {
		for(String key : loginUsers.keySet()) {
			if(key.equals(event.getName())) {
				System.out.println("동일한 아이디가 이미 로그인 되어있습니다");
				//https://mycup.tistory.com/163
				loginUsers.get(key).invalidate();
				
				isContinue = true;
				
			}
		}
		loginUsers.put(event.getName(),event.getSession());
				
	}
	
	

	public void valueUnbound(HttpSessionBindingEvent event) {
		System.out.println("sessionId 삭제");
		System.out.println(event.getName() + "님이 로그아웃하셨습니다");
		System.out.println("로그아웃 메소드 실행 후 멤버 :" + loginUsers);
		
	}
	
	public int getUserCount() {
		return loginUsers.size();
	}
	
	public void checkLogout() {
		System.out.println("체크아웃!");
	}



	 * */


}
