package com.example.domain;

import lombok.Data;

@Data
public class DocVO {
	private Integer docNo;
	private String docWriter;
	private String docType;
	private String docTitle;
	private String docContent;
	private String docDate;
	
	// 추가로 사용할 필드
	private String writerName;
    private Integer step1ManagerNo;
    private String step1ManagerName;
    private String step1Status;
    private Integer step2ManagerNo;
    private String step2ManagerName;
    private String step2Status;
    private String rejectReason;
}
