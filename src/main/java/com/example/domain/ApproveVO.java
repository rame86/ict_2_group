package com.example.domain;

import lombok.Data;

@Data
public class ApproveVO {
	private Integer approveNo;
	private Integer empNo;
	private Integer docNo;
	private String approveDate;
	private String step1Status;
	private String step1ManagerNo;
	private String step2Status;
	private String step2ManagerNo;
}
