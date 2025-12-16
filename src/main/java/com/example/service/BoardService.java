package com.example.service;

import java.util.List;

import com.example.domain.FreeBoardVO;
import com.example.domain.NoticeBoardVO;

public interface BoardService {
	// 공지영역

	public List<NoticeBoardVO> getNoticeBoardList(Integer deptNo);

	public String insertNoticeBoard(NoticeBoardVO vo);

	public String updateNoticeBoard(NoticeBoardVO vo);

	public NoticeBoardVO getContentNoticeBoard(String noticeNo);

	// 자게 영역

	public List<FreeBoardVO> getFreeBoardList(Integer deptNo);

	public String insertFreeBoard(FreeBoardVO vo);

	public String updateFreeBoard(FreeBoardVO vo);

	public FreeBoardVO getContentFreeBoard(String boardNo);
}
