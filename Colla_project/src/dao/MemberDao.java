package dao;

import java.util.List;

import model.Member;

public interface MemberDao {
	public int insertMember(Member member);
	public int updateMember(Member member);
	public int deleteMember(int num);
	public Member selectMember(int num);
	public Member selectMemberByEmail(String email);
	public List<Member> selectAll();
	
}
