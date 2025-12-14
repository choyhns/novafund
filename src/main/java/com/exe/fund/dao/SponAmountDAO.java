package com.exe.fund.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.exe.fund.dto.SponAmountDTO;

@Repository
public class SponAmountDAO {

	@Autowired
	@Qualifier("sessionTemplate")
	private SqlSessionTemplate sessionTemplate;
	
	public List<SponAmountDTO> getUserAmount(String userId){
		return sessionTemplate.selectList("com.fund.spon.getUserAmount",userId);
	}
	
	public List<SponAmountDTO> getSponLists(String userId) {
		return sessionTemplate.selectList("com.fund.spon.getSponLists", userId);
	}
	
	public List<SponAmountDTO> getAmountProject (int numPro) {
		return sessionTemplate.selectList("com.fund.spon.getProjectSpon",numPro);
	}
	
	public void updatePaid(int sponNum,int paid) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("sponNum", sponNum);
		map.put("paid", paid);
		
		sessionTemplate.update("com.fund.spon.updatePaid", map);
	}
	
	public SponAmountDTO getSponData(int sponNum) {
		return sessionTemplate.selectOne("com.fund.spon.getSponData",sponNum);
	}

	public void sponCancel(SponAmountDTO dto) {
		sessionTemplate.update("com.fund.spon.cancelSpon",dto);
	}
	
	public int getTotalSponAmount(Integer numPro) {
		return sessionTemplate.selectOne("com.fund.spon.getTotalSponAmount",numPro);
	}
	

}
