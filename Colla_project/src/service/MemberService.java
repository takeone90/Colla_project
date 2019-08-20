package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.BoardDao;
import model.Member;

@Service
public class MemberService {

	@Autowired
	BoardDao boardDao;

	public boolean addMember(Member member) {

	}

	public boolean modifyMember(Member member) {

	}
	
	public boolean deleteMember(Member member) {

	}

}
