package com.exe.fund.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.exe.fund.dto.RewardDTO;

@Repository
public class RewardDAO {

	@Autowired
	@Qualifier("sessionTemplate")
	private SqlSessionTemplate sessionTemplate;
	

	
	// ют╥б
	public void insertReward(RewardDTO rdto) {
		
		sessionTemplate.insert("com.fund.reward.insertReward", rdto);
		

	}
	
	public List<RewardDTO> getReadData(int numPro) {
		
		return sessionTemplate.selectList("com.fund.reward.getReadData", numPro);
		
	}
	
	public void updateData(RewardDTO rdto) {
		sessionTemplate.update("com.fund.reward.updateData",rdto);
	}
	
	public void deleteData(int numPro) {
		sessionTemplate.delete("com.fund.reward.deleteData", numPro);
	}
	
	public RewardDTO getRewardData(int rewardId) {
		return sessionTemplate.selectOne("com.fund.reward.getRewardData",rewardId);
	}
}
