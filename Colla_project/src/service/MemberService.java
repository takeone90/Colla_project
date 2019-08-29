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
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
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
	public boolean updateProfileImg(MultipartFile[] profileImg, String profileImgType, Member member) {
		if(profileImg.length != 0 || (profileImgType != null && profileImgType.equals("defaultImg"))) {
		//사용자가 선택한 이미지 또는 기본이미지로 프로필을 변경하는 경우를 처리
			System.out.println("1. 파일을 첨부했거나, 기본이미지로 설정했다");
			String beforeFileName = member.getProfileImg();
			File beforeFile = new File(UPLOAD_PATH + "/" + beforeFileName); 
			//우선 db 변경 전, 기존 멤버가 가지고 있는 프로필 이미지 정보를 가져온다
			if(profileImgType != null && profileImgType.equals("defaultImg")) {
				System.out.println("2. 기본이미지로 설정했다");
			// 1. 기본 이미지로 설정한 경우
				member.setProfileImg(null);
				System.out.println("3. 멤버 모델에  null을 넣어주고");
				//기존 멤버의 프로필 이미지에  null 값을 넣어준 뒤
				if(dao.insertProfileImg(member)>0) { 
					//해당 값을 프로필 이미지를 업데이트 해준다
					// 변경이 성공 했다면, 이전 파일은 삭제해준다
					System.out.println("4. db 업데이트를 해준다");
					if(beforeFile.exists()) { 
						beforeFile.delete();
					}
					return true;
				}
			}else if(profileImg.length != 0) {
			//2. 이미지를 변경한 경우	
				String fullName = writeFile(profileImg);
				//먼저, 사용자가 선택한 이미지를 해당 폴더에 저장 후, uuid 까지 붙은 파일 이름을 반환한다
				member.setProfileImg(fullName);
				// 기존 멤버의 프로필 이미지에 변경된 파일 이름을 넣어준 뒤
				if(dao.insertProfileImg(member)>0) { 
					//해당 값을 프로필 이미지에 업데이트 해준다
					// 변경이 성공 했다면, 이전 파일은 삭제해준다
					if(beforeFile.exists()) { 
						beforeFile.delete();
					}
					return true;
				}
			}
			return false;
		}else {
			// 사용자가 어떠한 값도 변경하지 않은 경우는 변경할 값이 없다
			return true;
		}
	}

	//파일을 해당 경로에 저장
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
				return null;
			}
		}
		return fullName;
	}
	
	//이미지를 가져옴
	public byte[] getProfileImg(String profileImgName,HttpServletRequest request) {
		File file = new File(UPLOAD_PATH+"/"+profileImgName);
		String path = null;
		//1. 파일 네임을 받아와서 파일을 생성한다
		if(file.exists()) {
			System.out.println("파일이 존재하한다");
			//2. 해당 프로필 이미지가 존재한다
			
		}else {
			System.out.println("파일이 존재하지 않는다");
			//2. 해당 프로필 이미지가 존재하지 않는다
			//3. 기본이미지로 보여준다
			profileImgName = "profileImage.png";
			path = request.getSession().getServletContext().getRealPath("/WEB-INF/resources/img");
			file = new File(path+"/"+profileImgName);
			
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
