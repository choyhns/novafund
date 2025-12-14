package com.exe.fund.dto;

import lombok.Data;

public class SponDetailDTO {
	
	private String userId;
	private String detail;
	private String created;
	private int numPro;
	private String actiontype;
	private String description;
	private String status;
	private int rewardId;
	private int sponNum;
	
	int amount;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getDetail() {
		return detail;
	}

	public void setDetail(String detail) {
		this.detail = detail;
	}

	public String getCreated() {
		return created;
	}

	public void setCreated(String created) {
		this.created = created;
	}

	public int getNumPro() {
		return numPro;
	}

	public void setNumPro(int numPro) {
		this.numPro = numPro;
	}

	public String getActiontype() {
		return actiontype;
	}

	public void setActiontype(String actiontype) {
		this.actiontype = actiontype;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public int getRewardId() {
		return rewardId;
	}

	public void setRewardId(int rewardId) {
		this.rewardId = rewardId;
	}

	public int getSponNum() {
		return sponNum;
	}

	public void setSponNum(int sponNum) {
		this.sponNum = sponNum;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}
	
	
}
