package com.example.domain;

import lombok.Data;

@Data
public class BoardVO {
	private String boardNo;
	private String boardContent;
	private String empNo;
	private String boardDate;
	private String boardTitle;
	private Integer boardCnt;
}
