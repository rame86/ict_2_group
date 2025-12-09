package com.example.repository;

import java.util.List;

import com.example.domain.MessageVO;

public interface MessageDAO {
	List<MessageVO> selectMessageList(String empNo);
	int insertMessage(MessageVO vo);
}
