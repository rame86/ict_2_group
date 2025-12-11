package com.example.repository;

import java.util.List;
import java.util.Map;

import com.example.domain.EmpVO;
import com.example.domain.MessageVO;

public interface MessageDAO {
	List<MessageVO> selectMessageList(String empNo);
	int insertMessage(MessageVO vo);
	List<MessageVO> selectChatMessages(Map<String, String> param);
	int updateIsRead(Map<String, String> param);
	List<MessageVO> selectUnreadMessages(String empNo);
	List<EmpVO> selectEmpDept(Map<String, Object> param);
}
