package com.exe.fund.dto;

import java.util.List;

import lombok.Data;

@Data
public class RewardDTO {

	private Integer rewardId;
	private int numPro;
	private String rewardSubject;
	private int amount;
	private String rewardContent;
	private int rewardQuantity;
	private int addMoney;

	private List<RewardDTO> rewardList;

	
}
