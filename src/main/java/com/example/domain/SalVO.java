package com.example.domain;

import lombok.Data;

@Data
public class SalVO {

	private Integer salNum;
	private Integer monthAttno;
	private String empNo;
	private String salDate;
	
	private Integer salBase;
	private Integer salBonus;
	private Integer salPlus; //기타 추가수당
	private Integer insurance;
	private Integer tax;
	
	// 실지급액 = payTotal - deductTotal
	private Integer realPay;
	
	private String yearMonth;
	private Integer overtimePay; //초과근무 수당. (초과 근무 시간이랑 다름)
	
	// 총 지급액 = salBase + salBonus + salPlus (+ 필요하면 overtimePay 등)
	private Integer payTotal;
	
	// 공제 총액 = insurance + tax (+ 기타 공제)
    private Integer deductTotal;
    
 // monthAttno(202511) → yearMonthLabel("2025년 11월") 로 변환해서 넣음
    private String yearMonthLabel;

 // 🔹 관리자 급여대장 화면용 추가 필드
    private String empName;   // 사원 이름
    private String deptName;  // 부서 이름

}
