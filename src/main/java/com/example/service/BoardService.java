package com.example.service;

import java.util.List;

import com.example.domain.NoticeBoardVO;

public interface BoardService {
	public List<NoticeBoardVO> getNoticeBoardList();

	public String insertNoticeBoard(NoticeBoardVO vo);

	public String updateNoticeBoard(NoticeBoardVO vo);
}
