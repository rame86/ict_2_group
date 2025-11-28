package com.example.service;

import com.example.domain.KakaoUserVO;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

@Slf4j
@Service
@RequiredArgsConstructor
public class KakaoService {

    // WebClient를 직접 주입받아 사용 (Builder 대신)
    private final WebClient webClient;
    
    // application.yml 또는 properties에서 REST API 키 주입
    @Value("${kakao.rest-api-key}")
    private String kakaoRestApiKey;

    // application.yml 또는 properties에서 Redirect URI 주입
    @Value("${kakao.redirect-uri}")
    private String kakaoRedirectUri;
    
    // 카카오 토큰 발급 요청 URL
    private final String KAKAO_TOKEN_URL = "https://kauth.kakao.com/oauth/token";
    // 카카오 사용자 정보 요청 URL
    private final String KAKAO_USER_INFO_URL = "https://kapi.kakao.com/v2/user/me";

    
    // 인가 코드(code)를 받아 사용자 정보를 반환하는 메서드
    public KakaoUserVO getUserInfo(String code) {
        String accessToken = getAccessToken(code); // 액세스 토큰 발급
        return getUserInfoVOWithToken(accessToken); // KakaoUserVO 객체로 사용자 정보 조회
    }

    // 인가 코드를 이용해 액세스 토큰 발급
    private String getAccessToken(String code) {
        // 토큰 요청에 필요한 파라미터 구성
        String tokenRequestBody = "grant_type=authorization_code" +
                                  "&client_id=" + kakaoRestApiKey +
                                  "&redirect_uri=" + kakaoRedirectUri +
                                  "&code=" + code;

        // WebClient를 이용해 카카오 서버에 POST 요청
        String response = webClient.post()
                .uri(KAKAO_TOKEN_URL)
                .contentType(MediaType.APPLICATION_FORM_URLENCODED) // 폼 데이터 전송
                .bodyValue(tokenRequestBody) // 요청 바디 설정
                .retrieve() // 응답 수신
                .bodyToMono(String.class) // 응답을 String으로 변환
                .block(); // 동기적으로 결과 대기

        try {
            // 응답 JSON 파싱
            ObjectMapper mapper = new ObjectMapper();
            JsonNode rootNode = mapper.readTree(response);
            // access_token 추출
            return rootNode.get("access_token").asText();
        } catch (Exception e) {
            // 파싱 실패 시 예외 발생
            throw new RuntimeException("토큰 파싱 실패", e);
        }
    }

    // 액세스 토큰을 이용해 사용자 정보 조회
    private KakaoUserVO getUserInfoVOWithToken(String accessToken) {
        // bodyToMono의 반환 타입을 String.class에서 KakaoUserVO.class로 변경
        return webClient.get()
                .uri(KAKAO_USER_INFO_URL) // 사용자 정보 요청 URL
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken) // 인증 헤더 추가
				.retrieve() // 응답 수신
                .bodyToMono(KakaoUserVO.class) // <--- 핵심 변경: DTO 클래스로 직접 변환
                .block(); // 동기적으로 결과 대기
    }
}