package com.example.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.NoticeBoardVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class BoardDAOImpl implements BoardDAO {
	@Autowired
	private SqlSessionTemplate sess; // 커넥션

	public List<NoticeBoardVO> getNoticeBoardList() {
		log.info("[BoardDAOImpl - getNoticeBoardList()] 요청받음");
		List<NoticeBoardVO> result = sess.selectList("com.example.repository.BoardDAO.getNoticeBoardList");

		return result;
	}

	public String insertNoticeBoard(NoticeBoardVO vo) {
		log.info("[BoardDAOImpl - insertNoticeBoard()] 요청받음");
		String resultString = "";
		Integer result = sess.insert("com.example.repository.BoardDAO.insertNoticeBoard", vo);
		if (result != null) {			
			log.info("공지 " + result+"개 입력 완료");
			resultString = String.valueOf(result);
		} 
		
		return resultString;

	};

	public String updateNoticeBoard(NoticeBoardVO vo) {
		log.info("[BoardDAOImpl - insertNoticeBoard()] 요청받음");
		String resultString = "";
		Integer result = sess.insert("com.example.repository.BoardDAO.updateNoticeBoard", vo);
		if (result != null) {			
			log.info("공지 " + result+"개 수정 완료");
			resultString = String.valueOf(result);
		} 
		
		return resultString;
		
	};

}
