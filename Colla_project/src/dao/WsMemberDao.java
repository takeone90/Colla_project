package dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import model.WsMember;

public interface WsMemberDao {
	public int insertWsMember(WsMember wsMember);
	public int deleteWsMember(@Param("wNum")int wNum,@Param("mNum")int mNum);
	public int deleteAllWsMemberByMnum(int mNum);
	public WsMember selectWsMember(@Param("wNum")int wNum,@Param("mNum")int mNum);
	public List<WsMember> selectAllWsMember();
	public List<WsMember> selectAllWsMemberByCrNum(int crNum);
	public List<WsMember> selectAllWsMemberByWnum(int wNum);
	public List<Integer> selectAllMnumByWnum(int wNum);
	public List<Integer> selectAllWnumByMnum(int mNum);
}
 