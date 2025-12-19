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
	private String jobTitle;
	private Integer salBase;

	// === DB에는 없고, 조인 결과를 담기 위한 '화면용' 필드들 ===
	private String deptName;
	private String statusName;

	// 사원관리 페이지에서 표시할 직급명
	private String gradeName;

	// 🔹 비고 입력값 (새로 추가)
	private String eNote;

	// 권한등급(gradeNo)
	// 1. 최고관리자
	// 2. 상급관리자
	// 3. 관리자
	// 4. 사원
	// 5. 인턴/수습
	// 6. 기타
	
	// 재직상태(statusNo)
	// 1. 재직
	// 2. 휴직(자발적)
	// 3. 휴직(병가 등 복지)
	// 4. 대기
	// 5. 징계
	// 6. 인턴/수습
	// 7. 파견
}
