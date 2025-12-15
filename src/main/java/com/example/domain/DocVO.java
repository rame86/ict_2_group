package com.example.domain;

import lombok.Data;

@Data
public class DocVO {
	private Integer docNo;
	private String docWriter;
	private String docType;
	private String docTitle;
	private String docContent;
	private String docDate;
	private String targetEmpNo;
	private String targetDeptNo;
	
	// 추가로 사용할 필드
	private String writerName;
    private Integer step1ManagerNo;
    private String step1ManagerName;
    private String step1Status;
    private Integer step2ManagerNo;
    private String step2ManagerName;
    private String step2Status;
    private String rejectReason;
    
    // 휴가신청 // 출퇴근 정정
    private String empNo;
    private String startDate; //휴가시작 날짜 or 출퇴근 정정 요청 기존날짜,시간
    private String endDate; // 휴가 끝 날짜 or 출퇴근 정정 요청 날짜,시간
    private String totalDays;
    private String emergencyContact; // 비상연락망
    private String memo;
    private String newmodifyTime;
    private String attStatus;
}
