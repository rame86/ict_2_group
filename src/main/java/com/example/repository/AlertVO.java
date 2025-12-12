package com.example.repository;

import lombok.Data;

@Data
public class AlertVO {
	private String type;
	private String title;
    private String senderName;
    private String sentTime;
    private String linkId;
}
