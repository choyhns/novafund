package com.exe.fund.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.exe.fund.dto.SponAmountDTO;
import com.exe.fund.dto.SponDetailDTO;
import com.exe.fund.dto.WithdrawDTO;

@Repository
public class SponDetailDAO {

	@Autowired
	@Qualifier("sessionTemplate")
	private SqlSessionTemplate sessionTemplate;
	
	public List<SponDetailDTO> getLists(String userId){
		return sessionTemplate.selectList("com.fund.sponDetail.getLists",userId);
	}
	
	public void insertData(SponDetailDTO dto) {
		sessionTemplate.insert("com.fund.sponDetail.insertSponDetail", dto);
	}
	
	public SponDetailDTO getSponDetail(String userId,String created) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("created", created);
		
		return sessionTemplate.selectOne("com.fund.sponDetail.getSponDetail", map);
	}
	
	public void cancelWithdraw(SponDetailDTO dto) {
		sessionTemplate.update("com.fund.sponDetail.cancelPaid",dto);
	}
	
	public SponDetailDTO getSponDetailBySponNum(int sponNum) {
		return sessionTemplate.selectOne("com.fund.sponDetail.getSponDetailBySponNum",sponNum);
	}
	
	public void cancelSpon(SponDetailDTO dto) {
		sessionTemplate.update("com.fund.sponDetail.cancelSpon",dto);
	}
	

	public List<WithdrawDTO> getPendingWithdrawLists() {
		return sessionTemplate.selectList("com.fund.withdraw.getPendingLists");
	}

}
