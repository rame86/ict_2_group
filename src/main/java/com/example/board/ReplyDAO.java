package com.example.board;

import java.util.List;


public interface ReplyDAO {

	public Integer insertReply(ReplyVO vo);

	public List<ReplyVO> selectAllReply(Integer bno);

	public Integer deleteReply(Integer rno);

	public Integer modifyReply(ReplyVO vo);
}
