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
</style>


</head>
<body class="bg-primary">
	<div id="layoutAuthentication">
		<div id="layoutAuthentication_content">
			<main>
				<div class="container">
					<div class="row justify-content-center">
						<div class="col-lg-7">
							<div class="card shadow-lg border-0 rounded-lg mt-5">
								<div class="card-header">
									<h3 class="text-center font-weight-light my-4">사원 계정 등록</h3>
								</div>
								<div class="card-body">									

									<%-- 기존 회원가입 폼 시작 --%>

									<form id='registForm' action='/member/memberSave' method='post'>
										<div class="row mb-3">
											<div class="col-md-6">
												<div class="form-floating mb-3 mb-md-0">
													<input class="form-control" id="empNo" name="empNo"
														type="number" placeholder="사원번호를 입력하세요" required /> <label
														for="inputFirstName">사원ID(사원번호)</label><br>
													<button id='empNoCheck' type="button">사번확인</button>
												</div>
											</div>
											<div class="col-md-6">
												<div class="form-floating">
													<input class="form-control" id="empName" name="empName"
														type="text" placeholder="이름을 입력하세요" required /> <label
														for="inputLastName">이름</label><br>
													<span id="empNoCheckResult" style="width: 150px;"></span>


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
													<label for="inputPasswordConfirm">비밀번호 확인</label> <br>
													<span id="passCheck" style="width: 150px;"></span>
												</div>

											</div>
										</div>
										<div class="mt-4 mb-0">
											<div class="d-grid">
												<button class="btn btn-primary btn-block" type="submit"
													id="submitBtn" disabled>회원가입</button>
											</div>
										</div>
									</form>
								</div>
								<div class="card-footer text-center py-3">
									<div class="small">
										<a href="login.html">아이디가 있나요? 로그인하러 가기</a> <br> <a
											href="/kakao/logout" style="color: red; font-weight: bold;">[카카오
											로그아웃 및 로컬 세션 삭제]</a>
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
