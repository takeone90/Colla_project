package service;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.View;

import commons.DownloadView;
import dao.BoardFileDao;
import model.BoardFile;

@Service
public class FileService {
	private static final String UPLOAD_PATH = "c:\\temp";
	
	@Autowired
	BoardFileDao fDao;
	
	public boolean addFiles(BoardFile file) {
		return fDao.insertFile(file)>0?true:false;
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
