package com.example.domain;

import lombok.Data;

@Data
public class NoticeBoardVO {
	private String empNo;
	private String noticeNo;
	private String noticeContent;
	private String noticeWriter;
	private String noticeDate;
	private String noticeTitle;
	private Integer noticeCnt;
	private Integer deptNo;
	private String deptName;
	private Integer replyCnt;
}
