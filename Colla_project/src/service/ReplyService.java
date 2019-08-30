package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.ReplyDao;
import model.Reply;

@Service
public class ReplyService {
	
	@Autowired
	ReplyDao rDao;
	
	public List<Reply> getReplyByBnum(int bNum){
		return rDao.selectReplyByBnum(bNum);
	}
	
	public boolean addReply(Reply r) {
		return rDao.insertReply(r)>0?true:false;
	}
	public boolean removeReply(int rNum) {
		return rDao.deleteReply(rNum)>0?true:false;
	}
	public boolean modifyReply(Reply r) {
		return rDao.updateReply(r)>0?true:false;
	}
}
