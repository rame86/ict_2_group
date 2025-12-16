package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.FreeBoardVO;
import com.example.domain.NoticeBoardVO;
import com.example.repository.BoardDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardDAO boardDAO;

	// 공지영역~

	public List<NoticeBoardVO> getNoticeBoardList(Integer deptNo) {
		return boardDAO.getNoticeBoardList(deptNo);
	}

	public String insertNoticeBoard(NoticeBoardVO vo) {
		return boardDAO.insertNoticeBoard(vo);
	};

	public String updateNoticeBoard(NoticeBoardVO vo) {
		return boardDAO.updateNoticeBoard(vo);
	};

	public NoticeBoardVO getContentNoticeBoard(String noticeNo) {
		// 게시글 카운트 증가~
		boardDAO.updateNoticeCnt(noticeNo);
		return boardDAO.getContentNoticeBoard(noticeNo);
	}

	//=======================
	// 자게영역~

	public List<FreeBoardVO> getFreeBoardList(Integer deptNo) {
		return boardDAO.getFreeBoardList(deptNo);

	}

		public String insertFreeBoard(FreeBoardVO vo) {
		return boardDAO.insertFreeBoard(vo);
	};

   	public String updateFreeBoard(FreeBoardVO vo) {
		return boardDAO.updateFreeBoard(vo);
	};

	public FreeBoardVO getContentFreeBoard(String boardNo) {
		// 게시글 카운트 올리기~
		boardDAO.updateFreeBoardCnt(boardNo);
		return boardDAO.getContentFreeBoard(boardNo);
	}
}