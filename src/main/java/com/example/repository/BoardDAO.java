package com.example.repository;

import java.util.List;

import com.example.domain.FreeBoardVO;
import com.example.domain.NoticeBoardVO;

public interface BoardDAO {

	// 공지
	public List<NoticeBoardVO> getNoticeBoardList();

	public String insertNoticeBoard(NoticeBoardVO vo);

	public String updateNoticeBoard(NoticeBoardVO vo);

	public NoticeBoardVO getContentNoticeBoard(String noticeNo);

	public void updateNoticeCnt(String noticeNo);

	// 자게
	public List<FreeBoardVO> getFreeBoardList();

	public String insertFreeBoard(FreeBoardVO vo);

	public String updateFreeBoard(FreeBoardVO vo);

	public FreeBoardVO getContentFreeBoard(String boardNo);

	public void updateFreeBoardCnt(String boardNo);
}
