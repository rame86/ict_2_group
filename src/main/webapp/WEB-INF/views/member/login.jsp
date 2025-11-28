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
<link href="css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js"
	crossorigin="anonymous"></script>
</head>
<body class="bg-primary">
	<div id="layoutAuthentication">
		<div id="layoutAuthentication_content">
			<main>
				<div class="container">
					<div class="row justify-content-center">
						<div class="col-lg-5">
							<div class="card shadow-lg border-0 rounded-lg mt-5">
								<div class="card-header">
									<h3 class="text-center font-weight-light my-4">로그인</h3>
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
										<div class="container">

											<%-- Controller의 @GetMapping("/kakao/login") 주소로 요청 --%>
											<a href="/kakao/login"> <img class="kakao-btn"
												src="https://k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg"
												width="222" alt="카카오 로그인 버튼" />
											</a>
										</div>

										<div
											class="d-flex align-items-center justify-content-between mt-4 mb-0">
											<a class="small" href="password.html">비밀번호가 기억나지 않나요?</a> <input
												class="btn btn-primary" type="submit" value="로그인">
										</div>
									</form>
								</div>
								<div class="card-footer text-center py-3">
									<div class="small">
										<a href="register.html">회원가입은 이곳으로 오세요!</a>
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
