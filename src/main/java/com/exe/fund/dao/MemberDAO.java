package com.exe.fund.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.exe.fund.dto.MemberDTO;
import com.exe.fund.dto.SponDetailDTO;
import com.exe.fund.dto.WithdrawDTO;

import lombok.RequiredArgsConstructor;

@Repository
public class MemberDAO {

	@Autowired
	@Qualifier("sessionTemplate")
	private SqlSessionTemplate sessionTemplate;
	
	public void insertData(MemberDTO dto) {
		sessionTemplate.insert("com.member.insertData",dto);
	}
	
	public MemberDTO findById(String id) {
		
		return sessionTemplate.selectOne("com.member.findById", id);
	}
	
	public MemberDTO findByEmail(String email) {
		
		return sessionTemplate.selectOne("com.member.findByEmail", email);
	}
	
	public MemberDTO findByPhone(String phone) {
		
		return sessionTemplate.selectOne("com.member.findByPhone", phone);
	}
	
	public List<MemberDTO> getLists(){
		
		List<MemberDTO> lists = sessionTemplate.selectList("com.member.getLists");
		
		return lists;
	}
	
	public void updateData(MemberDTO dto) {
		sessionTemplate.update("com.member.updateData",dto);
	}
	
	public void deleteData(String userId) {
		sessionTemplate.delete("com.member.deleteData",userId);
	}
	

	public void updatePwd(MemberDTO dto) {
		sessionTemplate.update("com.member.updatePwd",dto);
	}

	public void updateCashPoint(MemberDTO dto) {
		sessionTemplate.update("com.member.updateCashPoint",dto);
	}
	
	public void updateEnabled(MemberDTO dto) {
		sessionTemplate.update("com.member.updateEnabled",dto);
	}
	
	public void updateNickname(MemberDTO dto) {
		sessionTemplate.update("com.member.updateNickname",dto);
	}
	
	public void updateEmail(MemberDTO dto) {
		
		if(dto.getUserId().startsWith("kakaoId_")) {
			sessionTemplate.update("com.member.updateSocialEmail",dto);
		}else {
			sessionTemplate.update("com.member.updateEmail",dto);
		}
	}
	
	public void updatePhone(MemberDTO dto) {
		sessionTemplate.update("com.member.updatePhone",dto);
	}
	
	public List<WithdrawDTO> getWithdrawListsByUserId(String userId){
		return sessionTemplate.selectList("com.fund.withdraw.findByUserId",userId);
	}
	
	public int getWithdrawMaxNum() {
		return sessionTemplate.selectOne("com.fund.withdraw.getMaxNum");
	}
	
	public void inserdWithdrawData(WithdrawDTO dto) {
		sessionTemplate.insert("com.fund.withdraw.requestWithdraw",dto);
	}
	
	public WithdrawDTO getWithdrawDataByWithdrawId(int withdrawId) {
		return sessionTemplate.selectOne("com.fund.withdraw.findByWithdrawId",withdrawId);
	}
	
	public void processWithdraw(WithdrawDTO dto) {
		sessionTemplate.update("com.fund.withdraw.processWithdraw",dto);
	}
	
	public void updateAddress(MemberDTO dto) {
		sessionTemplate.update("com.member.updateAddress",dto);
	}
	
	

}
