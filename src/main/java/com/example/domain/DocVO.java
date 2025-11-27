package com.example.domain;

import lombok.Data;

@Data
public class DocVO {
	private Integer DocNo;
	private String DocType;
	private String DocTitle;
	private String DocContent;
	private String DocDate;
}
