package com.example.domain;

import lombok.Data;

@Data
public class FreeBoardVO {
	private String empNo;
	private String boardNo;
	private String boardContent;
	private String boardWriter;
	private String boardDate;	
	private String boardTitle;
	private Integer boardCnt;
	private Integer deptNo;
}
