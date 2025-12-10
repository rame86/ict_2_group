package com.example.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.BoardVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class BoardDAOImpl implements BoardDAO {
	@Autowired
	private SqlSessionTemplate sess; // 커넥션

	public List<BoardVO> getFreeBoardList() {
		log.info("[BoardDAOImpl - getBoardList()] 요청");
		List<BoardVO> result = sess.selectList("com.example.repository.BoardDAO.getFreeBoardList");

		return result;
	}

}
