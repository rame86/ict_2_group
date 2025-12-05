<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 등록</title>

<jsp:include page="../common/header.jsp" />

<!-- 필요하면 별도 CSS 연결 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/empNew.css">

</head>
<body>

	<div id="layoutSidenav">
		<jsp:include page="../common/sidebar.jsp" />

		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid px-4">

					<h2 class="mt-4">사원 등록</h2>
					<div class="emp-new-wrapper">
						<form id="empNewForm">

							<!-- 상단 3열: PHOTO / 왼쪽 입력 / 오른쪽 입력 -->
							<div class="form-top">

								<!-- PHOTO -->
								<div class="photo-box">PHOTO</div>

								<!-- 왼쪽 입력 -->
								<div>
									<div class="form-group">
										<label class="form-label">사번</label> <input type="text"
											name="empNo" class="form-control">
									</div>

									<div class="form-group">
										<label class="form-label">권한등급 (1~5)</label> <select
											name="gradeNo" class="form-select">
											<option value="1">1 - 최고관리자</option>
											<option value="2">2 - 관리자</option>
											<option value="3">3 - 정규직</option>
											<option value="4">4 - 계약직</option>
											<option value="5">5 - 인턴</option>
										</select>
									</div>
								</div>

								<!-- 오른쪽 입력 -->
								<div>
									<div class="form-group">
										<label class="form-label">이름</label> <input type="text"
											name="empName" class="form-control">
									</div>

									<div class="form-group">
										<label class="form-label">재직상태</label> <select name="statusNo"
											class="form-select">
											<option value="1">재직</option>
											<option value="4">대기</option>
											<option value="5">징계</option>
											<option value="6">인턴/수습</option>
											<option value="0">퇴직</option>
										</select>
									</div>
								</div>

							</div>
							<!-- /.form-top -->

							<!-- 하단 전체 폭 입력 -->
							<div class="full-width">
								<label class="form-label">연락처</label> <input type="text"
									name="empPhone" class="form-control">
							</div>

							<div class="full-width">
								<label class="form-label">이메일</label> <input type="email"
									name="empEmail" class="form-control">
							</div>

							<div class="full-width">
								<label class="form-label">주소</label> <input type="text"
									name="empAddr" class="form-control">
							</div>

							<div class="full-width">
								<label class="form-label">부서번호</label> <input type="text"
									name="deptNo" class="form-control">
							</div>

							<!-- 버튼 -->
							<div class="button-area">
								<button type="button" id="btnSave" class="btn btn-primary">저장</button>
								<a href="${pageContext.request.contextPath}/emp/list"
									class="btn btn-secondary">목록으로</a>
							</div>

						</form>



					</div>
			</main>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script>
		// 🔹 Ajax로 /emp/insert 호출 (update/delete와 방식 통일)
		$("#btnSave")
				.click(
						function() {
							let formData = $("#empNewForm").serialize();

							$
									.post(
											"${pageContext.request.contextPath}/emp/insert",
											formData,
											function(result) {
												if (result === "OK") {
													alert("사원 등록이 완료되었습니다.");
													location.href = "${pageContext.request.contextPath}/emp/list";
												} else if (result === "DENY") {
													alert("사원 등록 권한이 없습니다.");
												} else {
													alert("사원 등록 중 오류가 발생했습니다.");
												}
											});
						});
	</script>
	</div>
</body>
</html>
