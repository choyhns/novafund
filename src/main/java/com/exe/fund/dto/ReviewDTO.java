package com.exe.fund.dto;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ReviewDTO {

	private int numRev;
	private int numPro;
	private String userId;
	private String content;
	private int grade;
	private String saveFileName;
	private String originalFileName;
	private MultipartFile modifyFile;
	private String created;
	
	private int groupNum;
	private int depth;
	private int orderNo;
	private int parent;
	
}
