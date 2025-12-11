package com.example.repository;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.EmpVO;
import com.example.domain.MessageVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class MessageDAOImpl implements MessageDAO{
	
	@Autowired
	private SqlSessionTemplate sess;
	
	@Override
	public List<MessageVO> selectMessageList(String empNo) {
		return sess.selectList("com.example.repository.MessageDAO.selectMessageList", empNo);
	}

	@Override
	public int insertMessage(MessageVO vo) {
		return sess.insert("com.example.repository.MessageDAO.insertMessage", vo);
	}

	@Override
	public List<MessageVO> selectChatMessages(Map<String, String> param) {
		return sess.selectList("com.example.repository.MessageDAO.selectChatMessages", param);
	}

	@Override
	public int updateIsRead(Map<String, String> param) {
		return sess.update("com.example.repository.MessageDAO.updateIsRead", param);
	}

	@Override
	public List<MessageVO> selectUnreadMessages(String empNo) {
		return sess.selectList("com.example.repository.MessageDAO.selectUnreadMessages", empNo);
	}

	@Override
	public List<EmpVO> selectEmpDept(Map<String, Object> param) {
		return sess.selectList("com.example.repository.MessageDAO.selectEmpDept", param);
	}
	
}
