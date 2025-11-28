package com.example.service;

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

    // Builder 대신 만들어둔 WebClient를 직접 주입받음 (오류 해결)
    private final WebClient webClient;
    
    @Value("${kakao.rest-api-key}")
    private String kakaoRestApiKey;

    @Value("${kakao.redirect-uri}")
    private String kakaoRedirectUri;
    
    // 기본값 주입이 안될 수 있으니 직접 URL 명시
    private final String KAKAO_TOKEN_URL = "https://kauth.kakao.com/oauth/token";
    private final String KAKAO_USER_INFO_URL = "https://kapi.kakao.com/v2/user/me";

    
    public String getUserInfo(String code) {
        String accessToken = getAccessToken(code);
        return getUserInfoWithToken(accessToken);
    }

    private String getAccessToken(String code) {
        String tokenRequestBody = "grant_type=authorization_code" +
                                  "&client_id=" + kakaoRestApiKey +
                                  "&redirect_uri=" + kakaoRedirectUri +
                                  "&code=" + code;

        String response = webClient.post()
                .uri(KAKAO_TOKEN_URL)
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .bodyValue(tokenRequestBody)
                .retrieve()
                .bodyToMono(String.class)
                .block();

        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode rootNode = mapper.readTree(response);
            return rootNode.get("access_token").asText();
        } catch (Exception e) {
            throw new RuntimeException("토큰 파싱 실패", e);
        }
    }

    private String getUserInfoWithToken(String accessToken) {
        return webClient.get()
                .uri(KAKAO_USER_INFO_URL)
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken)
                .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
                .retrieve()
                .bodyToMono(String.class)
                .block();
    }
}