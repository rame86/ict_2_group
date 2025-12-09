package com.example.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;



@Service("replyService")
public class ReplyServiceImpl implements ReplyService{

	@Autowired
	ReplyDAO replyDAO;
	
	@Override
	public Integer insertReply(ReplyVO vo) {
		Integer result = replyDAO.insertReply(vo);		
		return result;
	}

	@Override
	public List<ReplyVO> selectAllReply(Integer bno) {
		
		return replyDAO.selectAllReply(bno);
	}

	@Override
	public Integer deleteReply(Integer rno) {
		
		return replyDAO.deleteReply(rno);
	}
	@Override
	public Integer modifyReply(ReplyVO vo) {
		
		return replyDAO.modifyReply(vo);
	}
	

}
