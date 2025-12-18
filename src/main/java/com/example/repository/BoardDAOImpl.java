package com.example.repository;

import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.FreeBoardVO;
import com.example.domain.NoticeBoardVO;
import com.example.domain.ReplyVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class BoardDAOImpl implements BoardDAO {

	@Autowired
	private SqlSessionTemplate sess;

	// 1. 전체 조회
	public List<NoticeBoardVO> getGlobalNoticeList() {
		return sess.selectList("com.example.repository.BoardDAO.getGlobalNoticeList");
	}

	public List<FreeBoardVO> getGlobalFreeBoardList() {
		return sess.selectList("com.example.repository.BoardDAO.getGlobalFreeBoardList");
	}

	// 2. 부서별 조회 (계층형)
	public List<NoticeBoardVO> getDeptNoticeList(Integer deptNo) {
		return sess.selectList("com.example.repository.BoardDAO.getDeptNoticeList", deptNo);
	}

	public List<FreeBoardVO> getDeptFreeBoardList(Integer deptNo) {
		return sess.selectList("com.example.repository.BoardDAO.getDeptFreeBoardList", deptNo);
	}

	// CRUD 구현
	public String insertNoticeBoard(NoticeBoardVO vo) {
		int result = sess.insert("com.example.repository.BoardDAO.insertNoticeBoard", vo);
		return String.valueOf(result);
	}

	public String updateNoticeBoard(NoticeBoardVO vo) {
		int result = sess.update("com.example.repository.BoardDAO.updateNoticeBoard", vo);
		return String.valueOf(result);
	}

	public NoticeBoardVO getContentNoticeBoard(String noticeNo) {
		return sess.selectOne("com.example.repository.BoardDAO.getContentNoticeBoard", noticeNo);
	}

	public void updateNoticeCnt(String noticeNo) {
		sess.update("com.example.repository.BoardDAO.updateNoticeCnt", noticeNo);
	}

	public String insertFreeBoard(FreeBoardVO vo) {
		int result = sess.insert("com.example.repository.BoardDAO.insertFreeBoard", vo);
		return String.valueOf(result);
	}

	public String updateFreeBoard(FreeBoardVO vo) {
		int result = sess.update("com.example.repository.BoardDAO.updateFreeBoard", vo);
		return String.valueOf(result);
	}

	public FreeBoardVO getContentFreeBoard(String boardNo) {
		return sess.selectOne("com.example.repository.BoardDAO.getContentFreeBoard", boardNo);
	}

	public void updateFreeBoardCnt(String boardNo) {
		sess.update("com.example.repository.BoardDAO.updateFreeBoardCnt", boardNo);
	}
	
	// 댓글 등록
		@Override
		public int insertReply(ReplyVO vo) {
			// MyBatis 매퍼의 insertReply SQL을 실행합니다.
			return sess.insert("com.example.repository.BoardDAO.insertReply", vo);
		}

		// 댓글 목록 조회 (게시글 번호 또는 공지사항 번호에 따름)
		@Override
		public List<ReplyVO> getReplyList(ReplyVO vo) {
			// 파라미터로 넘어온 vo 내의 boardNo 또는 noticeNo를 조건으로 조회합니다.
			return sess.selectList("com.example.repository.BoardDAO.getReplyList", vo);
		}

		// 댓글 수정
		@Override
		public int updateReply(ReplyVO vo) {
			// 본인 확인을 위해 XML에서 작성자 사번(replyWriterEmpno)도 조건에 포함하는 것을 권장합니다.
			return sess.update("com.example.repository.BoardDAO.updateReply", vo);
		}

		// 댓글 삭제
		@Override
		public int deleteReply(Long replyNo) {
			// PK인 replyNo를 기준으로 삭제를 수행합니다.
			return sess.delete("com.example.repository.BoardDAO.deleteReply", replyNo);
		}
}