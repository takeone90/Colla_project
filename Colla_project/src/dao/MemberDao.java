package dao;

import java.util.List;

import model.Member;

public interface MemberDao {
	public int insertMember(Member member);
	public int updateMember(Member member);
	public int deleteMember(int mNum);
	public Member selectMemberByNum(int mNum);
	public Member selectMemberById(String mId);
	public List<Member> selectAllMember();
	public List<String> selectAuthoritiesByNum(int num);
}
