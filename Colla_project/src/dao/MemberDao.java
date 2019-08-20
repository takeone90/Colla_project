package dao;

import java.util.List;

import model.Member;

public interface MemberDao {
	public int insertMember(Member member);
	public int updateMember(Member member);
	public int deleteMember(int mNum);
	public Member selectMemberByNum(int mNum);
	public List<Member> selectAllMember();
}
