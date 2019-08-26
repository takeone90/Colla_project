package test;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import dao.MemberDao;
import model.Member;
import model.Workspace;
import service.MemberService;
import service.WorkspaceService;
import service.WsMemberService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:WebContent/WEB-INF/spring/root-context.xml")
public class test {
	@Autowired
	private WsMemberService wsMemberService;
	@Autowired
	private WorkspaceService wService;
	@Autowired
	private MemberService mService;
	@Autowired
	private MemberDao dao;
	@Test
	public void serviceTest() {
		String emailAddress="tyqnsdl@naver.com?";
		int idx = emailAddress.indexOf("?");
		System.out.println("idx : "+idx);
		System.out.println(emailAddress.substring(0,idx));
	}
}
