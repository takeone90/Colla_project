package test;


import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import model.ChatMessage;
import model.Todo;
import service.ChatMessageService;
import service.TodoService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:WebContent/WEB-INF/spring/root-context.xml")
public class test {
	@Autowired
	private ChatMessageService cmService;
	@Autowired
	private TodoService tdService;
	
	@Test
	public void serviceTest() {
		BCryptPasswordEncoder scpwd = new BCryptPasswordEncoder();
		
		String password = scpwd.encode("123");
		System.out.println(password);
	}
}
