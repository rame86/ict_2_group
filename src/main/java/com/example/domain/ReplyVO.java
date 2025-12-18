package com.example.domain;

import lombok.Data;
import java.util.Date;

@Data
public class ReplyVO {
	private Long replyNo;
	private Integer boardNo;
	private Integer noticeNo;
	private String replyWriterEmpNo;
	private String replyContent;
	private Date replyCreatedAt;

	private String replyWriterName; // 조인용 이름이구요~
	private String replyWriterJob; // 조인용 직급이구용
	
	private String replyWriterImage; // 사진가져올거야
}