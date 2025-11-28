package com.example.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class KakaoUserVO {
    // 최상위 필드
    private String id; // 카카오 회원번호

    @JsonProperty("connected_at")
    private String connectedAt;

    // 중첩 구조 1: 사용자 지정 프로퍼티 (사용자 ID 외 임시 저장 정보)
    private Properties properties;

    // 중첩 구조 2: 카카오 계정 정보
    @JsonProperty("kakao_account")
    private KakaoAccount kakaoAccount;

    // --- 중첩 클래스 정의 ---

    @Data
    public static class Properties {
        private String nickname;
        @JsonProperty("profile_image")
        private String profileImage;
        @JsonProperty("thumbnail_image")
        private String thumbnailImage;
    }

    @Data
    public static class KakaoAccount {
        // 동의 항목 관련 필드는 생략하고, 프로필 정보만 캡처
        private Profile profile;

        @Data
        public static class Profile {
            private String nickname;
            @JsonProperty("thumbnail_image_url")
            private String thumbnailImageUrl;
            @JsonProperty("profile_image_url")
            private String profileImageUrl;
        }
    }
}