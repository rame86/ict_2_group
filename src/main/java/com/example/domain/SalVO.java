package com.example.domain;

import lombok.Data;

@Data
public class SalVO {

	private String salNum;
	private String monthAttno;
	private String empNo;
	private String salDate;
	private Integer salBase;
	private Integer salBonus;
	private Integer salPlus;
	private Integer insurance;
	private Integer tax;

}
