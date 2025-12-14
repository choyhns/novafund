package com.exe.fund.dto;

import lombok.Data;

@Data
public class ProjectDTO {
	
	private int numPro;
	private String userId;
	private String subject;
	private String created;
	private String startDate;
	private String endDate;
	private Integer goalAmount;
	private int hitCount;
	private int good;
	private String content;
	private String categoryName;
	private int status;
	
	private MainImageDTO mainImage; 
	private String userGood;
	private int percent;
	private int totalUser;
	private int totalAmount;
	
}
