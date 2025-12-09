package com.example.service;

import java.util.List;

import com.example.domain.MessageVO;

public interface MessageService {
	List<MessageVO> getConversationList(String empNo);
	int sendMessage(MessageVO vo);
}
