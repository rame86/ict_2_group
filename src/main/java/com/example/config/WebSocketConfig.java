package com.example.config;

import java.util.Map;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.messaging.SessionConnectEvent;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer{
	
	private final UserPrincipalHandshakeInterceptor handshakeInterceptor;
	
	public WebSocketConfig(UserPrincipalHandshakeInterceptor handshakeInterceptor) {
        this.handshakeInterceptor = handshakeInterceptor;
    }
	
	@Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
		config.enableSimpleBroker("/topic");
        config.setApplicationDestinationPrefixes("/app"); 
        config.setUserDestinationPrefix("/user");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
    	registry.addEndpoint("/ws/stomp")
        .setAllowedOriginPatterns("*") 
        .withSockJS()
        .setSessionCookieNeeded(true) 
        .setInterceptors(this.handshakeInterceptor);
    }
    
}
