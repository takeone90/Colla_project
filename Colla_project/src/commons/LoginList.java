package commons;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

public class LoginList {
	private Map<String, Object> loginMemberList;
	public LoginList() {
		loginMemberList = new HashMap<>();
	}
	
	public  void addUser(String userEmail, HttpSession session) {
		loginMemberList.put(userEmail, session);
	}
	
	public  void removeUser(String userEmail) {
		loginMemberList.remove(userEmail);
	}
	
	public Map<String, Object> getLoginList(){
		return loginMemberList;
	}
}
