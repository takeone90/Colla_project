package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.BoardFileDao;
import model.BoardFile;

@Service
public class FileService {
	
	@Autowired
	BoardFileDao fDao;
	
	public boolean addFiles(BoardFile file) {
		return fDao.insertFile(file)>0?true:false;
	}
	public List<BoardFile> getFilesByBnum(int bNum){
		return fDao.selectFilesByBnum(bNum);
	}
}
