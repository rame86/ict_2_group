package com.example.controller;

import java.security.Principal;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.example.domain.AlertVO;
import com.example.domain.LoginVO;
import com.example.domain.MessageVO;
import com.example.service.MessageService;
import com.example.service.NotificationService;

@Controller
public class ChatController {
	
	private final SimpMessagingTemplate messagingTemplate;
    private final MessageService messageService;
    @Autowired
    private NotificationService notificationService;
    
    public ChatController(SimpMessagingTemplate messagingTemplate, MessageService messageService) {
        this.messagingTemplate = messagingTemplate;
        this.messageService = messageService;
    }
    
    private String getChatRoomId(String id1, String id2) {
        String[] ids = new String[]{id1, id2};
        Arrays.sort(ids); // 정렬
        return ids[0] + "_" + ids[1];
    }
   
    // 메세지 보내기
    @MessageMapping("/chat/send")
    public void sendMessage(MessageVO messageVO, SimpMessageHeaderAccessor headerAccessor) { 
        
        String receiverEmpNoStr = messageVO.getReceiverEmpNo();
        String senderEmpNoStr = null;
        
        Map<String, Object> sessionAttributes = headerAccessor.getSessionAttributes();

        if (sessionAttributes != null) {

            senderEmpNoStr = (String) sessionAttributes.get("httpSessionEmpNo");
            
            if (senderEmpNoStr == null || senderEmpNoStr.isEmpty() || senderEmpNoStr.equals("user")) {
                 senderEmpNoStr = (String) sessionAttributes.get("STOMP_SESSION_ID");
            }
            
            if (senderEmpNoStr == null || senderEmpNoStr.isEmpty() || senderEmpNoStr.equals("user")) {
                 Object principalObj = sessionAttributes.get("principal");
                 if (principalObj instanceof Principal) {
                     senderEmpNoStr = ((Principal) principalObj).getName();
                 }
            }
        }
        
        if (senderEmpNoStr == null || senderEmpNoStr.isEmpty() || senderEmpNoStr.equals("user")) {
             System.err.println("❌ ERROR: [최종] STOMP 세션에서 유효한 사용자 ID를 찾을 수 없습니다. (현재 값: " + senderEmpNoStr + ")");
             return;
        }
        
        System.out.println("DEBUG: 최종 발신자 ID: " + senderEmpNoStr + ", 수신자 ID: " + receiverEmpNoStr);

        messageVO.setSenderEmpNo(senderEmpNoStr); 
        messageVO.setReceiverEmpNo(receiverEmpNoStr);

        messageService.sendMessage(messageVO);
        
        String chatRoomId = getChatRoomId(senderEmpNoStr, receiverEmpNoStr); 
        String destination = "/topic/chat/room/" + chatRoomId;
        
        messagingTemplate.convertAndSend(destination, messageVO);
        
        String personalNotificationTopic = "/topic/notifications/" + receiverEmpNoStr;
        messagingTemplate.convertAndSend(personalNotificationTopic, messageVO);
        
        System.out.println("DEBUG: Room Topic 발행 완료: " + destination);
        System.out.println("DEBUG: 개인 알림 발행 완료: " + personalNotificationTopic + "로 직접 발행");
        
    }
    
    // 뱃지
    @PostMapping("/chat/markAsRead")
    @ResponseBody
    public String markMessagesAsRead(@RequestParam String otherUserId, @SessionAttribute("login") LoginVO login) {
    	
    	String myEmpNo = login.getEmpNo();
    	
    	try {
            int updatedRows = messageService.markAsRead(myEmpNo, otherUserId);
            System.out.println("DEBUG: " + myEmpNo + "가 " + otherUserId + "와의 메시지 " + updatedRows + "개를 읽음 처리.");
            return "success";
        } catch (Exception e) {
            System.err.println("ERROR: 읽음 처리 중 DB 오류 발생: " + e.getMessage());
            return "error: DB_UPDATE_FAILED";
        }
    	
    }
    
    // 헤더부분
    @GetMapping("/api/message/latestUnread")
    @ResponseBody
    public List<MessageVO> getUnreadMessage(@SessionAttribute("login") LoginVO login) {
    	List<MessageVO> list = messageService.getUnreadMessage(login.getEmpNo());
    	System.out.println(list.toString());
    	return list;
    }
    
    @GetMapping("/api/alerts/latestDocument")
    @ResponseBody
    public List<AlertVO> getLatestDocument(@SessionAttribute("login") LoginVO login) {
    	return notificationService.getLatestAlert(login.getEmpNo());
    }
    
}
