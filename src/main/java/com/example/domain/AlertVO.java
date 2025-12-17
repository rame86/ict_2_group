package com.example.domain;

import lombok.Data;

@Data
public class AlertVO {
	private Integer alertId;
	private String empNo;
	private String linkType;
	private Integer linkId;
	private String createdDate;
	private String isRead;
	
	private String type;
	private String title;
    private String senderName;
    private String sentTime;
    private String content;
    private String alertStatus;
}
