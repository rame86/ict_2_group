package com.example.config;

import java.security.Principal;
import java.util.Map;

import jakarta.servlet.http.HttpSession; 

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import com.example.domain.LoginVO;

@Component
public class UserPrincipalHandshakeInterceptor implements HandshakeInterceptor {

	// UserPrincipalHandshakeInterceptor.java (SimplePrincipal 사용 최종 버전)
	// import com.example.config.SimplePrincipal; 경로에 맞게 SimplePrincipal 클래스를 import 해주세요.

	@Override
	public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, 
	                               WebSocketHandler wsHandler, Map<String, Object> attributes) throws Exception {	
	    
	    boolean principalCreated = false;

	    if (request instanceof ServletServerHttpRequest) {
	        ServletServerHttpRequest servletRequest = (ServletServerHttpRequest) request;
	        
	        // 세션을 새로 만들지 않고 기존 세션이 있는지 확인 (false)
	        HttpSession session = servletRequest.getServletRequest().getSession(false);
	        
	        if (session == null) {
	            System.out.println("DEBUG: 1. HttpSession을 찾을 수 없음 (쿠키 누락 가능성 높음)");
	        } else {
	            System.out.println("DEBUG: 2. HttpSession 찾음. 속성 확인 중...");
	            
	            Object loginObject = session.getAttribute("login");
	            
	            if (loginObject == null) {
	                System.out.println("DEBUG: 3. 세션은 있으나 'login' 속성이 null입니다.");
	            } else if (loginObject instanceof LoginVO) {
	                
	                LoginVO loginVO = (LoginVO) loginObject;
	                final String empNo = loginVO.getEmpNo(); 
	                
	                if (empNo != null && !empNo.isEmpty()) {
	                    
	                    Principal simplePrincipal = new SimplePrincipal(empNo.trim());
	                    
	                    attributes.put("principal", simplePrincipal);
	                    attributes.put("user", simplePrincipal);
	                    attributes.put("httpSessionEmpNo", empNo.trim());
	                    attributes.put("STOMP_SESSION_ID", empNo.trim());
	                    
	                    principalCreated = true;
	                    System.out.println("DEBUG: 4. SimplePrincipal/user 등록 성공! empNo: " + empNo);
	                } else {
	                    System.out.println("DEBUG: 5. empNo가 null이거나 비어있어 Principal 생성 실패.");
	                }
	            } else {
	                System.out.println("DEBUG: 6. 'login' 객체가 LoginVO 타입이 아닙니다. 저장 타입 확인 필요.");
	            }
	        }
	    }
	    
	    if (principalCreated) {
	        return true; 
	    } else {
	        System.out.println("WebSocket Handshake 거부: 로그인 정보(Principal) 없음");
	        return false; 
	    }
	}

	@Override
	public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler, Exception exception) {
		// Handshake 후 처리 로직 (필요하면 추가)
	}

}