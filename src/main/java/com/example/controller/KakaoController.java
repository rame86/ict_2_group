package com.example.controller;

import com.example.service.KakaoService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/kakao")
@RequiredArgsConstructor
public class KakaoController {

    private final KakaoService kakaoService;

    @Value("${kakao.rest-api-key}")
    private String kakaoRestApiKey;

    @Value("${kakao.redirect-uri}")
    private String kakaoRedirectUri;

    @Value("${kakao.logout-redirect-uri}")
    private String kakaoLogoutRedirectUri;
    
    //
    
    @GetMapping("/page")
    public String loginPage() {
        return "/kakao/login"; 
    }


    @GetMapping("/login")
    public String kakaoLogin() {
        String authUrl = "https://kauth.kakao.com/oauth/authorize" 
                + "?client_id=" + kakaoRestApiKey 
                + "&redirect_uri=" + kakaoRedirectUri 
                + "&response_type=code";                
        
        return "redirect:" + authUrl;
    }

    @GetMapping("/callback")
    public String kakaoCallback(@RequestParam String code, HttpSession session) {
        try {
            String userInfo = kakaoService.getUserInfo(code);
            
            // 세션에 저장해야 로그아웃 전까지 유지됨
            session.setAttribute("userInfo", userInfo);
            
            return "/kakao/kakao-success";

        } catch (Exception e) {
            e.printStackTrace();
            return "/kakao/kakao-fail";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        // 1. 내 서버 세션 삭제
        session.invalidate();
        
     // 2. 카카오 로그아웃 URL 생성 (설정값 사용)
        String logoutUrl = "https://kauth.kakao.com/oauth/logout"
                + "?client_id=" + kakaoRestApiKey
                + "&logout_redirect_uri=" + kakaoLogoutRedirectUri; // 설정값 사용

        return "redirect:" + logoutUrl;
    }
}