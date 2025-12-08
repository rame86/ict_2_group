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
<link rel="stylesheet" href="/css/empList.css">
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css">
<script
	src="https://cdn.datatables.net/1.13.5/js/jquery.dataTables.min.js"></script>

<!-- 🔹 AJAX에서 쓸 URL 상수 (중요!!) -->
<script>
	const EMP_CARD_URL = "<c:url value='/emp/card' />";
	// 예: /ict_2_group/emp/card 로 자동 변환됨
</script>


<script>
	$(document).ready(function() {

		/* ------------------------------------
		   1) DataTables 기본 설정
		   ------------------------------------ */
		const table = $('#empTable').DataTable({
			pageLength : 10,
			lengthChange : false,
			info : false,
			searching : true,
			ordering : true,
			order : [ [ 0, 'asc' ], [ 1, 'asc' ], [ 2, 'asc' ] ],
			dom : 't<"dt-bottom"p>',

			language : {
				"zeroRecords" : "일치하는 사원이 없습니다.",
				"paginate" : {
					"first" : "처음",
					"last" : "마지막",
					"next" : "다음",
					"previous" : "이전"
				}
			}
		});

		/* ------------------------------------
		   2) DataTables 페이지네이션 위치 이동
		   ------------------------------------ */
		const pagination = $('#empTable_wrapper .dt-bottom');
		$('.emp-pagination-container').append(pagination);

		/* ------------------------------------
		   3) 검색창 → DataTables 검색 연동 (+ 선택 초기화)
		   ------------------------------------ */
		$('.emp-search-form').on('submit', function(e) {
			e.preventDefault();

			const keyword = $.trim($('input[name="keyword"]').val());

			// 1) 검색 적용 + 테이블 다시 그리기
			table.search(keyword).draw();

			// 2) 이번 draw가 끝난 직후에 한 번만 실행
			table.one('draw', function() {
				// 🔹 모든 선택 상태 제거
				$('#empTable tbody tr.emp-row').removeClass('selected');
			});

			// 3) 검색어를 비웠다면 오른쪽 카드도 초기화
			if (keyword === "") {
				$("#emp-detail-card").hide().empty();
				$("#emp-detail-placeholder").show();
			}
		});

	});
</script>

</head>

<body>

	<div id="layoutSidenav">

		<!-- 왼쪽 사이드바 -->
		<jsp:include page="../common/sidebar.jsp" />

		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid px-4">

					<div class="content-wrapper">

						<!-- ============================
							 전체 화면 좌/우 분할 구조 시작
							 ============================ -->
						<div class="emp-wrapper">

							<!-- 🔹 왼쪽 : 사원 목록 -->
							<div class="emp-list-area">

								<div class="page-header">
									<h2 class="page-title">사원 목록</h2>
								</div>

								<!-- 검색창 -->
								<div class="search-area">
									<form class="emp-search-form">
										<input type="text" name="keyword"
											placeholder="이름 / 부서 / 직급 / 사번 검색">
										<button type="submit">SEARCH</button>
									</form>
								</div>

								<!-- 사원 목록 테이블 -->
                            <div class="emp-card">
                                <table id="empTable" class="emp-table">
                                    <thead>
                                    <tr>
                                        <th>사원번호</th>
                                        <th>부서명</th>
                                        <th>직급</th>
                                        <th>이름</th>
                                       
                                       
                                    </tr>
                                    </thead>

                                    <tbody>
                                    <c:forEach var="emp" items="${empList}">
                                        <tr class="emp-row" data-empno="${emp.empNo}">
                                          <!-- 1) 사원번호 -->
                                            <td>${emp.empNo}</td>
                                          <!-- 2) 부서명 -->
                                            <td>${emp.deptName}</td>
                                          <!-- 3) 직급 -->
                                            <td>${emp.gradeName}</td>
                                          <!-- 4) 이름 -->
                                            <td>${emp.empName}</td>
                                          
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty empList}">
                                        <tr class="emp-empty-row">
                                            <!-- 컬럼 5개이므로 colspan도 5로 -->
                                            <td colspan="5">조회된 사원 정보가 없습니다.</td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <!-- DataTables 페이지네이션 삽입 공간 -->
                            <div class="emp-pagination-container"></div>

                        </div>
                        <!-- end emp-list-area -->



							<!-- 🔹 오른쪽 : 인사카드 영역 -->
							<div class="emp-detail-area">
								<div id="emp-detail-placeholder">
									왼쪽 목록에서 사원을 선택하면<br> 이 영역에 인사카드가 표시됩니다.
								</div>

								<div id="emp-detail-card" style="display: none;">
									<!-- AJAX로 empCard.jsp 내용이 여기 삽입됨 -->
								</div>
							</div>

						</div>
						<!-- end emp-wrapper -->

					</div>
					<!-- end content-wrapper -->


					<!-- 푸터 -->
					<jsp:include page="../common/footer.jsp" />

				</div>
			</main>
		</div>

	</div>


	<!-- 🔹 클릭 이벤트 + AJAX (인사카드 불러오기) -->
	<script>
		$(function() {

			$('#empTable tbody').on('click', 'tr.emp-row', function() {

				let empNo = $(this).data("empno"); // 문자열 그대로

				// 선택된 행 표시
				$(".emp-row").removeClass("selected");
				$(this).addClass("selected");

				// AJAX 요청 → empCard.jsp HTML 반환
				$.ajax({
					url : EMP_CARD_URL, // "/emp/card"
					type : "get",
					data : {
						empNo : empNo
					},
					success : function(html) {

						$("#emp-detail-placeholder").hide();
						$("#emp-detail-card").show().html(html);
					},
					error : function() {
						alert("인사카드를 불러오는 중 오류가 발생했습니다.");
					}
				});
			});

		});
	</script>

</body>
</html>
