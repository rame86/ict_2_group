package com.example.domain;

import lombok.Data;

@Data
public class DocVO {
	private Integer docNo;
	private String docType;
	private String docTitle;
	private String docContent;
	private String docDate;
}
