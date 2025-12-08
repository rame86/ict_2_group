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
	       
	        HttpSession session = servletRequest.getServletRequest().getSession(false); 
	        
	        if (session != null) {
	        	
	        	Object loginObject = session.getAttribute("login");
	            
	            if (loginObject instanceof LoginVO) {
	            	
	                final String empNo;
	                
	                LoginVO loginVO = (LoginVO) loginObject;
	                empNo = loginVO.getEmpNo(); 
	                  
	                if (empNo != null && !empNo.isEmpty()) {
	                    attributes.put("user", new Principal() {
	                        @Override
	                        public String getName() {
	                            return empNo.trim();
	                        }
	                    });
	                    return true;
	                }
	                
	            }
	            
	        }
	        
	    }
	    
	    System.out.println("WebSocket Handshake 거부: 로그인 정보(Principal) 없음");
	    return false;
	    
	}

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler, Exception exception) {
        // Handshake 후 처리 로직 (필요하면 추가)
    }
  
}