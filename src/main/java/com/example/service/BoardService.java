package com.example.service;

import java.util.List;
import com.example.domain.FreeBoardVO;
import com.example.domain.NoticeBoardVO;

public interface BoardService {
	// 전체 조회
	public List<NoticeBoardVO> getGlobalNoticeList();

	public List<FreeBoardVO> getGlobalFreeBoardList();

	// 부서별 조회
	public List<NoticeBoardVO> getDeptNoticeList(Integer deptNo);

	public List<FreeBoardVO> getDeptFreeBoardList(Integer deptNo);

	// CRUD
	public String insertNoticeBoard(NoticeBoardVO vo);

	public String updateNoticeBoard(NoticeBoardVO vo);

	public NoticeBoardVO getContentNoticeBoard(String noticeNo);

	public String insertFreeBoard(FreeBoardVO vo);

	public String updateFreeBoard(FreeBoardVO vo);

	public FreeBoardVO getContentFreeBoard(String boardNo);
}