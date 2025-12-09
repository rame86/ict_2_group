package com.example.board;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import lombok.extern.slf4j.Slf4j;

//********************
@Slf4j
@Service("boardService")
public class BoardServiceImpl implements BoardService {

	// -- 의존성 주입(Dependency Injection, DI) --
	@Autowired
	private BoardDAO boardDAO;
	@Autowired
	private FileDAO fileDAO;

	//

	// getBoardList() ------------------------------------
	public List<BoardVO> getBoardList(BoardVO vo) {
		return boardDAO.getBoardList(vo);
	} // end of getBoardList() ---------------------------

	//

	// getBoard() ----------------------------------------
	public HashMap getBoard(BoardVO vo) {
		return boardDAO.getBoard(vo);
	}// end of getBoard() --------------------------------

	//

	// updateBoard() -------------------------------------
	public void updateBoard(BoardVO vo) {
		boardDAO.updateBoard(vo);
	}// end of updateBoard() -----------------------------

	//

	// deleteBoard() -------------------------------------
	public void deleteBoard(BoardVO vo) {
		boardDAO.deleteBoard(vo);
	}// end of deleteBoard() -----------------------------

	//

	// saveBoard() ---------------------------------------
	@Transactional
	public void saveBoard(BoardVO vo, FileVO filevo) {
		boardDAO.saveBoard(vo);

		if (filevo != null) {
			filevo.setBoard_seq(boardDAO.selectId());
			fileDAO.insertFile(filevo);
		}
	}// end of saveBoard() -------------------------------

}
