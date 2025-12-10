package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.NoticeBoardVO;
import com.example.repository.BoardDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardDAO boardDAO;

	public List<NoticeBoardVO> getNoticeBoardList() {
		return boardDAO.getNoticeBoardList();
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
}
