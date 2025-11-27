<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    request.setAttribute("menu", "salemp");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<!-- 헤더 -->
	<jsp:include page="../common/header.jsp" flush="true"/>
	
	<div id="layoutSidenav">

<!-- 헤더 끝 -->

<!-- 사이드 -->
		<jsp:include page="../common/sidebar.jsp" flush="true"/>
		
			<div id="layoutSidenav_content">
				<main>
					<div class="container-fluid px-4">
						<h3 class="mt-4"> 급여관리 </h3><br>

<!-- 사이드 끝-->

<title>사원 목록</title>

<!-- DataTables CSS / jQuery -->
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css">

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script
	src="https://cdn.datatables.net/1.13.5/js/jquery.dataTables.min.js"></script>

<style>
.content-wrapper {
	padding: 20px 30px;
}

.page-title {
	font-size: 20px;
	font-weight: 600;
	margin-bottom: 15px;
}

.search-bar {
	margin-bottom: 10px;
}

.search-bar input {
	padding: 5px 8px;
	width: 250px;
}

table.dataTable tbody tr {
	cursor: pointer;
}
</style>

<script>
	$(function() {

		// DataTables 초기화
		const table = $('#empTable').DataTable({
			language : {
				"decimal" : "",
				"emptyTable" : "사원 정보가 없습니다.",
				"info" : "_TOTAL_명 중 _START_ ~ _END_명 표시",
				"infoEmpty" : "0명",
				"infoFiltered" : "(_MAX_명에서 필터링됨)",
				"lengthMenu" : "페이지당 _MENU_명 보기",
				"loadingRecords" : "로딩 중...",
				"processing" : "처리 중...",
				"search" : "",
				"zeroRecords" : "일치하는 사원이 없습니다.",
				"paginate" : {
					"first" : "처음",
					"last" : "마지막",
					"next" : "다음",
					"previous" : "이전"
				}
			},
			order : [ [ 0, 'asc' ] ]
		});

		// ⭐ DataTables 기본 검색창에 placeholder 넣기
		$('.dataTables_filter input').attr('placeholder', '이름 / 부서 / 재직상태 검색');

		// 상단 검색창과 DataTables 검색 연동
		$('#keyword').on('keyup', function() {
			table.search(this.value).draw();
		});

		// 행 클릭 시 급여 페이지로 이동
		$('#empTable tbody').on('click', 'tr', function() {
			const empNo = $(this).data('empno');
			if (!empNo)
				return;
			location.href = '/sal/list?empNo=' + empNo;
		});
	});
</script>
</head>

<body>

	<div class="content-wrapper">

		<div class="page-title">사원 목록</div>

		<!-- 상단 검색창 
    <div class="search-bar">
        <input type="text" id="keyword" placeholder="이름 / 부서 / 재직상태 검색">
    </div> -->


		<!-- 사원 테이블 -->
		<table id="empTable" class="display" style="width: 100%">
			<thead>
				<tr>
					<th>사번</th>
					<th>이름</th>
					<th>부서</th>
					<th>재직상태</th>
					<th>입사일</th>
					<th>연락처</th>
				</tr>
			</thead>

			<tbody>
				<c:forEach var="emp" items="${empList}">
					<tr data-empno="${emp.empNo}">
						<td>${emp.empNo}</td>
						<td>${emp.empName}</td>
						<td>${emp.deptName}</td>
						<td>${emp.statusName}</td>
						<td>${emp.empRegdate}</td>
						<td>${emp.empPhone}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

<!-- 푸터 -->
				<jsp:include page="../common/footer.jsp" flush="true"/>
				
			</div>
		</div>
		
</body>
</html>