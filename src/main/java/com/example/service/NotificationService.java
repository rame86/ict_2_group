package com.example.service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.example.domain.AlertVO;
import com.example.domain.ApproveListVO;

import com.example.repository.ApproveDAO;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class NotificationService {
	
	@Autowired
	private ApproveDAO approveDao;
	
	// STOMP 메시지 브로커로 메시지를 보내는 핵심 컴포넌트
    private final SimpMessagingTemplate messagingTemplate;
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    // 생성자 주입
    public NotificationService(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }
    
    /**
     * 특정 사용자에게 결재 알림을 보냅니다.
     * @param empNo 알림을 받을 사원 번호
     * @param message 알림 내용
     */
    public void sendApprovalNotification(String empNo, String message) {
    	
    	Map<String, String> payload = new HashMap<>();
        
    	payload.put("targetEmpNo", empNo); 
        payload.put("content", message);
        
        String jsonMessage;
        try {
            jsonMessage = objectMapper.writeValueAsString(payload); // Map -> JSON 문자열
        } catch (Exception e) {
            jsonMessage = "{\"targetEmpNo\":\"" + empNo + "\", \"content\":\"" + message + "\"}";
        }
        
        // 브로드 캐스팅
        String destination = "/topic/global-notifications";
        try {
        	messagingTemplate.convertAndSend(destination, jsonMessage);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    
    public void pushNewAlert(AlertVO alert) {
    	
    	String destination = "/topic/notifications/" + alert.getEmpNo();
    	
    	Map<String, Object> payload = new HashMap<>();
    	
    	payload.put("action", "REFRESH_HEADER_ALERTS");
    	payload.put("content", "새로운 알람이 도착했습니다.");
    	
    	messagingTemplate.convertAndSend(destination, payload);
    	
    }

}
