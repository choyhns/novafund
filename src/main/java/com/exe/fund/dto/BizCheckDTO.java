package com.exe.fund.dto;


import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class BizCheckDTO {

	private String userId;
	@JsonProperty("b_no")
	private String bNum;

	@JsonProperty("p_nm")
	private String pName;

	@JsonProperty("start_dt")
	private String bizStartDate;
	
	private String result;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getBNum() {
		return bNum;
	}

	public void setBNum(String bNum) {
		this.bNum = bNum;
	}

	public String getPName() {
		return pName;
	}

	public void setPName(String pName) {
		this.pName = pName;
	}

	public String getBizStartDate() {
		return bizStartDate;
	}

	public void setBizStartDate(String bizStartDate) {
		this.bizStartDate = bizStartDate;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	

}
