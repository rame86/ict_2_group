<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원관리</title>

<!-- 공통 헤더 -->
<jsp:include page="../common/header.jsp" />

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- DataTables CSS/JS -->
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css">
<script
	src="https://cdn.datatables.net/1.13.5/js/jquery.dataTables.min.js"></script>

<!-- ================================
     🔥 empList.jsp 전용 스타일 (추후 분리 예정)
     ================================ -->
<style>

/* 🔹 페이지 전체 여백 */
.content-wrapper {
	padding: 24px 32px;
}

/* 🔹 상단 제목 영역 */
.page-header {
	margin-bottom: 12px;
}

/* 🔹 제목 글자 */
.page-title {
	font-size: 22px;
	font-weight: 600;
}

/* 🔹 검색창 영역 (제목 아래 + 오른쪽 정렬) */
.search-area {
	width: 100%;
	text-align: right;
	margin-bottom: 8px; /* 검색창 ↔ 표 간격 */
}

/* 🔹 검색창 내부 form (inline-flex → 오른쪽에 딱 맞게 붙음) */
.search-area form {
	display: inline-flex;
	gap: 8px;
	align-items: center;
}

/* 🔹 검색 입력창 */
.search-area input[type="text"] {
	width: 220px;
	padding: 6px 10px;
	border: 1px solid #ccc;
	border-radius: 16px;
	outline: none;
}

/* 🔹 검색 버튼 */
.search-area button {
	padding: 6px 16px;
	border: none;
	border-radius: 16px;
	background-color: #3b82f6;
	color: #fff;
	font-weight: 600;
	cursor: pointer;
}

.search-area button:hover {
	opacity: 0.9;
}

/* ================================
   🔹 테이블 카드 영역
   ================================ */
.emp-card {
	background-color: #ffffff; /* 급여관리랑 맞추려고 살짝 더 밝게 */
	border-radius: 12px;
	padding: 12px 20px;
	box-shadow: 0 1px 4px rgba(15, 23, 42, 0.06); /* 부드러운 그림자 */
}

/* ================================
   🔹 테이블 기본 스타일
   ================================ */
.emp-table {
	width: 100%;
	border-collapse: separate; /* 선을 최소화하기 위한 설정 */
	border-spacing: 0;
	font-size: 14px;
}

/* 헤더 영역 – 아래쪽 한 줄만 강조 */
.emp-table thead {
	border-bottom: 1px solid #e5e7eb;
}

.emp-table th {
	padding: 10px 8px;
	font-weight: 600;
	text-align: left;
	color: #374151; /* 진한 회색 */
	background-color: #f9fafb; /* 아주 연한 회색 배경 */
}

/* 본문 영역 – 가로줄만 은은하게 */
.emp-table td {
	padding: 9px 8px;
	color: #111827;
	border-top: 1px solid #f3f4f6; /* 얇은 위쪽 선만 */
}

/* 첫 번째 데이터 행은 위 선 제거해서 자연스럽게 */
.emp-table tbody tr:first-child td {
	border-top: none;
}

/* 마우스 오버 시 배경 강조 (급여관리 테이블과 유사 느낌) */
.emp-table tbody tr:hover {
	background-color: #f1f5f9; /* 아주 연한 파란 톤 */
}

/* 행 간 간격을 살짝 띄우고 싶다면(선이 너무 많아 보일 때) */
/*
.emp-table tbody tr {
    border-bottom: 0;               // 기본 선 제거
}
.emp-table tbody tr + tr td {
    border-top: 1px solid #f3f4f6;  // 행과 행 사이에만 선
}
*/

/* 데이터 없을 때 행 */
.emp-empty-row td {
	text-align: center;
	padding: 20px 0;
	color: #9ca3af;
	border-top: none;
}

/* ================================
   🔹 페이지네이션 (기존과 비슷하게 유지)
   ================================ */
.emp-pagination-container {
	margin-top: 12px;
	display: flex;
	justify-content: center;
}

.emp-pagination-container .paginate_button {
	padding: 4px 10px;
	border-radius: 12px;
	border: none !important;
	background: transparent;
}

.emp-pagination-container .paginate_button.current {
	background-color: #2563eb !important;
	color: #fff !important;
}

.emp-pagination-container .paginate_button:hover:not(.current) {
	background-color: #e5e7eb !important;
}

/* ================================
   🔥 카드 밖에 표시되는 페이지네이션
   ================================ */
.emp-pagination-container {
	margin-top: 12px;
	display: flex;
	justify-content: center; /* 🔥 가운데 정렬 */
}

.emp-pagination-container .paginate_button {
	padding: 4px 10px;
	border-radius: 12px;
	border: none !important;
}

/* 🔹 선택된 페이지 버튼 */
.emp-pagination-container .paginate_button.current {
	background-color: #3b82f6 !important;
	color: #fff !important;
}
</style>

<!-- ================================
     🔥 empList 전용 스크립트
     ================================ -->
<script>
$(document).ready(function () {

    /* ------------------------------------
       1) DataTables 기본 설정
       ------------------------------------ */
    const table = $('#empTable').DataTable({
        pageLength: 10,
        lengthChange: false,
        info: false,
        searching: true,
        ordering: true,
        order: [[0, 'asc'], [1, 'asc'], [2, 'asc']], 
        dom: 't<"dt-bottom"p>', 

        language: {
            "zeroRecords": "일치하는 사원이 없습니다.",
            "paginate": {
                "first": "처음",
                "last": "마지막",
                "next": "다음",
                "previous": "이전"
            }
        }
    });

    /* ------------------------------------
       2) 페이지네이션을 카드 밖으로 이동
       ------------------------------------ */
    const pagination = $('#empTable_wrapper .dt-bottom');
    $('.emp-pagination-container').append(pagination);

    /* ------------------------------------
       3) 상단 검색창 → DataTables 검색 연동
       ------------------------------------ */
    $('.emp-search-form').on('submit', function (e) {
        e.preventDefault();
        const keyword = $.trim($('input[name="keyword"]').val());
        table.search(keyword).draw();
    });

});
</script>

</head>

<body>

	<div id="layoutSidenav">

		<!-- 사이드바 -->
		<jsp:include page="../common/sidebar.jsp" />

		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid px-4">

					<div class="content-wrapper">

						<!-- 🔹 페이지 제목 -->
						<div class="page-header">
							<div class="page-title">사원 목록</div>
						</div>

						<!-- 🔹 검색창 -->
						<div class="search-area">
							<form class="emp-search-form">
								<input type="text" name="keyword"
									placeholder="이름 / 부서 / 직급 / 사번 검색">
								<button type="submit">SEARCH</button>
							</form>
						</div>

						<!-- 🔹 사원 목록 테이블 -->
						<div class="emp-card">
							<table id="empTable" class="emp-table">
								<thead>
									<tr>
										<th>부서명</th>
										<th>직급</th>
										<th>이름</th>
										<th>사원번호</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="emp" items="${empList}">
										<tr>
											<td>${emp.deptName}</td>
											<td>${emp.gradeName}</td>
											<td>${emp.empName}</td>
											<td>${emp.empNo}</td>
										</tr>
									</c:forEach>

									<c:if test="${empty empList}">
										<tr class="emp-empty-row">
											<td colspan="4">조회된 사원 정보가 없습니다.</td>
										</tr>
									</c:if>
								</tbody>
							</table>
						</div>

						<!-- 🔹 카드 밖 페이지네이션 -->
						<div class="emp-pagination-container"></div>

					</div>

					<!-- 푸터 -->
					<jsp:include page="../common/footer.jsp" />

				</div>
			</main>
		</div>

	</div>

</body>
</html>
