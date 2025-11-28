package com.example.domain;

import lombok.Data;

@Data
public class DeptVO {
	
	// 기존 DeptVO
	private String deptNo;
	private String managerEmpNo;
	private String deptName;
	private int myParentDeptNo; // 내가 속한 부서의 상위부서 번호
	private String deptAddr;
	private String deptPhone;
	
	// approve단계에서 사용할 상위부서번호 정보
	private String parentDeptNo; // 상위부서의 부서번호
	private String parentManagerEmpNo; // 상위부서의 부서장번호
	private String parentManagerName;
	private String parentManagerPhone;
	private String parentManagerEmail;
	
}
