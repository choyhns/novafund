package com.exe.fund.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.exe.fund.dto.BizCheckDTO;

@Repository
public class BizCheckDAO {

	@Autowired
	@Qualifier("sessionTemplate")
	private SqlSessionTemplate sessionTemplate;
	
	
	public void insertBizNum(BizCheckDTO dto) {
		sessionTemplate.insert("com.bizCheck.insertBizCheck",dto);
	}
	
	public BizCheckDTO getReadBizNum(String userId) {
		List<BizCheckDTO> list = sessionTemplate.selectList("com.bizCheck.getReadBizNum",userId);
		return list.isEmpty() ? null : list.get(0); //1번째만 사용
	}
	
	public void updateBizCheck(BizCheckDTO bdto) {
		sessionTemplate.update("com.bizCheck.updateBizCheck", bdto);
	}
	
	public int deleteBizAll(int numPro) {
		return sessionTemplate.delete("com.bizCheck.deleteBizAll", numPro);
	}

}
