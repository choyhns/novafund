package com.exe.fund.dto;

import lombok.Data;

@Data
public class WithdrawDTO {

	private int withdrawId;
	private String userId;
	private int amount;
	private String bankName;
	private String accountNumber;
	private String status;
	private String requestDate;
	private String processDate;
	private String holder;
	
}
