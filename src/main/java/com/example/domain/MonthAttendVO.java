package com.example.domain;

import java.util.Date;

import lombok.Data;

@Data
public class MonthAttendVO {

    private Long monthAttno;       // MONTH_ATTNO     NUMBER
    private String empNo;          // EMP_NO          (사번, 문자열 or 숫자 -> 문자열로 두면 편함)
    private Date monthDateAttend;  // MONTH_DATE_ATTEND DATE
    private Integer workDay;       // WORK_DAY        NUMBER
    private Double workHour;       // WORK_HOUR       NUMBER
    private Double overtime;       // OVERTIME        NUMBER
    private Integer lateCnt;       // LATE_CNT        NUMBER
    private Integer abcentCnt;     // ABCENT_CNT      NUMBER
}
