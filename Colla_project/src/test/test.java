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
//		int currDate = 0;
//		for(ChatMessage cm : cmService.getAllChatMessageByCrNum(1, 1)) {
//			Date cmDate = cm.getCmWriteDate();
//			int date = cmDate.getDate();
//			if(currDate!=date) {
//				int year = cmDate.getYear()+1900;
//				int month = ((Integer)cmDate.getMonth()+1);
//				System.out.println("<"+year+"년 "+month+"월 "+cmDate.getDate()+"일>");
//				currDate = date;				
//			}
//			System.out.println(cm);
//		}
		List<Todo> tdList = tdService.getAllTodoByPnum(2);
		System.out.println(tdList);
	}
}
