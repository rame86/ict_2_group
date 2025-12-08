package com.example.service;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@Service
public class NotificationService {
	
	// STOMP 메시지 브로커로 메시지를 보내는 핵심 컴포넌트
    private final SimpMessagingTemplate messagingTemplate;
    
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
    	
    	System.out.println("DEBUG: NotificationService 시작!"); // 👈 새 로그
        // 메시지 보낼 구독 주소: /user/{empNo}/queue/notifications
        // 여기서 '/queue/notifications'는 임의로 정한 알림 큐 이름입니다.
    	String destination = "/queue/notifications";
        
        try {
        	messagingTemplate.convertAndSendToUser(empNo, destination, message);
            System.out.println("DEBUG: 메시지 전송 API 호출 성공."); // 👈 새 로그
        } catch (Exception e) {
            e.printStackTrace(); // 👈 예외 발생 시 콘솔에 무조건 찍히게 처리
        }
        
        System.out.println("알림 발송 완료: 대상=" + empNo + ", 내용=" + message);
    }

}
