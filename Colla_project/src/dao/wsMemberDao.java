package dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import model.WsMember;

public interface wsMemberDao {
	public int insertWsMember(WsMember wsMember);
	public int deleteWsMember(@Param("wNum")int wNum,@Param("mNum")int mNum);
	public List<WsMember> selectAllWsMember();
	public List<Integer> selectAllMnumByWnum(int wNum);
	public List<Integer> selectAllWnumByMnum(int mNum);
}
