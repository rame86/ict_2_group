package com.example.repository;

import java.util.List;

import com.example.domain.BoardVO;

public interface BoardDAO {
	public List<BoardVO> getFreeBoardList();
}
