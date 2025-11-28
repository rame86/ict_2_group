package com.example.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// 카카오 토큰 발급 요청 시 응답받을 객체
// DB에 토큰 정보를 저장하려면 이 객체의 데이터를 활용하면 됩니다.
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class KakaoTokenInfo {

	// @JsonProperty: 카카오(JSON)는 snake_case, 자바는 camelCase이므로 매핑

	@JsonProperty("access_token")
	private String accessToken; // 사용자 액세스 토큰

	@JsonProperty("token_type")
	private String tokenType; // 토큰 타입 (bearer)

	@JsonProperty("refresh_token")
	private String refreshToken; // 액세스 토큰 갱신용 토큰

	@JsonProperty("expires_in")
	private int expiresIn; // 액세스 토큰 만료 시간(초)

	@JsonProperty("scope")
	private String scope; // 사용자가 동의한 권한 범위

	// 필요하다면 id_token 필드도 추가 가능 (OpenID Connect 사용 시)
	// @JsonProperty("id_token")
	// private String idToken;
}