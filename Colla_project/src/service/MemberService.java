
package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.BoardDao;
import dao.MemberDao;
import model.Member;

@Service
public class MemberService {
	//login
	//addMember
	//modifyMember
	//deleteMember
	//addMember
	//selectMemberByNum
	//selectMemberList
	
	@Autowired
	MemberDao memberDao;
	
	public boolean login(String mId, String mPass) {
		Member originMember = memberDao.selectMemberById(mId);
		if(originMember != null) {
			String originPw = originMember.getmPassword();
			if(mPass.equals(originPw)) {
				return true;
			}
		}
		return false;
	}
	

	public boolean addMember(Member member) {
		if(memberDao.insertMember(member)>0) {
			return true;
		}else {
			return false;
		}
	}

	public boolean modifyMember(Member member) {
		if(memberDao.updateMember(member)>0) {
			return true;
		}else {
			return false;
		}
	}
	
	public boolean deleteMember(int mNum) {
		if(memberDao.deleteMember(mNum)>0) {
			return true;
		}else {
			return false;
		}
	}
	public Member selectMemberByNum(int mNum) {
		return memberDao.selectMemberByNum(mNum);
	}
	public Member selectMemberById(String mId) {
		return memberDao.selectMemberById(mId);
	} 
	
	public List<Member> selectMemberList(){
		return memberDao.selectAllMember();
	}

}
