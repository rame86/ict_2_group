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
	
	@Override
	public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler, Map<String, Object> attributes) throws Exception {
	    
	    if (request instanceof ServletServerHttpRequest) {
	        ServletServerHttpRequest servletRequest = (ServletServerHttpRequest) request;
	        
	        // 1. HTTP 세션 가져오기 (세션이 없으면 새로 만들지 않음)
	        HttpSession session = servletRequest.getServletRequest().getSession(false); 
	        
	        if (session != null) {
	            // 2. 세션에서 "login" 객체 찾기
	        	Object loginObject = session.getAttribute("login");
	            
	            // 💡 (핵심 수정) loginObject가 LoginVO 타입인지 명시적으로 확인합니다.
	            if (loginObject instanceof LoginVO) {
	            	
	            	// 임시 Principal 객체에 저장할 사번 변수
	                final String empNo;
	                
	                // 캐스팅이 보장되므로 try-catch 대신 직접 캐스팅 수행
	                LoginVO loginVO = (LoginVO) loginObject;
	                empNo = loginVO.getEmpNo(); 
	                  
	                if (empNo != null && !empNo.isEmpty()) {
	                    // 4. STOMP 세션에 Principal 객체로 저장 (WebSocket 인증 완료)
	                    attributes.put("user", new Principal() {
	                        @Override
	                        public String getName() {
	                            return empNo.trim();
	                        }
	                    });
	                    System.out.println("WebSocket Handshake 승인: User=" + empNo);
	                    return true;
	                }
	            }
	        }
	    }
	    
	    // 로그인 정보(Principal)가 없거나 추출 실패 시 연결 거부
	    System.out.println("WebSocket Handshake 거부: 로그인 정보(Principal) 없음");
	    return false;
	}

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler, Exception exception) {
        // Handshake 후 처리 로직 (필요하면 추가)
    }
  
}