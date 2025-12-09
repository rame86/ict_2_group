package com.example.board;

import lombok.Data;

@Data
public class BoardVO {

	private Integer seq;
	private String title;
	private String writer;
	private String content;
	private String regdate;
	private Integer cnt;
}
// @Data는 @Setter, @Getter, @ToString 포함
