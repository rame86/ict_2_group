<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<title>로그인</title>

<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> 

<style type="text/css">
    /* ==========================================================================
       [공통 스타일] 폰트 및 공통 요소 (BODY 폰트 규칙 삭제됨)
       ========================================================================== */
    
    /* 카카오 로그인 버튼 */
    .kakao-login-btn {
        display: flex; justify-content: center; align-items: center;
        width: 100%; height: 50px;
        background-color: #fee500; color: #3c1e1e;
        font-weight: bold; font-size: 1.1rem;
        border: none; border-radius: 8px; text-decoration: none;
        margin-top: 30px; margin-bottom: 20px; cursor: pointer;
    }

    /* 로그인 버튼 */
    .btn-primary {
        background-color: #e85a6a !important; border-color: #e85a6a !important;
        color: #ffffff !important; font-weight: bold;
        padding: 10px 20px; border-radius: 8px;
        width: 100%; height: 50px;
    }
    .btn-primary:hover {
        background-color: #d14656 !important; border-color: #d14656 !important;
    }

    /* 부트스트랩 form-floating 라벨 위치 조정 */
    .form-floating>.form-control:focus ~ label, 
    .form-floating>.form-control:not(:placeholder-shown) ~ label, 
    .form-floating>.form-select ~ label {
        transform: scale(0.85) translateY(-0.5rem) translateX(0);
    }

    /* 외곽 컨테이너 레이아웃 */
    #aabbccee {
        padding: 15px; margin-top: 50px;
    }


    /* ==========================================================================
       [라이트 모드] (기본 / Default)
       ========================================================================== */
    
    /* 1. 배경 */
    body.bg-primary {
        background-color: #f2f3f5 !important; 
    }

    /* 2. 카드 */
    .card {
        background-color: #ffffff !important;
        border: 1px solid #e3e6f0; 
        border-radius: 0 !important; 
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15) !important; 
    }

    /* 3. 헤더 */
    .card-header {
        background-color: transparent !important;
        padding-top: 0 !important; padding-bottom: 20px;
        border-bottom: 1px solid #e3e6f0;
    }
    
    /* ⭐ 타이틀: Jua 폰트 적용 (라이트 모드) */
    .people-cync-title {
        font-family: 'Jua', sans-serif !important; /* Jua 폰트 */
        color: #4e4e4e !important;
        font-weight: 300; font-size: 1.75rem; text-align: center;
        margin: 0 !important; padding: 20px 0 0 0;
    }

    /* 4. 바디 */
    .card-body { padding-top: 20px; padding-bottom: 5px; }

    /* 5. 입력 필드 */
    .form-floating label { color: #888 !important; }
    .form-control {
        background-color: #fff !important; color: #333 !important;
        border: 1px solid #ced4da; 
        border-radius: 0; 
        padding-left: 12px; 
    }
    .form-control:focus {
        background-color: #fff !important; color: #333 !important;
        border-color: #e85a6a; 
        box-shadow: 0 0 0 0.25rem rgba(232, 90, 106, 0.25) !important;
    }

    /* 6. 기타 텍스트 */
    .form-check-label { color: #666; }
    .small { color: #888 !important; }

    /* 7. 푸터 */
    .card-footer {
        background-color: transparent !important;
        border-top: 1px solid #e3e6f0;
    }
    .card-footer .small a { color: #888 !important; text-decoration: none; }
    .card-footer .small a:hover { color: #e85a6a !important; }

    /* 8. 외곽 컨테이너 */
    #aabbccee { border: none; }


    /* ==========================================================================
       [다크 모드] (시스템 설정 감지 @media)
       ========================================================================== */
    @media (prefers-color-scheme: dark) {
        
        /* 1. 배경 */
        body.bg-primary { background-color: #121212 !important; }

        /* 2. 카드 */
        .card {
            background-color: transparent !important;
            border: 1px solid #eeeeee24; 
            border-radius: 0 !important;
            box-shadow: none !important;
        }

        /* 3. 헤더 */
        .card-header {
            background-color: transparent !important;
            padding-top: 0 !important; padding-bottom: 20px;
            border-bottom: 1px solid #eeeeee79;
        }
        
        /* ⭐ 타이틀: Jua 폰트 적용 (다크 모드) */
        .people-cync-title { 
            font-family: 'Jua', sans-serif !important; /* Jua 폰트 */
            color: #ffffff !important; 
        }

        /* 5. 입력 필드 */
        .form-floating label { color: #aaaaaa !important; }
        .form-control {
            background-color: transparent !important;
            color: #ffffff !important;
            border: none; border-bottom: 1px solid #555555;
            border-radius: 0; padding-left: 0; 
        }
        .form-control:focus {
            background-color: transparent !important;
            color: #ffffff !important;
            border-color: #e85a6a; box-shadow: none !important;
        }

        /* 6. 기타 텍스트 */
        .form-check-label { color: #aaaaaa; }
        .small { color: #aaaaaa !important; }

        /* 7. 푸터 */
        .card-footer {
            background-color: transparent !important;
            border-top: 1px solid #eeeeee79;
        }
        .card-footer .small a { color: #aaaaaa !important; }
        .card-footer .small a:hover { color: #ffffff !important; }

        /* 8. 외곽 컨테이너 */
        #aabbccee { border: 0.3px solid #eeeeee24; }
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
										<div class="text-center people-cync-title">PEOPLE CYNC</div>
									</div>
									<div class="card-body">
										<form action="loginCheck" method="post">
											<div class="form-floating mb-3">
												<input class="form-control" id="inputEmpno" type="text" placeholder="name@example.com" name="empNo" /> <label for="inputEmpno">사원번호</label>
											</div>
											<div class="form-floating mb-3">
												<input class="form-control" id="inputPassword" type="password" placeholder="Password" name="empPass" /> <label for="inputPassword">비밀번호</label>
											</div>
											<div class="form-check mb-3">
												<input class="form-check-input" id="inputRememberPassword" type="checkbox" value="" /> <label class="form-check-label" for="inputRememberPassword">비밀번호 기억</label>
											</div>

											<div class="mt-4 mb-3">
												<input class="btn btn-primary" type="submit" value="로그인">
											</div>

											<a href="/kakao/login" class="kakao-login-btn"> <i class="fas fa-comment"></i>&nbsp;
												카카오 로그인
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
			<jsp:include page="../common/footer.jsp" flush="true" />
		</div>
	</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="js/scripts.js"></script>
</body>
</html>