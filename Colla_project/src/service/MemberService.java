package service;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.MemberDao;
import model.Member;

@Service
public class MemberService {
	@Autowired
	private MemberDao dao;
	public boolean addMember(String email,String name,String pw) {
		boolean result = false;
		Member member = new Member();
		member.setEmail(email);
		member.setName(name);
		member.setPw(pw);
		if(dao.insertMember(member)>0) {
			result = true;
		}
		return result;
	}
	public boolean modifyMember(Member member) {
		boolean result = false;
		if(dao.updateMember(member)>0) {
			result = true;
		}
		return result;
	}
	public boolean removeMember(int num) {
		boolean result = false;
		if(dao.deleteMember(num)>0) {
			result = true;
		}
		return result;
	}
	public Member getMember(int num) {
		return dao.selectMember(num);
	}
	public Member getMemberByEmail(String email) {
		return dao.selectMemberByEmail(email);
	}
	public List<Member> getAllMember(){
		return dao.selectAll();
	}
}
