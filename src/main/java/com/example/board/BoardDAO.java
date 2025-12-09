package com.example.board;

import java.util.HashMap;
import java.util.List;

public interface BoardDAO {
	public List<BoardVO> getBoardList(BoardVO vo);

	public HashMap getBoard(BoardVO vo);

	public Integer saveBoard(BoardVO vo);

	public Integer updateBoard(BoardVO vo);
	
	public Integer deleteBoard(BoardVO vo);
	
	public Integer selectId();
}
