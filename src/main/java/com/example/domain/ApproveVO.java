package com.example.domain;

import lombok.Data;

@Data
public class ApproveVO {
	private Integer approveNo;
	private Integer empNo;
	private Integer docNo;
	private String step1Status;
	private Integer step1ManagerNo;
	private String step1ApproveDate;
	private String step2Status;
	private Integer step2ManagerNo;
	private String step2ApproveDate;
	private String rejectReason;
}
