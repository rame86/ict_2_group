package com.example.domain;

import lombok.Data;

@Data
public class ApproveListVO {
	private String docNo;
	private String docTitle;
	private String docDate;
	private String writerName;
	private String step1ManagerName;
    private String step2ManagerName;
    private String progressStatus;
}
