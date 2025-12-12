<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<title>로그인</title>
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js"
	crossorigin="anonymous"></script>
<style type="text/css">
/* 제공된 이미지(카카오 로그인)와 유사한 디자인을 위해 CSS를 수정합니다. */

/* 1. 전체 배경을 검은색으로 변경 */
body.bg-primary {
	background-color: #121212 !important; /* 순수한 검은색 */
}

/* 2. 카드(로그인 폼 영역) 스타일 변경 */
.card {
	background-color: transparent !important; /* 배경 투명하게 (전체 배경과 동일하게) */
	
	/* 외곽선은 #aabbccee가 담당하도록 border는 흰색 3px로 유지 */
	border: 1px solid #eeeeee24; 
	
	border-radius: 0 !important; /* 모서리 둥글게 제거하여 직각 유지 */
	/* 그림자 제거 */
	box-shadow: none !important;
}

/* 3. 카드 헤더 (제목 영역) 스타일 */
.card-header {
	background-color: transparent !important; /* 배경 투명하게 */
	/* 상단 여백 최소화를 위해 padding-top 0 적용 */
	padding-top: 0 !important; 
	border-bottom: 1px solid #eeeeee79; /* 아래쪽 경계선 */
	padding-bottom: 20px; /* 제목과 입력 필드 사이 간격 확보 */
}

/* 새로 추가: 제목 스타일 정의 및 마진 제거 */
.people-cync-title { 
    color: #ffffff !important;
    font-weight: 300; /* h3 font-weight-light에 해당 */
    font-size: 1.75rem; /* h3 기본 크기에 해당 */
    text-align: center;
    /* h3의 기본 마진과 부트스트랩 my-4 마진 모두 제거 */
    margin: 0 !important; 
    padding: 20px 0 0 0; /* 테두리와 제목 사이 원하는 상단 여백 (20px) */
}

/* 4. 카드 바디 (입력 폼 영역) 스타일 */
.card-body {
	padding-top: 20px;
	padding-bottom: 5px;
}

/* 5. 입력 필드 (사원번호, 비밀번호) 스타일 변경 */
.form-floating label {
	color: #aaaaaa !important; /* 라벨 텍스트 밝은 회색 */
}

.form-control {
	background-color: transparent !important; /* 입력 필드 배경 투명하게 */
	color: #ffffff !important; /* 입력된 텍스트 색상 흰색 */
	border: none; /* 기본 테두리 제거 */
	border-bottom: 1px solid #555555; /* 아래쪽 테두리만 남김 */
	border-radius: 0; /* 모서리 둥글게 제거 */
	padding-left: 0; /* 왼쪽 패딩 제거 */
}

/* ⭐ 포커스 시 입력 필드 밑줄 색상 변경: 노란색(#fee500) -> 분홍색 계열(#e85a6a) */
.form-control:focus {
	background-color: transparent !important;
	color: #ffffff !important;
	border-color: #e85a6a; /* 요청하신 분홍색 계열로 변경 */
	box-shadow: none !important; /* 포커스 아웃라인 제거 */
}

/* 6. 체크박스 라벨 색상 */
.form-check-label {
	color: #aaaaaa; /* 라벨 텍스트 밝은 회색 */
}

/* 7. 카카오 로그인 버튼 (노란색 유지) */
.kakao-login-btn {
	display: flex;
	justify-content: center;
	align-items: center;
	width: 100%;
	height: 50px; 
	/* 카카오 노란색 */
	background-color: #fee500; 
	color: #3c1e1e; 
	font-weight: bold;
	font-size: 1.1rem; 
	border: none;
	border-radius: 8px;
	text-decoration: none;
	margin-top: 30px; 
	margin-bottom: 20px;
	cursor: pointer;
}

/* 8. 일반 로그인 버튼 (분홍색 계열 유지) */
.btn-primary { 
    background-color: #e85a6a !important; /* 분홍색 계열 버튼 */
    border-color: #e85a6a !important;
    color: #ffffff !important;
    font-weight: bold;
    padding: 10px 20px; 
    border-radius: 8px; 
    
    /* ⭐ 일반 로그인 버튼을 카카오 버튼처럼 가로 전체로 확장 */
    width: 100%;
    height: 50px;
}

.btn-primary:hover {
	background-color: #d14656 !important; /* 호버 시 색상 변경 */
	border-color: #d14656 !important;
}

.small { /* 하단 텍스트(비밀번호 분실 시) 색상 변경 */
	color: #aaaaaa !important;
}

/* 9. 카드 푸터 (회원가입 링크 영역) 스타일 */
.card-footer {
	background-color: transparent !important; /* 배경 투명하게 */
	border-top: 1px solid #eeeeee79; /* 위쪽 경계선 */
}

.card-footer .small a { /* 회원가입 링크 색상 변경 */
	color: #aaaaaa !important;
	text-decoration: none;
}

.card-footer .small a:hover {
	color: #ffffff !important;
}

/* 부트스트랩 form-floating 라벨 위치 조정 */
.form-floating>.form-control:focus ~ label, .form-floating>.form-control:not(:placeholder-shown) 
	~ label, .form-floating>.form-select ~ label {
	transform: scale(0.85) translateY(-0.5rem) translateX(0);
}
/* 컨테이너 외곽선 (#aabbccee) 스타일 */
#aabbccee {
    /* RGBA로 변경하여 흐릿한 효과 적용 (흰색에 40% 투명도) */
    border: 0.3px solid #eeeeee24; 
    
    padding: 15px;    
    margin-top: 50px; 
}

</style>
</head>
<body class="bg-primary">
	<div id="layoutAuthentication">
		<div id="layoutAuthentication_content">
			<main>
				<div class="container">
					<div class="row justify-content-center">
						<div class="col-lg-5">
						<div id="aabbccee">
							<div class="card shadow-lg border-0 rounded-lg mt-0">
								<div class="card-header">
									<%-- ⭐ Flash Attribute로 전달된 errorMessage 확인 및 출력 --%>
									<c:if test="${not empty errorMessage}">
										<div class="alert alert-danger" role="alert">
											<h5 class="alert-heading">오류 발생</h5>

											<hr>
											<p class="mb-0">로그인을 다시 시도해 주십시오.</p>
										</div>
									</c:if>
									<div class="text-center people-cync-title">PEOPLE CYNC 로그인</div>
								</div>
								<div class="card-body">
									<form action="loginCheck" method="post">
										<div class="form-floating mb-3">
											<input class="form-control" id="inputEmpno" type="text"
												placeholder="name@example.com" name="empNo" /> <label
												for="inputEmpno">사원번호</label>
										</div>
										<div class="form-floating mb-3">
											<input class="form-control" id="inputPassword"
												type="password" placeholder="Password" name="empPass" /> <label
												for="inputPassword">비밀번호</label>
										</div>
										<div class="form-check mb-3">
											<input class="form-check-input" id="inputRememberPassword"
												type="checkbox" value="" /> <label class="form-check-label"
												for="inputRememberPassword">비밀번호 기억</label>
										</div>

										<div class="mt-4 mb-3">
											<input class="btn btn-primary" type="submit" value="로그인">
										</div>
										
										<a href="/kakao/login" class="kakao-login-btn"> <i
											class="fas fa-comment"></i>&nbsp; 카카오 로그인
										</a>


										<div class="d-flex align-items-center justify-content-center mt-4 mb-0">
											<span class="small">비밀번호 분실 시 관리자에게 문의하세요.</span> 
										</div>
									</form>
								</div>
								<div class="card-footer text-center py-3">
									<div class="small">
										<a href="/member/register">회원가입은 이곳으로 오세요!</a>
									</div>
								</div>
							</div>
							</div>
						</div>
					</div>
				</div>
			</main>
		</div>
		<div id="layoutAuthentication_footer">
			<footer class="py-4 bg-light mt-auto">
				<div class="container-fluid px-4">
					<div
						class="d-flex align-items-center justify-content-between small">
						<div class="text-muted">Copyright &copy; 환희상회 2023</div>
						<div>
							<a href="#">Privacy Policy</a> &middot; <a href="#">Terms
								&amp; Conditions</a>
						</div>
					</div>
				</div>
			</footer>
		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
		crossorigin="anonymous"></script>
	<script src="js/scripts.js"></script>
</body>
</html>