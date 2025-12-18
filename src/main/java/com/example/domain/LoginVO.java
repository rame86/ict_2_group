package com.example.domain;

import lombok.Data;

@Data
public class LoginVO {
	private String empNo;
	private String statusNo;
	private String deptNo;
	private String gradeNo;
	private String empName;
	private String empPhone;
	private String empAddr;
	private String empEmail;
	private String empImage;
	private String empRegNo;
	private String empRegdate;
	
	private String managerEmpNo;
	private String deptName;
	private String parentDeptNo;
	private String deptAddr;
	private String deptPhone;
	private String jobTitle;
}
