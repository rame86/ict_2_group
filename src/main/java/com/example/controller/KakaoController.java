package com.example.controller;

import com.example.domain.KakaoUserVO;
import com.example.domain.LoginVO;
import com.example.domain.MemberVO;
import com.example.service.KakaoService;
import com.example.service.MemberService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class KakaoController {

    @Autowired
    private KakaoService kakaoService;
    @Autowired
    private MemberService memberService;
    
    
    // application.properties
    // REST API 키 주입
    @Value("${kakao.rest-api-key}")
    private String kakaoRestApiKey;

    // Redirect URI 주입
    @Value("${kakao.redirect-uri}")
    private String kakaoRedirectUri;

    // 로그아웃 후 리다이렉트 URI 주입
    @Value("${kakao.logout-redirect-uri}")
    private String kakaoLogoutRedirectUri;
    
//    // 로그인 페이지 이동
//    @GetMapping("/kakao/login")
//    public String loginPage() {
//        return "/kakao/login";  // 뷰 반환
//    }

    // 카카오 로그인 요청 (인가 코드 발급을 위한 URL로 리다이렉트)
    @GetMapping("/kakao/login")
    public String kakaoLogin() {
        log.info("[KakaoController - /kakao/login] 요청");
    	// 카카오 인증 URL 생성
        String authUrl = "https://kauth.kakao.com/oauth/authorize" 
                + "?client_id=" + kakaoRestApiKey 
                + "&redirect_uri=" + kakaoRedirectUri 
                + "&response_type=code";                
        
        // 카카오 인증 페이지로 리다이렉트
        return "redirect:" + authUrl;
    }

    // 카카오 로그인 콜백 처리 (인가 코드 수신)
    @GetMapping("/kakao/callback")
    public String kakaoCallback(@RequestParam String code, HttpSession session, MemberVO vo) {
    	log.info("[KakaoController - /kakao/callback] 요청");
    	
    	try {
            // 1. 인가 코드로 KakaoUserVO 객체 전체를 조회
            KakaoUserVO kakaoUserVO = kakaoService.getUserInfo(code);
            
            // 2. VO 객체에서 고유 식별자(id) 값만 추출
            String kakaoId = kakaoUserVO.getId();
            
            // 3. 추출한 ID 값을 세션에 저장
            // DAO에 전달할 인자(Long)이 아닌 세션 저장용 String으로 변환하여 저장
            session.setAttribute("kakaoId", String.valueOf(kakaoId));
            
            log.info("로그인 한 사람의 kakaoId 값 : "+kakaoId.toString());
            
            // (DAO 저장이 필요하다면, 여기서 DAO를 호출하는 Service 메서드를 추가 호출)
            String memberCheckResult = memberService.memberCheck(kakaoId);
            
            log.info("해당 kakaoId로 검색결과 : "+memberCheckResult.toString());
            
            if(memberCheckResult != null && memberCheckResult.equals(kakaoId)) {
            	LoginVO loginInfo = memberService.kakaoLoginInfo(kakaoId);
            	session.setAttribute("login", loginInfo);
    			log.info("로그인 성공" + loginInfo.toString());
    			return "index";
            }
            else {
            	 return "/member/register";
            }
            
            // 성공 페이지 반환
            

        } catch (Exception e) {
            e.printStackTrace();
            // 실패 페이지 반환
            return "/kakao/kakao-fail";
        }
    }
    

    // 카카오 로그아웃 처리
    @GetMapping("/kakao/logout")
    public String logout(HttpSession session) {
        // 1. 내 서버 세션 무효화
        session.invalidate();
        
        // 2. 카카오 로그아웃 URL 생성
        String logoutUrl = "https://kauth.kakao.com/oauth/logout"
                + "?client_id=" + kakaoRestApiKey
                + "&logout_redirect_uri=" + kakaoLogoutRedirectUri; // 설정값 사용

        // 카카오 로그아웃 페이지로 리다이렉트
        return "redirect:" + logoutUrl;
    }
}