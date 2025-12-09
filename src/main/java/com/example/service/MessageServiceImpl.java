package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.domain.MessageVO;
import com.example.repository.MessageDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MessageServiceImpl implements MessageService {
	
	@Autowired
	private MessageDAO messageDao;

	// 쪽지 목록 조회
	@Override
	public List<MessageVO> getConversationList(String empNo) {
		return messageDao.selectMessageList(empNo);
	}

	// 쪽지 보내기
	@Override
	@Transactional
	public int sendMessage(MessageVO vo) {
		return messageDao.insertMessage(vo);
	}
	
}
