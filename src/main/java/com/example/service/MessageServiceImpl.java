package com.example.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.domain.EmpVO;
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

	// 선택한 사용자와의 쪽지보기
	@Override
	public List<MessageVO> getChatMessage(String myUserId, String otherUserId) {
		
		Map<String, String> param = new HashMap<>();
		
		param.put("myUserId", myUserId);
		param.put("otherUserId", otherUserId);
		
		return messageDao.selectChatMessages(param);
		
	}

	// 채팅 읽음
	@Override
	public int markAsRead(String myUserId, String otherUserId) {
		
		Map<String, String> param = new HashMap<>();
		
		param.put("myEmpNo", myUserId);
		param.put("otherUserId", otherUserId);
		
		return messageDao.updateIsRead(param);
		
	}

	// 최신5개 메세지
	@Override
	public List<MessageVO> getUnreadMessage(String empNo) {
		return messageDao.selectUnreadMessages(empNo);
	}

	// 사원 검색
	@Override
	public List<EmpVO> getSelectEmpList(String keyword, String empNo) {
		
		Map<String, Object> param = new HashMap<>();
		
		param.put("keyword", keyword);
		param.put("empNo", empNo);
		
		List<EmpVO> empList = messageDao.selectEmpDept(param);
		
		for(EmpVO emp : empList) {
			Integer gradeNo = emp.getGradeNo();
			String gradeName = convertGradeNo(gradeNo);
			emp.setGradeName(gradeName);
		}
		
		return empList;
		
	}
	
	// 변환
	@Override
	public String convertGradeNo(Integer gradeNo) {		
		switch(gradeNo) {
			case 1 : return "최고관리자";
			case 2 : return "관리자";
			case 3 : return "사원";
			case 4 : return "계약사원";
			case 5 : return "인턴/수습";
			case 6 : return "기타";
	        default : return "직책미정";
		}
	}
	
}
