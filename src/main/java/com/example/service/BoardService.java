package com.example.service;

import java.util.HashMap;
import java.util.List;

import com.example.domain.BoardVO;
import com.example.domain.FileVO;

public interface BoardService {
	public List<BoardVO> getFreeBoardList();

	public HashMap getBoard(BoardVO vo);

	public void saveBoard(BoardVO vo, FileVO fvo);

	public void updateBoard(BoardVO vo);
	
	public void deleteBoard(BoardVO vo);
}
