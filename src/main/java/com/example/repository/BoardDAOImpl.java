package com.example.repository;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.example.domain.BoardVO;

import lombok.extern.slf4j.Slf4j;

// --------------------
@Slf4j
@Repository


public class BoardDAOImpl implements BoardDAO {

	// -- 의존성 주입(Dependency Injection, DI) --
	@Autowired
	private SqlSessionTemplate sess; // 커넥션

	//

	// getBoardList() --------------------
	public List<BoardVO> getFreeBoardList() {
		log.info("[BoardDAOImpl - getBoardList()] 요청");
		List<BoardVO> result = sess.selectList("com.example.repository.BoardDAO.getFreeBoardList");
		
		return result;
	} // end of getBoardList()

	//

	// getBoard() --------------------
	@Transactional
	public HashMap getBoard(BoardVO vo) {
		log.info("[BoardDAOImpl - getBoard()] 요청 :" + vo.toString());
		HashMap result = sess.selectOne("com.example.dao.BoardDAO.getBoard", vo);
		sess.update("com.example.dao.BoardDAO.cntUpdate", vo);
		return result;
	}// end of getBoard()

	//

	// saveBoard() --------------------	
	public Integer saveBoard(BoardVO vo) {
		
		log.info("[BoardDAOImpl - saveBoard()] 요청 :" + vo.toString());
		int result = sess.insert("com.example.dao.BoardDAO.saveBoard", vo);

		log.info(result + "행 입력");
		return result;
	}// end of saveBoard()

	//

	// updateBoard() --------------------
	public Integer updateBoard(BoardVO vo) {
		log.info("[BoardDAOImpl - updateBoard()] 요청 :" + vo.toString());
		int result = sess.update("com.example.dao.BoardDAO.updateBoard", vo);
		log.info(result + "행 수정");
		return result;
	}// end of updateBoard()

	//

	// deleteBoard() --------------------
	@Transactional
	public Integer deleteBoard(BoardVO vo) {
		log.info("[BoardDAOImpl - deleteBoard()] 요청 :" + vo.toString());
		sess.delete("com.example.dao.BoardDAO.deleteBoardFile", vo);
		int result = sess.delete("com.example.dao.BoardDAO.deleteBoard", vo);
		
		log.info(result + "행 삭제");
		
		return result;
	}// end of deleteBoard()

	//

	// selectId() --------------------
	public Integer selectId() {
		Integer result = sess.selectOne("com.example.dao.BoardDAO.selectId");
		log.info("[ BoardDAOImpl - selectId() ] " + result);
		return result;
	}// end of selectId()
}
