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
<title>사원 계정 등록</title>
<link href="/css/styles.css" rel="stylesheet" />
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js"
	crossorigin="anonymous"></script>
<script src="/js/member.js"></script>
<style type="text/css">
/* button[disabled] 선택자를 사용하여 비활성화된 상태를 정의합니다. */
#submitBtn:disabled {
	/* 투명도를 50%로 설정하여 연하게 보이게 합니다. */
	opacity: 0.5;
	/* (선택 사항) 커서를 not-allowed로 변경하여 클릭 불가임을 시각적으로 나타냅니다. */
	cursor: not-allowed;
}


/* --- 로그인 페이지 스타일 복사 시작 --- */

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

/* 새로 추가: 제목 스타일 정의 및 마진 제거 (기존 h3 대체) */
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

/* 5. 입력 필드 (사원번호, 비밀번호 등) 스타일 변경 */
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

/* ⭐ 포커스 시 입력 필드 밑줄 색상 변경: 분홍색 계열(#e85a6a) */
.form-control:focus {
	background-color: transparent !important;
	color: #ffffff !important;
	border-color: #e85a6a; /* 요청하신 분홍색 계열로 변경 */
	box-shadow: none !important; /* 포커스 아웃라인 제거 */
}

/* 6. 체크박스 라벨 색상 (회원가입 페이지에는 없지만 스타일 유지) */
.form-check-label {
	color: #aaaaaa; /* 라벨 텍스트 밝은 회색 */
}

/* 7. 카카오 로그인 버튼 관련 스타일 제거됨 */


/* 8. 일반 로그인/회원가입 버튼 (분홍색 계열 유지) */
.btn-primary { 
    background-color: #e85a6a !important; /* 분홍색 계열 버튼 */
    border-color: #e85a6a !important;
    color: #ffffff !important;
    font-weight: bold;
    padding: 10px 20px; 
    border-radius: 8px; 
    
    /* 일반 버튼도 가로 전체로 확장 */
    width: 100%;
    height: 50px;
}

.btn-primary:hover {
	background-color: #d14656 !important; /* 호버 시 색상 변경 */
	border-color: #d14656 !important;
}

/* 9. 카드 푸터 (로그인 링크 영역) 스타일 */
.card-footer {
	background-color: transparent !important; /* 배경 투명하게 */
	border-top: 1px solid #eeeeee79; /* 위쪽 경계선 */
	padding: 15px 0; /* 상하 패딩 추가 */
	text-align: center;
}

.card-footer .small a { /* 로그인 링크 색상 변경 */
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

/* 컨테이너 외곽선 (#aabbccee) 스타일 적용을 위한 컨테이너 */
#outer-container {
    /* RGBA로 변경하여 흐릿한 효과 적용 (흰색에 40% 투명도) */
    border: 0.3px solid #eeeeee24; 
    
    padding: 15px;    
    margin-top: 50px; 
}

/* 추가: 사번확인/이름 입력 필드 레이아웃 조정을 위한 스타일 */
.col-md-6 .form-floating {
    margin-bottom: 0; /* form-floating의 기본 마진 제거 */
}

/* 사번확인 버튼과 결과 영역 스타일 (흰색 텍스트로 변경) */
#empNoCheck, #empNoCheckResult {
    color: #ffffff;
    font-size: 0.85rem;
}

#empNoCheck {
    background-color: #18181822;
    border: 1px solid #1717171e;
    border-radius: 5px;
    padding: 5px 10px;
    cursor: pointer;
    margin-top: 5px;
}

#empNoCheck:hover {
    background-color: #777777;
}

#empNoCheckResult {
    display: inline-block;
    padding-left: 10px;
}

/* 비밀번호 확인 결과 영역 스타일 */
#passCheck {
    color: #ffffff;
    font-size: 0.85rem;
    padding-left: 5px;
}

.row.mb-3 {
    margin-bottom: 20px !important; /* 행 간격 확보 */
}

/* 사원 ID(type="number") 스피너 버튼 숨기기 */
/* Chrome, Safari, Edge, Opera */
input[type=number]::-webkit-inner-spin-button,
input[type=number]::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
}
/* Firefox */
input[type=number] {
    -moz-appearance: textfield;
}


</style>


</head>
<body class="bg-primary">
	<div id="layoutAuthentication">
		<div id="layoutAuthentication_content">
			<main>
				<div class="container">
					<div class="row justify-content-center">
						<div class="col-lg-7">
                            <%-- #aabbccee 외곽선 컨테이너 역할 --%>
                            <div id="outer-container">
							<div class="card shadow-lg border-0 rounded-lg mt-0"> 
								<div class="card-header">
									<%-- 기존 h3 대신 people-cync-title 클래스 사용 --%>
									<div class="text-center people-cync-title">사원 계정 등록</div> 
								</div>
								<div class="card-body">									

									<%-- 기존 회원가입 폼 시작 --%>
									<form id='registForm' action='/member/memberSave' method='post'>
										<div class="row mb-3">
											<div class="col-md-6">
												<div class="form-floating mb-3 mb-md-0">
													<input class="form-control" id="empNo" name="empNo"
														type="number" placeholder="사원번호를 입력하세요" required /> <label
														for="inputFirstName">사원ID(사원번호)</label>
												</div>
                                                <button id='empNoCheck' type="button" class="mt-2 mb-3" tabindex="-1">사번확인</button>
											</div>
											<div class="col-md-6">
												<div class="form-floating">
													<input class="form-control" id="empName" name="empName"
														type="text" placeholder="이름을 입력하세요" required /> <label
														for="inputLastName">이름</label>
                                                    <span id="empNoCheckResult" class="mt-2 mb-3"></span>
												</div>
											</div>
										</div>
										<div class="form-floating mb-3" id="empEmailDiv">
											<input class="form-control" id="empEmail" name="empEmail"
												type="email" placeholder="name@example.com" required /> <label
												for="inputEmail">이메일주소</label>
										</div>
										<div class="row mb-3">
											<div class="col-md-6">
												<div class="form-floating mb-3 mb-md-0">
													<input class="form-control" id="empPass" name="empPass"
														type="password" placeholder="Create a password" required />
													<label for="inputPassword">비밀번호</label>
												</div>
											</div>
											<div class="col-md-6">
												<div class="form-floating mb-3 mb-md-0">
													<input class="form-control" id="empPassConfirm"
														type="password" placeholder="Confirm password" required />
													<label for="inputPasswordConfirm">비밀번호 확인</label>
                                                    <span id="passCheck" class="mt-2 mb-3"></span>
												</div>

											</div>
										</div>
										<div class="mt-4 mb-4">
											<div class="d-grid">
												<button class="btn btn-primary btn-block" type="submit"
													id="submitBtn" disabled>회원가입</button>
											</div>
										</div>
									</form>
								</div>
								<%-- 푸터 영역 추가 --%>
								<div class="card-footer text-center py-3">
									<div class="small">
										<a href="/">이미 계정이 있으신가요? 로그인 하세요!</a>
									</div>
								</div>
							</div>
                            </div> <%-- #outer-container 닫는 태그 --%>
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
						<div class="text-muted">Copyright &copy; Your Website 2023</div>
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
	<script src="../js/scripts.js"></script>
</body>
</html>