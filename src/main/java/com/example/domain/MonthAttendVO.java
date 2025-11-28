package com.example.domain;

import lombok.Data;

@Data
public class MonthAttendVO {

	private Integer monthAttno;
    private String empNo;
    private Double workHour;
    private Double overtime;
    private Integer workDay;
    private Integer lateCnt;
    private Integer abcentCnt;
}
