package service;

import java.io.File;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.View;

import commons.DownloadView;
import dao.BoardFileDao;
import model.BoardFile;

@Service
public class FileService {

	@Resource(name="uploadPath")
	private String UPLOAD_PATH;
	
	@Autowired
	BoardFileDao fDao;
	
	public boolean addFiles(BoardFile file) {
		return fDao.insertFile(file)>0?true:false;
	}
	
	@Transactional
	public boolean removeBoardFile(int bNum) {
		List<BoardFile> fList =  fDao.selectFilesByBnum(bNum);
		for(BoardFile bf : fList) {
			File file = new File(UPLOAD_PATH + "/" + bf.getFileName());
			if(file.exists()) {
				if(file.delete()) {
					System.out.println("파일삭제 성공");
				} else {
					System.out.println("파일삭제 실패");
				}
			}else {
				System.out.println("파일이 존재하지 않습니다.");
			}
		}
		return fDao.deleteFile(bNum)>0?true:false;
	}
	public List<BoardFile> getFilesByBnum(int bNum){
		List<BoardFile> fList =  fDao.selectFilesByBnum(bNum);
		for(BoardFile bf : fList) {
			String name = bf.getFileName();
			String origin = name.substring(name.indexOf("_") + 1);
			bf.setOriginName(origin);
		}
		return fList;
	}
	public View getDownload(String fileName) {
		File file = new File(UPLOAD_PATH, fileName);
		DownloadView view = new DownloadView(file);
		return view;
	}
}
