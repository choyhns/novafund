package com.exe.fund.dto;

import java.util.List;

import lombok.Data;

@Data
public class PaymentDTO {
	
	private List<RewardDTO> lists;
	
	private int numPro;
	private int addMoney;
	private int sum;
	
	private String mailNum;
	private String address;
	private String detailAddress;
	
	

}
