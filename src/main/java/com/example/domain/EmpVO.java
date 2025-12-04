package com.example.domain;

import lombok.Data;

@Data
public class EmpVO {

	private String empNo;
	private Integer statusNo;
	private Integer deptNo;
	private Integer gradeNo;
	private String empPass;
	private String kakaoId;
	
	private String empName;
	private String empPhone;
	private String empAddr;
	private String empEmail;
	private String empImage;
	private String empRegNo;
	private String empRegdate;	
	
	private Integer baseSal;
	
	
	 // === DB에는 없고, 조인 결과를 담기 위한 '화면용' 필드들 ===
	private String deptName;
	private String statusName;
	
	// 사원관리 페이지에서 표시할 직급명
	private String gradeName;   

}
