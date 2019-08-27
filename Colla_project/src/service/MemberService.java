package service;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import dao.MemberDao;
import dao.SetAlarmDao;
import model.EmailVerify;
import model.Member;
import model.SetAlarm;

@Service
public class MemberService {
	@Autowired
	private MemberDao dao;
	@Autowired
	private SetAlarmDao setAlarmDao;
	
	//파일 저장 경로
	private static final String UPLOAD_PATH="c:\\temp";
	
	@Transactional
	public boolean addMember(Member member) {
		if(dao.insertMember(member)>0) {
			SetAlarm setAlarm = new SetAlarm();
			setAlarm.setNum(member.getNum());
			if(setAlarmDao.insertSetAlarm(setAlarm)>0) {
				return true;
			}
		}
		return false;
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
	
	public boolean checkPass(String email, String pw) {
		Member originMember = dao.selectMemberByEmail(email);
		if(originMember.getPw().equals(pw)) {
			return true;
		}
		return false;
	}
	
	
	public boolean registerProfileImg(MultipartFile[] profileImg, int mNum) {
		String fullName = writeFile(profileImg);
		Member member = new Member();
		member.setNum(mNum);
		member.setProfileImg(fullName);
		System.out.println("mNum : " + mNum);
		System.out.println("fullName : " + fullName);
		if(dao.insertProfileImg(member)>0) {
			return true;
		}
		return false;
	}
	
	public String writeFile(MultipartFile[] profileImg) {
		String fullName = null;
		UUID uuid = UUID.randomUUID();
		for(MultipartFile multipartFile : profileImg) {
			fullName = uuid.toString() + "_" + multipartFile.getOriginalFilename();
			File saveFile = new File(UPLOAD_PATH,fullName);
			try {
				multipartFile.transferTo(saveFile);
			} catch (IllegalStateException | IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.out.println("파일복사 예외발생");
				return null;
			}
		}
		return fullName;
	}
	
	public byte[] getProfileImg(Member member,String fileName) {
		File file = new File(UPLOAD_PATH+"/"+fileName);
		InputStream in = null;
		try {
			in = new FileInputStream(file);
			System.out.println("byte[] 반환");
			return IOUtils.toByteArray(in);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				if(in != null) {
					in.close();
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return null;
	}
	

}
