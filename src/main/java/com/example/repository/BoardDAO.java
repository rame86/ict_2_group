package com.example.repository;

import java.util.List;

import com.example.domain.NoticeBoardVO;

public interface BoardDAO {
	public List<NoticeBoardVO> getNoticeBoardList();
	
	public String insertNoticeBoard(NoticeBoardVO vo);
	
	public String updateNoticeBoard(NoticeBoardVO vo);
}
