package com.example.board;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository("replyDAO")
public class ReplyDAOImpl implements ReplyDAO {
	@Autowired
	private SqlSessionTemplate sess;

	public Integer insertReply(ReplyVO vo) {
		log.info("ReplyDAOImpl - insertReply() 호출");
		return sess.insert("ReplyDAO.insertReply", vo);
	}

	public List<ReplyVO> selectAllReply(Integer bno) {
		log.info("ReplyDAOImpl - selectAllReply() 호출");
		return sess.selectList("ReplyDAO.selectAllReply", bno);
	}

	@Override
	public Integer deleteReply(Integer rno) {
		log.info("ReplyDAOImpl - deleteReply() 호출");
		return sess.delete("ReplyDAO.deleteReply", rno);
	}

	@Override
	public Integer modifyReply(ReplyVO vo) {
		log.info("ReplyDAOImpl - modifyReply() 호출");
		return sess.update("ReplyDAO.modifyReply", vo);
	}

}
