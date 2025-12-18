package com.example.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.FreeBoardVO;
import com.example.domain.NoticeBoardVO;
import com.example.domain.ReplyVO;
import com.example.repository.BoardDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardDAO boardDAO;

	// 1. 전체 조회
	public List<NoticeBoardVO> getGlobalNoticeList() {
		return boardDAO.getGlobalNoticeList();
	}

	public List<FreeBoardVO> getGlobalFreeBoardList() {
		return boardDAO.getGlobalFreeBoardList();
	}

	// 2. 부서별 조회 (계층형)
	public List<NoticeBoardVO> getDeptNoticeList(Integer deptNo) {
		return boardDAO.getDeptNoticeList(deptNo);
	}

	public List<FreeBoardVO> getDeptFreeBoardList(Integer deptNo) {
		return boardDAO.getDeptFreeBoardList(deptNo);
	}

	// CRUD
	public String insertNoticeBoard(NoticeBoardVO vo) {
		return boardDAO.insertNoticeBoard(vo);
	}

	public String updateNoticeBoard(NoticeBoardVO vo) {
		return boardDAO.updateNoticeBoard(vo);
	}

	public NoticeBoardVO getContentNoticeBoard(String noticeNo) {
		boardDAO.updateNoticeCnt(noticeNo);
		return boardDAO.getContentNoticeBoard(noticeNo);
	}

	public String insertFreeBoard(FreeBoardVO vo) {
		return boardDAO.insertFreeBoard(vo);
	}

	public String updateFreeBoard(FreeBoardVO vo) {
		return boardDAO.updateFreeBoard(vo);
	}

	public FreeBoardVO getContentFreeBoard(String boardNo) {
		boardDAO.updateFreeBoardCnt(boardNo);
		return boardDAO.getContentFreeBoard(boardNo);
	}

	// 댓글 CRUD
	public int insertReply(ReplyVO vo) {
		return boardDAO.insertReply(vo);
	}

	public List<ReplyVO> getReplyList(ReplyVO vo) {
		return boardDAO.getReplyList(vo);
	}

	public int updateReply(ReplyVO vo) {
		return boardDAO.updateReply(vo);
	}

	public int deleteReply(Long replyNo) {
		return boardDAO.deleteReply(replyNo);
	}

	public void deleteNoticeBoard(String noticeNo) {
		boardDAO.deleteNoticeBoard(noticeNo);
	}

	public void deleteFreeBoard(String boardNo) {
		boardDAO.deleteFreeBoard(boardNo);
	}

	// 0보다 크면 true
	public boolean checkGlobalWriteAuth(String empNo) {
        return boardDAO.checkGlobalWriteAuth(empNo) > 0;
    }

}