package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import model.EmailVerify;
import model.Member;

public interface MemberDao {
	public int insertMember(Member member);
	public int updateMemberName(String name, String email);
	public int updateMemberPw(String pw, String email);
	public int updateMemberPhone(String phone, String email);
	public int deleteMember(int num);
	public Member selectMember(int num);
	public Member selectMemberByEmail(String email);
	public List<Member> selectAll();
	public List<String> selectAuthoritesByNum(int num);
	public List<Member> selectAllMemberByWnum(int wNum);
	public List<Member> selectAllMemberByCrNum(int crNum);
	public List<Member> selectAllNotMemberByWnumCrNum(@Param("wNum")int wNum,@Param("crNum")int crNum);
	public int insertEmailVerify(EmailVerify emailVerify);
	public int updateEmailVerify(EmailVerify emailVerify);
	public EmailVerify selectEmailVerify(String email);
	public int insertProfileImg(Member member);
	public int insertAuthority(int num);
	
	public List<Map<Object,Object>> selectWsMemberListbyMnum(int mNum);
}
