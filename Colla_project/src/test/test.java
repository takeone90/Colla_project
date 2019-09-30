package test;


import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
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
		int a=2;
		int b=3;
		double c = ((double)a/b*100);
		
		System.out.println(Math.round(c*10)/10.0);
	}
}
