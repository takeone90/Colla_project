package service;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.MemberDao;
import model.EmailVerify;
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
	public List<String> getMemberAuthorities(int num){
		return dao.selectAuthoritesByNum(num);
	}
	
	//workspace num으로 member List를 꺼내야한다.
	public List<Member> getAllMemberByWnum(int wNum){
		return dao.selectAllMemberByWnum(wNum);
	}
	
	
	public boolean addEmailVerify(EmailVerify emailVerify) {
		if(dao.insertEmailVerify(emailVerify) > 0) {
			return true;
		}
		return false;
	}
	
	public boolean modifyEmailVerify(EmailVerify emailVerify) {
		if(dao.updateEmailVerify(emailVerify)>0) {
			return true;
		}
		return false;
	}
	public EmailVerify getEmailVerify(String email) {
		return dao.selectEmailVerify(email);
	}
	
	//CheckPass() 추가 
	public boolean checkPass(String email, String pw) {
		Member originMember = dao.selectMemberByEmail(email);
		if(originMember.getPw().equals(pw)) {
			return true;
		}
		return false;
	}
}
