package com.example.domain;

import lombok.Data;

@Data
public class MonthAttendVO {

	private Integer monthAttno;
    private String empNo;
    
    private Double workHour;
    private Integer workDay;
    private Double overtime;
    private Integer lateCnt;
    private Integer abcentCnt;
}
