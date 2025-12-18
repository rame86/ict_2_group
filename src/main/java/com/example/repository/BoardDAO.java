package com.example.repository;

import java.util.List;
import com.example.domain.FreeBoardVO;
import com.example.domain.NoticeBoardVO;
import com.example.domain.ReplyVO;

public interface BoardDAO {

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

	public void updateNoticeCnt(String noticeNo);

	public String insertFreeBoard(FreeBoardVO vo);

	public String updateFreeBoard(FreeBoardVO vo);

	public FreeBoardVO getContentFreeBoard(String boardNo);

	public void updateFreeBoardCnt(String boardNo);

	// 댓글 관련
	int insertReply(ReplyVO vo);

	List<ReplyVO> getReplyList(ReplyVO vo); // boardNo 또는 noticeNo로 조회

	int updateReply(ReplyVO vo);

	int deleteReply(Long replyNo);
}