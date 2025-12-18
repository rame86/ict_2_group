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

<!-- SUIT 폰트 -->
<link href="https://cdn.jsdelivr.net/npm/suit-font/dist/suit.min.css" rel="stylesheet">

<!-- 급여 목록 전용 CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/salList.css">

<!-- DataTables -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>

<body>
	<c:set var="today" value="<%=java.time.LocalDate.now().toString()%>" />

	<div id="layoutSidenav">
		<jsp:include page="../common/sidebar.jsp" />

		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid px-4">

					<h3 class="mt-4">급여 관리</h3>
					<h4 class="sal-List">급여 명세서 목록</h4>

					<div class="content-wrapper">

						<!-- 사원 정보 -->
						<div class="emp-info-box">
							<span><strong>사번</strong> : ${emp.empNo}</span>
							<span><strong>이름</strong> : ${emp.empName}</span>
							<span><strong>부서</strong> : ${emp.deptName}</span>
							<span><strong>재직상태</strong> : ${emp.statusName}</span>
						</div>

						<!-- 요약 카드 -->
						<c:if test="${not empty summary}">
							<div class="sal-summary-row">
								<div class="summary-card">
									<div class="summary-label">최근 실지급액</div>
									<div class="summary-value">
										<fmt:formatNumber value="${summary.latestRealPay}" pattern="#,##0" />원
									</div>
								</div>

								<div class="summary-card">
									<div class="summary-label">최근 3개월 평균</div>
									<div class="summary-value">
										<fmt:formatNumber value="${summary.avg3mRealPay}" pattern="#,##0" />원
									</div>
								</div>

								<div class="summary-card">
									<div class="summary-label">올해 누적 (YTD)</div>
									<div class="summary-value">
										<fmt:formatNumber value="${summary.ytdRealPay}" pattern="#,##0" />원
									</div>
								</div>
							</div>
						</c:if>

						<c:if test="${empty salList}">
							<p class="text-muted">급여 정보가 없습니다.</p>
						</c:if>

						<c:if test="${not empty salList}">
							<table id="salTable" class="salary-table display">
								<thead>
									<tr>
										<th>지급월</th>
										<th>총 지급액</th>
										<th>지급 요약</th>
										<th>공제 총액 <span class="hint" title="4대 보험 + 세금">ⓘ</span></th>
										<th class="realpay-th">실 지급액</th>
									</tr>
								</thead>

								<tbody>
									<c:forEach var="sal" items="${salList}">
										<tr>
											<!-- 지급월 -->
											<td>
												<%-- ✅ 안정화: 사원 상세는 empNo를 굳이 넘길 필요 없음(컨트롤러에서 세션으로 강제함) --%>
												<a href="#" class="month-link month-pill"
												   data-monthattno="${sal.monthAttno}">
													${sal.yearMonthLabel}
												</a>

												<%-- ✅ choose 안에는 HTML 주석 넣으면 오류 --%>
												<c:choose>
													<c:when test="${today lt sal.salDate}">
														<span class="pay-badge planned">지급예정</span>
													</c:when>
													<c:otherwise>
														<span class="pay-badge done">지급완료</span>
													</c:otherwise>
												</c:choose>
											</td>

											<!-- 총 지급액 -->
											<td class="pay-total">
												<fmt:formatNumber value="${sal.payTotal}" pattern="#,##0" />원
											</td>

											<!-- 지급 요약 -->
											<td class="allowance-cell">
												<div class="allowance-line">
													<span class="allowance-label">초과근무</span>
													<span class="allowance-val"><fmt:formatNumber value="${sal.overtimePay}" pattern="#,###" />원</span>
												</div>
												<div class="allowance-line">
													<span class="allowance-label">성과급</span>
													<span class="allowance-val"><fmt:formatNumber value="${sal.salBonus}" pattern="#,###" />원</span>
												</div>
												<div class="allowance-line">
													<span class="allowance-label">기타수당</span>
													<span class="allowance-val"><fmt:formatNumber value="${sal.salPlus}" pattern="#,###" />원</span>
												</div>
											</td>

											<!-- 공제 총액 -->
											<td class="deduct-total">
												<fmt:formatNumber value="${sal.deductTotal}" pattern="#,##0" />원
											</td>

											<!-- 실 지급액 -->
											<td class="real-pay" data-realpay="${sal.realPay}">
												<fmt:formatNumber value="${sal.realPay}" pattern="#,##0" />원
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</c:if>

					</div>
				</div>
			</main>

			<jsp:include page="../common/footer.jsp" />
		</div>
	</div>

	<!-- DataTables JS -->
	<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

	<c:if test="${not empty salList}">
	<script>
		const SAL_DETAIL_URL = "<c:url value='/sal/detail' />";

		$(function () {

			$('#salTable').DataTable({
				order: [[0, 'desc']],
				paging: true,
				pageLength: 10,
				lengthChange: false,

				/* ✅ 사원용은 테이블 내부 검색 OFF 유지 */
				searching: false,
				info: false,

				/* ✅ 안정화: "지급 요약" 컬럼(3번째, index 2)은 정렬 꺼두기 */
				columnDefs: [
					{ targets: [2], orderable: false }
				],

				language: {
					emptyTable: "급여 정보가 없습니다.",
					paginate: { previous: "이전", next: "다음" }
				}
			});

			/* ✅ 상세 이동: monthAttno만 넘김 (empNo는 컨트롤러에서 세션으로 강제됨) */
			$("#salTable").on("click", "a.month-link", function (e) {
				e.preventDefault();
				location.href = SAL_DETAIL_URL
			    + "?monthAttno=" + $(this).data("monthattno");
			});

			/* ✅ 실지급액 0원 처리 (CSS 클래스명 일치) */
			$("#salTable tbody tr").each(function () {
				const $td = $(this).find(".real-pay");
				if (Number($td.data("realpay")) === 0) {
					$td.addClass("is-zero");
				}
			});
		});
	</script>
	</c:if>

</body>
</html>
