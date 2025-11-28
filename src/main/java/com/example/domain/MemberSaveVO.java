package com.example.domain;

import lombok.Data;

@Data
public class MemberSaveVO {

	private String empNo;
	private String empPass;
	private String kakaoId;	
	private String empEmail;
	private Long memberNo;
}
