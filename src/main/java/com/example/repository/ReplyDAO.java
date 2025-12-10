package com.example.repository;

import java.util.List;

import com.example.domain.ReplyVO;


public interface ReplyDAO {

	public Integer insertReply(ReplyVO vo);

	public List<ReplyVO> selectAllReply(Integer bno);

	public Integer deleteReply(Integer rno);

	public Integer modifyReply(ReplyVO vo);
}
