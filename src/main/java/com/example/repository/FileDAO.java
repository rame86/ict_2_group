package com.example.repository;

import com.example.domain.FileVO;

public interface FileDAO {
	public void insertFile(FileVO vo);

	public void insertMemberFile(FileVO vo);
	public FileVO selectFile(FileVO vo);
}
