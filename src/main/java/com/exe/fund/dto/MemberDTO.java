package com.exe.fund.dto;

import lombok.Data;

@Data
public class MemberDTO {
	
	private String userId;
	private String pwd;
	private String name;
	private String nickname;
	private String email;
	private String phone;
	private String address;
	private String corNum;
	private int cashPoint;
	private String resNum;
	private String role;
	private int enabled;
	private String tempPwd;
	
}
