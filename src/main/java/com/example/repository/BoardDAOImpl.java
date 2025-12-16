package com.example.repository;

import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.example.domain.FreeBoardVO;
import com.example.domain.NoticeBoardVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class BoardDAOImpl implements BoardDAO {
	@Autowired
	private SqlSessionTemplate sess; 

	// 공지 목록 조회 (부서번호 추가)
	public List<NoticeBoardVO> getNoticeBoardList(Integer deptNo) {
		log.info("[BoardDAOImpl - getNoticeBoardList()] 요청받음 - deptNo: " + deptNo);
		List<NoticeBoardVO> result = sess.selectList("com.example.repository.BoardDAO.getNoticeBoardList", deptNo);
		return result;
	}

	public String insertNoticeBoard(NoticeBoardVO vo) {
		log.info("[BoardDAOImpl - insertNoticeBoard()] 요청받음");
		String resultString = "";
		Integer result = sess.insert("com.example.repository.BoardDAO.insertNoticeBoard", vo);
		if (result != null) {
			log.info("공지 " + result + "개 입력 완료");
			resultString = String.valueOf(result);
		}
		return resultString;
	};

	public String updateNoticeBoard(NoticeBoardVO vo) {
		log.info("[BoardDAOImpl - updateNoticeBoard()] 요청받음");
		String resultString = "";
		Integer result = sess.update("com.example.repository.BoardDAO.updateNoticeBoard", vo);
		if (result != null) {
			log.info("공지 " + result + "개 수정 완료");
			resultString = String.valueOf(result);
		}
		return resultString;
	};

	public NoticeBoardVO getContentNoticeBoard(String noticeNo) {
		log.info("[BoardDAOImpl - getContentNoticeBoard()] 요청받음");
		NoticeBoardVO result = sess.selectOne("com.example.repository.BoardDAO.getContentNoticeBoard", noticeNo);
		return result;
	}

	public void updateNoticeCnt(String noticeNo) {
		log.info("[BoardDAOImpl - updateNoticeCnt()] 요청받음");
		sess.update("com.example.repository.BoardDAO.updateNoticeCnt", noticeNo);
	}

	// =============================================================

	// 자게 목록 조회 (부서번호 추가)
	public List<FreeBoardVO> getFreeBoardList(Integer deptNo) {
		log.info("[BoardDAOImpl - getFreeBoardList()] 요청받음 - deptNo: " + deptNo);
		List<FreeBoardVO> result = sess.selectList("com.example.repository.BoardDAO.getFreeBoardList", deptNo);
		return result;
	}

	public String insertFreeBoard(FreeBoardVO vo) {
		log.info("[BoardDAOImpl - insertFreeBoard()] 요청받음");
		String resultString = "";
		Integer result = sess.insert("com.example.repository.BoardDAO.insertFreeBoard", vo);
		if (result != null) {
			log.info("자유게시글 " + result + "개 입력 완료");
			resultString = String.valueOf(result);
		}
		return resultString;
	};

	public String updateFreeBoard(FreeBoardVO vo) {
		log.info("[BoardDAOImpl - updateFreeBoard()] 요청받음");
		String resultString = "";
		Integer result = sess.update("com.example.repository.BoardDAO.updateFreeBoard", vo);
		if (result != null) {
			log.info("자유게시글 " + result + "개 수정 완료");
			resultString = String.valueOf(result);
		}
		return resultString;
	};

	public FreeBoardVO getContentFreeBoard(String boardNo) {
		log.info("[BoardDAOImpl - getContentFreeBoard()] 요청받음");
		FreeBoardVO result = sess.selectOne("com.example.repository.BoardDAO.getContentFreeBoard", boardNo);
		return result;
	}

	public void updateFreeBoardCnt(String boardNo) {
		log.info("[BoardDAOImpl - updateFreeBoardCnt()] 요청받음");
		sess.update("com.example.repository.BoardDAO.updateFreeBoardCnt", boardNo);
	}
}