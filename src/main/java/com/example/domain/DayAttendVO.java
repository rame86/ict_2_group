package com.example.domain;

import lombok.Data;

@Data
public class DayAttendVO {
	/* 기준 설명~~ */
	// 근무일 - 주 5일제(토요일 일요일 휴무)
	// 출근 기준시간 09:00
	// 퇴근 기준시간 18:00
	// 휴게시간 1:00
	// 일간 총 근무시간 ( 퇴근시 - 출근시 - 1(휴게시간)) 
	// 총근무시간 초과시 MonthAttend.java에서 추가근무로 처리(자동 계산됨)
	// 출근기록(inTime)이 없을시 퇴근 기준시간에 자동으로 결근 처리됨(AttendScheduler.java에서 처리)
	// 출근기록이 있더라도 퇴근기록이 없이 당일 23:59이 되면 자동으로 결근 처리됨(AttendScheduler.java에서 처리)
	// 연차는 기본 유급연차 (일간 총 근무시간 8:00 인정)
	// 반차는 기본 유급반차 (지각 혹은 조퇴가 아닐시 일간 총 근무시간 4:00만 인정. 자동 계산됨)

	// ATT_STATUS(attStatus) 정보 정리해놓음~
	// "0" = "퇴근"     // "1" = "출근"
	// "2" = "지각"     // "3" = "조퇴"
	// "4" = "외근" 	   // "5" = "연차"
	// "6" = "오전반차"   // "7" = "오후반차"
	// "8" = "병가"      // "9" = "보상휴가"
	// "10" = "결근"     // "11" = "출장"
	
	private String dayAttno; 	// PK
	
	private String empNo; 		// FK
	
	private String attStatus;	// 출근상태( "0" , "1" 등 정수로 기록)
	
	private String inTime;		// 출근시간(TimeStamp)
	
	private String outTime;		// 퇴근시간(TimeStamp)
	
	private String dayFulltime; // 일간 총 근무시간
	
	private String firstDaytime;// 해당 컬럼이 처음 등록된 시간
	
	private String updateTime;  // 해당 컬럼이 수정된 시간
	
	private String memo;	    // 특이사항
	
	private String dateAttend;  // 해당 컬럼의 기준(11월 1일 출근기록이면 '2025-11-01' 로 기록됨)
	
	
}
