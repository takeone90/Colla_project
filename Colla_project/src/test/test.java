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
		int memberNum = 1;
		//getWnum
		int workspaceNum = 1;
		System.out.println(memberNum+"번 멤버가 참여한 워크스페이스 번호 : "+wsMemberService.getWnumByMnum(memberNum));
		System.out.println("워크스페이스"+workspaceNum+"번에 있는 멤버들 번호 : "+wsMemberService.getMnumByWnum(workspaceNum));
//		List<Member> mList = mService.getAllMemberByWnum(1);
		System.out.println("<워크스페이스1번의 모든 멤버리스트 >");
		System.out.println(dao.selectAllMemberByWnum(1));
			
	}
}
