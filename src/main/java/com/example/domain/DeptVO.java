package com.example.domain;

import lombok.Data;

@Data
public class DeptVO {

	private String deptNo;
	private String managerEmpNo;
	private String deptName;
	private String parentDeptNo;
	private String deptAddr;
	private String deptPhone;

}
