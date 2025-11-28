package com.example.domain;

import lombok.Data;

@Data
public class SalSummaryVO {

    private Integer monthAttno;     // MONTH_ATTEND 키
    private String yearMonthLabel;  // "2025년 11월" 같은 표시용 문자열

    private Integer totalPay;       // 총지급액
    private Integer deduction;      // 공제총액
    private Integer realPay;        // 실지급액(차인지급액)
}