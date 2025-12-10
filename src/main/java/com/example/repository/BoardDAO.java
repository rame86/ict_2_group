package com.example.repository;

import java.util.HashMap;
import java.util.List;

import com.example.domain.BoardVO;

public interface BoardDAO {
	public List<BoardVO> getFreeBoardList();

	public HashMap getBoard(BoardVO vo);

	public Integer saveBoard(BoardVO vo);

	public Integer updateBoard(BoardVO vo);
	
	public Integer deleteBoard(BoardVO vo);
	
	public Integer selectId();
}
