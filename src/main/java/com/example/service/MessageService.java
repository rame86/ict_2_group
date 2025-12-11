package com.example.service;

import java.util.List;

import com.example.domain.EmpVO;
import com.example.domain.MessageVO;

public interface MessageService {
	List<MessageVO> getConversationList(String empNo);
	int sendMessage(MessageVO vo);
	List<MessageVO> getChatMessage(String myUserId, String otherUserId);
	int markAsRead(String myUserId, String otherUserId);
	List<MessageVO> getUnreadMessage(String empNo);
	List<EmpVO> getSelectEmpList(String keyword, String empNo);
	String convertGradeNo(Integer gradeNo);
}
