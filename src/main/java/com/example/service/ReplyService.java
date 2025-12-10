package com.example.service;

import java.util.List;

import com.example.domain.ReplyVO;



public interface ReplyService {

	// 댓글 추가
	Integer insertReply(ReplyVO vo);

	// 댓글 목록보기
	public List<ReplyVO> selectAllReply(Integer bno);
	
	// 댓글 삭제
	public Integer deleteReply(Integer rno);
	
	// 댓글 수정
	public Integer modifyReply(ReplyVO vo);
}
