package com.example.repository;

import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.FreeBoardVO;
import com.example.domain.NoticeBoardVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class BoardDAOImpl implements BoardDAO {

	@Autowired
	private SqlSessionTemplate sess;

	// 1. 전체 조회
	public List<NoticeBoardVO> getGlobalNoticeList() {
		return sess.selectList("com.example.repository.BoardDAO.getGlobalNoticeList");
	}

	public List<FreeBoardVO> getGlobalFreeBoardList() {
		return sess.selectList("com.example.repository.BoardDAO.getGlobalFreeBoardList");
	}

	// 2. 부서별 조회 (계층형)
	public List<NoticeBoardVO> getDeptNoticeList(Integer deptNo) {
		return sess.selectList("com.example.repository.BoardDAO.getDeptNoticeList", deptNo);
	}

	public List<FreeBoardVO> getDeptFreeBoardList(Integer deptNo) {
		return sess.selectList("com.example.repository.BoardDAO.getDeptFreeBoardList", deptNo);
	}

	// CRUD 구현
	public String insertNoticeBoard(NoticeBoardVO vo) {
		int result = sess.insert("com.example.repository.BoardDAO.insertNoticeBoard", vo);
		return String.valueOf(result);
	}

	public String updateNoticeBoard(NoticeBoardVO vo) {
		int result = sess.update("com.example.repository.BoardDAO.updateNoticeBoard", vo);
		return String.valueOf(result);
	}

	public NoticeBoardVO getContentNoticeBoard(String noticeNo) {
		return sess.selectOne("com.example.repository.BoardDAO.getContentNoticeBoard", noticeNo);
	}

	public void updateNoticeCnt(String noticeNo) {
		sess.update("com.example.repository.BoardDAO.updateNoticeCnt", noticeNo);
	}

	public String insertFreeBoard(FreeBoardVO vo) {
		int result = sess.insert("com.example.repository.BoardDAO.insertFreeBoard", vo);
		return String.valueOf(result);
	}

	public String updateFreeBoard(FreeBoardVO vo) {
		int result = sess.update("com.example.repository.BoardDAO.updateFreeBoard", vo);
		return String.valueOf(result);
	}

	public FreeBoardVO getContentFreeBoard(String boardNo) {
		return sess.selectOne("com.example.repository.BoardDAO.getContentFreeBoard", boardNo);
	}

	public void updateFreeBoardCnt(String boardNo) {
		sess.update("com.example.repository.BoardDAO.updateFreeBoardCnt", boardNo);
	}
}