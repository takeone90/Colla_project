package service;


import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.mail.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

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
	
	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;
	
	//파일 저장 경로
	@Resource(name="uploadPath")
	private String UPLOAD_PATH;
	
	@Transactional
	public boolean addMember(Member member) {
		String bcryptPassword = bcryptPasswordEncoder.encode(member.getPw());
		member.setPw(bcryptPassword);
		if(dao.insertMember(member)>0) {
			dao.insertAuthority(member.getNum()); //권한 추가
			SetAlarm setAlarm = new SetAlarm();
			setAlarm.setNum(member.getNum());
			System.out.println("setAlarm : " + setAlarm);
			if(setAlarmDao.insertSetAlarm(setAlarm)>0) {
				return true;
			}
		}
		return false;
	}
  
	public List<Map<Object,Object>> getWsMemberListbyMnum(int mNum){
		return dao.selectWsMemberListbyMnum(mNum);
	}
	
	public boolean modifyMemberName(String name, String email) {
		boolean result = false;
		if(dao.updateMemberName(name,email)>0) {
			result = true;
		}
		return result;
	}
	public boolean modifyMemberPw(String pw, String email) {
		boolean result = false;
		String bcryptPassword = bcryptPasswordEncoder.encode(pw);
		if(dao.updateMemberPw(bcryptPassword,email)>0) {
			result = true;
		}
		return result;
	}
	public boolean modifyMemberPhone(String phone, String email) {
		boolean result = false;
		if(dao.updateMemberPhone(phone,email)>0) {
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
	public List<Member> getAllMemberByCrNum(int crNum){
		return dao.selectAllMemberByCrNum(crNum);
	}
	public List<Member> getAllNotMemberByWnumCrNum(int wNum,int crNum){
		return dao.selectAllNotMemberByWnumCrNum(wNum, crNum);
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
		if(bcryptPasswordEncoder.matches(pw, originMember.getPw())) {
			return true;
		}
		return false;
	}
	public boolean updateProfileImg(MultipartFile[] profileImg, String profileImgType, Member member) {
		String path = UPLOAD_PATH + member.getEmail();
		if(profileImg.length != 0 || (profileImgType != null && profileImgType.equals("defaultImg"))) {
		//1. 프로필 파일 첨부 또는 기본이미지 설정
			String beforeFileName = member.getProfileImg();
			File beforeFile = new File(path + "/" + beforeFileName); //db 변경 전, 기존 멤버가 가지고 있는 프로필 이미지 정보를 가져온다
			// 1-1. 기본 이미지로 설정한 경우
			if(profileImgType != null && profileImgType.equals("defaultImg")) { 
				member.setProfileImg(null);
				if(dao.insertProfileImg(member)>0) {
					if(beforeFile.exists()) { 
						beforeFile.delete();
					}
					return true;
				}
			}else if(profileImg.length != 0) {
			//1-2. 이미지를 변경한 경우	
				String fullName = writeFile(profileImg,member);
				member.setProfileImg(fullName);
				if(dao.insertProfileImg(member)>0) {
					if(beforeFile.exists()) { 
						beforeFile.delete();
					}
					return true;
				}
			}
			return false;
		}else {
			//2. 사용자가 어떠한 값도 변경하지 않은 경우는 변경할 값이 없다
			return true;
		}
	}

	//파일을 해당 경로에 저장
	public String writeFile(MultipartFile[] profileImg,Member member) {
		String path = UPLOAD_PATH + member.getEmail();
		String fullName = null;
		UUID uuid = UUID.randomUUID();	
		File folder = new File(path);
		if(!folder.exists()) {//해당 폴더가 존재하지 않는 경우
			folder.mkdir();//폴더를 생성한다
		}
		for(MultipartFile multipartFile : profileImg) {
			fullName = uuid.toString() + "_" + multipartFile.getOriginalFilename();
			File saveFile = new File(path,fullName);
			try {
				multipartFile.transferTo(saveFile);
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
				return null;
			}
		}
		return fullName;
	}
	public byte[] getProfileImg(Member member,HttpServletRequest request) {
		String path = UPLOAD_PATH + member.getEmail();
		String profileImgName = member.getProfileImg();
		File file = new File(path + "/" + profileImgName);
		if(!file.exists()) {
			profileImgName = "profileImage.png";
			path = request.getSession().getServletContext().getRealPath("/WEB-INF/resources/img");
			file = new File(path+"/"+profileImgName);	
		}
      InputStream in = null;
      try {
         in = new FileInputStream(file);
         return IOUtils.toByteArray(in);
      } catch (FileNotFoundException e) {
         e.printStackTrace();
      } catch (IOException e) {
         e.printStackTrace();
      } finally {
         try {
            if(in != null) {
               in.close();
            }
         } catch (IOException e) {
            e.printStackTrace();
         }
      }
      return null;
   }
}