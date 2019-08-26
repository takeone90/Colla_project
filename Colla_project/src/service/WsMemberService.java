package service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.WsMemberDao;
import model.Workspace;
import model.WsMember;

@Service
public class WsMemberService {
	@Autowired
	private WsMemberDao dao;
	public boolean addWsMember(int wNum,int mNum) {
		boolean result = false;
		WsMember wsMember = new WsMember();
		wsMember.setmNum(mNum);
		wsMember.setwNum(wNum);
		if(dao.insertWsMember(wsMember)>0) {
			result = true;
		}
		return result; 
	}
	public boolean removeWsMember(int wNum,int mNum) {
		boolean result = false;
		if(dao.deleteWsMember(wNum, mNum)>0) {
			result = true;
		}
		return result;
	}
	public WsMember getWsMember(int wNum,int mNum) {
		return dao.selectWsMember(wNum, mNum);
	}
	public List<Integer> getWnumByMnum(int mNum){
		return dao.selectAllWnumByMnum(mNum);
	}
	public List<Integer> getMnumByWnum(int wNum){
		return dao.selectAllMnumByWnum(wNum);
	}
	public List<WsMember> getAllWsMember(){
		return dao.selectAllWsMember();
	}
	
}
