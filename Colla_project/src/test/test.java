package test;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import dao.ChatMessageDao;
import dao.MemberDao;
import model.Member;
import model.Workspace;
import service.ChatMessageService;
import service.MemberService;
import service.WorkspaceService;
import service.WsMemberService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:WebContent/WEB-INF/spring/root-context.xml")
public class test {
	@Autowired
	private ChatMessageService cmService;
	@Autowired
	private ChatMessageDao cmDao;
	@Test
	public void serviceTest() {
		System.out.println(cmService.getAllChatMessageByCrNum(250));
	}
}
