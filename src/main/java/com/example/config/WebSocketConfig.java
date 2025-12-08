package com.example.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer{
	
	@Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // 1. 서버 -> 클라이언트로 메시지 발송 시 prefix
        // 1:1 알림 메시지를 위한 /user/queue/ 설정
        config.enableSimpleBroker("/topic", "/queue"); 
        
        // 2. 클라이언트 -> 서버로 메시지 발송 시 prefix (Handler로 라우팅)
        config.setApplicationDestinationPrefixes("/app"); 
        
        // 3. 사용자 특정 메시지 라우팅 설정
        config.setUserDestinationPrefix("/user");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
    	registry.addEndpoint("/ws/stomp")
        // 💡 모든 Origin(출처)을 허용하여 CORS 문제 및 세션 쿠키 미전달 문제 방지
        .setAllowedOriginPatterns("*") 
        .withSockJS()
        
        // 💡 (선택 사항) 인증 쿠키를 전송하도록 명시적으로 설정
        .setSessionCookieNeeded(true) 
        
        // 커스텀 인터셉터 유지
        .setInterceptors(new UserPrincipalHandshakeInterceptor());
    }
    
}
