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

import javax.mail.Session;
import javax.servlet.http.HttpSession;

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
		
	public boolean modifyProfileImg(MultipartFile[] profileImg,Member member, String type,HttpSession session) {
		if(profileImg.length != 0) {//사용자가 첨부파일을 첨부한 경우
			String fullName = writeFile(profileImg,type,session);//type에 따라 다른 폴더에 저장
			if(type.equals("profileImg")) {
				String beforeFileName = member.getProfileImg();
				File file = new File(UPLOAD_PATH + "/" + beforeFileName);
				member.setProfileImg(fullName);
				if(dao.insertProfileImg(member)>0) {
					if(file.exists()) {
						file.delete();
					}
					return true;
				}
			}else if (type.equals("thumbnail")) {
				
				return true;
			}
			
			return false;
		}else {//사용자가 첨부파일 없이 [저장]을 클릭한 경우는 변경할 데이터가 없음
			return true;
		}
	}
	
	public String writeFile(MultipartFile[] profileImg,String type,HttpSession session) {
		String fullName = null;
		UUID uuid = UUID.randomUUID();
		for(MultipartFile multipartFile : profileImg) {
			fullName = uuid.toString() + "_" + multipartFile.getOriginalFilename();
			File saveFile = null;
			if(type.equals("profileImg")) {
				saveFile = new File(UPLOAD_PATH,fullName);
			}else if (type.equals("thumbnail")) {
				System.out.println("1");
				String beforefullName = (String)session.getAttribute("fullName");
				System.out.println("2");
				if(beforefullName!=null) {
					System.out.println("3");
					System.out.println(beforefullName);
					File file = new File(beforefullName);
					if(file.exists()) {
						System.out.println("4");
						System.out.println("섬네일 삭제");
						file.delete();
					}
					
				}
				saveFile = new File(THUMBNAIL_PATH,fullName);
				System.out.println("세션에 저장 : " + fullName);
				session.setAttribute("thumbnail", fullName);
			}
			try {
				multipartFile.transferTo(saveFile);
			} catch (IllegalStateException | IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return null;
			}
		}
		return fullName;
	}
	
	public byte[] getProfileImg(Member member,String fileName) {
		if(fileName==null) {
			fileName = "profileImage.png";
		}
		File file = new File(UPLOAD_PATH+"/"+fileName);

		if(!file.exists()) {
			fileName = "profileImage.png";
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
