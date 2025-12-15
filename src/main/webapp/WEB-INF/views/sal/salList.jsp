<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
if (request.getAttribute("menu") == null) {
	request.setAttribute("menu", "salemp");
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>급여 명세서 목록</title>

<!-- 공통 헤더 -->
<jsp:include page="../common/header.jsp" />

<!-- SUIT 폰트 로드 (없으면 폰트 적용 안됨) -->
<link href="https://cdn.jsdelivr.net/npm/suit-font/dist/suit.min.css"
	rel="stylesheet">

<!-- 급여 목록 전용 CSS -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/salList.css">

<!-- DataTables CSS -->
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

<!-- jQuery (header.jsp에서 이미 포함돼 있으면 생략 가능) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

</head>
<body>
	<c:set var="today" value="<%=java.time.LocalDate.now().toString()%>" />
	<div id="layoutSidenav">

		<!-- 사이드바 -->
		<jsp:include page="../common/sidebar.jsp" />

		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid px-4">

					<div class="page-title-wrap">
						<h3 class="mt-4">급여 관리</h3>
					</div>
					<br>
					<h4 class="sal-List">급여 명세서 목록</h4>

					<div class="content-wrapper">

						<!-- 사원 기본정보 표시 -->
						<div class="emp-info-box">
							<span><strong>사번</strong> : ${emp.empNo}</span> <span><strong>이름</strong>
								: ${emp.empName}</span> <span><strong>부서</strong> :
								${emp.deptName}</span> <span><strong>재직상태</strong> :
								${emp.statusName}</span>
						</div>

						<c:if test="${not empty summary}">
							<div class="sal-summary-row">
								<div class="summary-card">
									<div class="summary-label">최근 실지급액</div>
									<div class="summary-value">
										<fmt:formatNumber value="${summary.latestRealPay}"
											type="number" pattern="#,##0" />
										원
									</div>
								</div>

								<div class="summary-card">
									<div class="summary-label">최근 3개월 평균</div>
									<div class="summary-value">
										<fmt:formatNumber value="${summary.avg3mRealPay}"
											type="number" pattern="#,##0" />
										원
									</div>
								</div>

								<div class="summary-card">
									<div class="summary-label">올해 누적 (YTD)</div>
									<div class="summary-value">
										<fmt:formatNumber value="${summary.ytdRealPay}" type="number"
											pattern="#,##0" />
										원
									</div>
								</div>
							</div>
						</c:if>


						<!-- 🔹 데이터가 없을 때: 메시지만 표시 -->
						<c:if test="${empty salList}">
							<p class="text-muted">급여 정보가 없습니다.</p>
						</c:if>

						<!-- 🔹 데이터가 있을 때만 테이블 + DataTables 사용 -->
						<c:if test="${not empty salList}">
							<table id="salTable" class="salary-table display">
								<thead>
									<tr>
										<th>지급월</th>
										<th>총 지급액</th>
										<th>공제 총액 <span class="hint" title="4대 보험 + 세금 합계">ⓘ</span>
										</th>

										<th>실 지급액</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="sal" items="${salList}">
										<tr>
											<td><c:choose>
													<c:when test="${not empty sal.yearMonthLabel}">
														<a href="#" class="month-link month-pill"
															data-empno="${sal.empNo}"
															data-monthattno="${sal.monthAttno}">
															${sal.yearMonthLabel} </a>
													</c:when>
													<c:otherwise>
														<a href="#" class="month-link month-pill"
															data-empno="${sal.empNo}"
															data-monthattno="${sal.monthAttno}">
															${sal.monthAttno} </a>
													</c:otherwise>
												</c:choose> <c:set var="payDate" value="${sal.salDate}" /> <c:choose>
													
													<c:when test="${not empty payDate and today lt payDate}">
														<span class="pay-badge planned">지급예정</span>
													</c:when>
													<c:otherwise>
														<span class="pay-badge done">지급완료</span>
													</c:otherwise>
												</c:choose></td>

											<td><fmt:formatNumber value="${sal.payTotal}"
													type="number" pattern="#,##0" />원</td>
											<td><fmt:formatNumber value="${sal.deductTotal}"
													type="number" pattern="#,##0" />원</td>
											<td class="td-realpay" data-realpay="${sal.realPay}"><fmt:formatNumber
													value="${sal.realPay}" type="number" pattern="#,##0" />원</td>

										</tr>
									</c:forEach>
								</tbody>
							</table>
						</c:if>

					</div>
				</div>
			</main>

			<!-- 푸터 -->
			<jsp:include page="../common/footer.jsp" />
		</div>
	</div>

	<!-- DataTables JS -->
	<script
		src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

	<c:if test="${not empty salList}">
		<script>
			//컨텍스트 경로가 포함된 상세 조회 URL
			const SAL_DETAIL_URL = "<c:url value='/sal/detail' />";

			$(function() {

				// 1) DataTables 초기화
				$('#salTable').DataTable({
					ordering : true, // 헤더 클릭 정렬
					order : [ [ 0, 'desc' ] ], // 기본: 지급월 내림차순
					paging : true,
					pageLength : 10,
					lengthChange : false,
					searching : false,
					info : false,
					language : {
						emptyTable : "급여 정보가 없습니다.",
						paginate : {
							previous : "이전",
							next : "다음"
						}
					}
				});

				// 2) 지급월 링크 클릭 시 → 급여 명세서 상세 페이지로 이동
				$("#salTable").on(
						"click",
						"a.month-link",
						function(e) {
							e.preventDefault();

							const empNo = $(this).data("empno");
							const monthAttno = $(this).data("monthattno");

							if (!empNo || !monthAttno)
								return;

							// /컨텍스트경로/sal/detail?empNo=...&monthAttno=...
							location.href = SAL_DETAIL_URL + "?empNo="
									+ encodeURIComponent(empNo)
									+ "&monthAttno="
									+ encodeURIComponent(monthAttno);
						});

				$("#salTable tbody tr").each(function() {
					const $td = $(this).find(".td-realpay");
					const v = Number($td.data("realpay")) || 0;
					if (v === 0)
						$td.addClass("is-zero");
				});

			});

			// 컨텍스트 경로를 안전하게 쓰기 위해
			const EMP_CARD_URL = "<c:url value='/emp/card' />";
		</script>


	</c:if>

</body>
</html>
