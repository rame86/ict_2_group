package com.example.board;

import java.util.HashMap;
import java.util.List;

public interface BoardService {
	public List<BoardVO> getBoardList(BoardVO vo);

	public HashMap getBoard(BoardVO vo);

	public void saveBoard(BoardVO vo, FileVO fvo);

	public void updateBoard(BoardVO vo);
	
	public void deleteBoard(BoardVO vo);
}
