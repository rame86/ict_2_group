package com.example.domain;

import lombok.Data;

@Data
public class FileVO {
	// PK
	private int fileid;

	// 게시글번호(FK)
	private int board_seq;
	private String id;

	// 파일의 원본이름
	private String originfilename;

	// 저장한 파일명
	private String filename;

	// 저장된 경로
	private String filepath;

}
