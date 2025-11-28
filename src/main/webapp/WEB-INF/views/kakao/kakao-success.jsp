<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 성공</title>
<style>
body {
	padding: 20px;
	font-family: sans-serif;
}

.result-box {
	background-color: #e8f0fe;
	padding: 20px;
	border-radius: 5px;
	border: 1px solid #b8c7e0;
	white-space: pre-wrap;
	word-break: break-all;
}
</style>
</head>
<body>
	<h1>카카오 로그인 성공!</h1>
	<p>카카오 서버에서 받아온 사용자 정보(JSON)입니다:</p>

	<%-- EL을 사용하여 Controller에서 넘겨준 userInfo 모델 속성을 출력 --%>
	<div class="result-box">${userInfo}</div>

	<br>
	<a href="/kakao/logout" style="color: red; font-weight: bold;">[카카오
		로그아웃 및 로컬 세션 삭제]</a>
	<br>
	<a href="/kakao/login">다시 로그인 화면으로</a>
</body>
</html>