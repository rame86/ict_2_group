package com.example.domain;

import java.util.Date;

import lombok.Data;

@Data
public class MessageVO {
	private int msgNo; 
    private String senderEmpNo; 
    private String receiverEmpNo;
    private String msgContent;
    private Date sendDate; 
    private String isRead;
    private String receiverDelYn; 
    private String senderDelYn;

    // 편의사항
    private String senderName; // 보낸 사람 이름
    private String receiverName; // 받은 사람 이름
    
    // 대화목록 조회 시 사용할 필드
    private String otherUserId; // 상대방 사번
    private String otherUserName; // 상대방 이름
    private String otherUserPosition; // 상대방 직책 또는 부서명
    private String latestMessageContent; // 최근 메시지 내용 (MSG_CONTENT와 중복될 수 있음)
    private Date latestMessageTime; // 최근 메시지 시간 (SEND_DATE와 중복될 수 있음)
    private int unreadCount; // 미확인 메시지 개수
}
