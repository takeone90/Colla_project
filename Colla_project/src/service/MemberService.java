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

import com.sun.mail.handlers.multipart_mixed;

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
	private static final String THUMBNAIL_PATH="c:\\thumbnail";
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
	
	public boolean modifyProfileImg(MultipartFile[] profileImg,String type, Member member) {
		if(writeFile(profileImg,type,member)) {
			if(dao.insertProfileImg(member)>0) {
				return true;
			}
		}
		return false;
	}
	
	public boolean writeFile(MultipartFile[] profileImg,String type,Member member) {
		String fullName = null;
		UUID uuid = UUID.randomUUID();
		String fileName = null;
		for(MultipartFile multipartFile : profileImg) {
			fileName = multipartFile.getOriginalFilename();
		}

		String fullName = uuid.toString() + "_" + fileName;
		
		
		String filePath = null;
		String path = null;
		boolean result = true;
		for(MultipartFile multipartFile : profileImg) {
			File saveFile = null;
			if(type!=null && type.equals("thumbnail")) {
				path = THUMBNAIL_PATH;
			}else{
				System.out.println("temp를 가져온다");
				path = UPLOAD_PATH;
			}
			filePath = path + "/" + fullName;
			File file = new File(filePath);
			if(file.exists()) {
				result = file.delete();
			}
			if(result) {
				saveFile = new File(path,member.getEmail());
			}	
			try {
				multipartFile.transferTo(saveFile);
			} catch (IllegalStateException | IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.out.println("파일복사 예외발생");
				return false;
			}
		}
		return true;
	}
	
	public byte[] getProfileImg(Member member,String fileName,String type) {
		File file = null;
		if(type != null && type.equals("thumbnail")) {
			file = new File(THUMBNAIL_PATH+"/"+fileName);
		}else {
			file = new File(UPLOAD_PATH+"/"+fileName);
		} 
		InputStream in = null;
		try {
			in = new FileInputStream(file);
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
