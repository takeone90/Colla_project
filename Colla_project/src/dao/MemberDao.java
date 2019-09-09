package dao;

import java.util.List;

import model.EmailVerify;
import model.Member;

public interface MemberDao {
	public int insertMember(Member member);
	public int updateMember(Member member);
	public int deleteMember(int num);
	public Member selectMember(int num);
	public Member selectMemberByEmail(String email);
	public List<Member> selectAll();
	public List<String> selectAuthoritesByNum(int num);
	public List<Member> selectAllMemberByWnum(int wNum);
	public int insertEmailVerify(EmailVerify emailVerify);
	public int updateEmailVerify(EmailVerify emailVerify);
	public EmailVerify selectEmailVerify(String email);
	public int insertProfileImg(Member member);
	public int insertAuthority(int num);
}
