<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>급여 관리 관리자모드</title>

<!-- 공통 header (부트스트랩 / jQuery 포함) -->
<jsp:include page="../common/header.jsp" />

<!-- ✅ adminList 전용 CSS -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/salAdmin.css">

<!-- DataTables CSS -->
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

<!-- jQuery (header.jsp에 이미 있으면 중복이면 제거 가능) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>

<body>
	<div id="layoutSidenav">

		<!-- 사이드바 -->
		<jsp:include page="../common/sidebar.jsp" />

		<div id="layoutSidenav_content">
			<main>

				<!-- ✅ adminList 전체 스코프 -->
				<div class="sal-admin-page">
					<div class="container-fluid px-4">

						<!-- 타이틀 -->
						<div class="page-title-wrap">
							<h3 class="page-title">[관리자모드] 급여 관리</h3>
						</div>
						<br>
						<h4 class="page-mini">급여 명세 목록</h4>

						<!-- ✅ 1) 상단 요약 카드 -->
						<div class="sal-summary-row">

							<!-- 총 실지급액 (클릭 시 필터 초기화 성격) -->
							<div class="summary-card summary-main js-summary-card"
								data-filter="all">
								<div class="summary-label">총 실지급액</div>
								<div class="summary-value">
									<fmt:formatNumber value="${summary.totalRealPay}"
										pattern="#,##0" />
									원
								</div>
								<div class="summary-sub">선택한 조건에 해당하는 모든 직원의 실지급액 합계</div>
							</div>

							<!-- 평균 실지급액 (클릭 시 필터 초기화 성격) -->
							<div class="summary-card js-summary-card" data-filter="all">
								<div class="summary-label">평균 실지급액</div>
								<div class="summary-value">
									<fmt:formatNumber value="${summary.avgRealPay}" pattern="#,##0" />
									원
								</div>
								<div class="summary-sub">지급 인원 기준 1인당 평균</div>
							</div>

							<!-- 검색 조건 사원 수 (클릭 시 초과근무만 필터 적용) -->
							<div class="summary-card js-summary-card" data-filter="overtime">
								<div class="summary-label">검색 조건에 해당하는 사원 수</div>
								<div class="summary-value">
									<fmt:formatNumber value="${summary.empCount}" pattern="#,##0" />
									명
								</div>
								<div class="summary-sub">필터에 포함된 직원 인원</div>
							</div>

						</div>
						<br>

						<!-- ✅ 2) 검색/필터 영역 -->
						<div class="sal-filter-row">

							<!-- 왼쪽: 월/부서/체크 + 검색 -->
							<form id="adminFilterForm" method="get"
								action="${pageContext.request.contextPath}/sal/admin/list"
								class="sal-filter-left">

								<!-- 지급월 -->
								<input type="month" name="month"
									class="form-control form-control-sm" value="${searchMonth}"
									style="width: 180px;">

								<!-- 부서 -->
								<select name="deptNo" class="form-select form-select-sm"
									style="width: 160px;">
									<option value="">전체 부서</option>
									<c:forEach var="d" items="${deptList}">
										<option value="${d.deptNo}"
											<c:if test="${searchDeptNo == d.deptNo}">selected</c:if>>
											${d.deptName}</option>
									</c:forEach>
								</select>

								<!-- 초과근무 있음만 -->
								<label class="form-check-label sal-overtime-check"> <input
									type="checkbox" name="onlyOvertime" value="true"
									<c:if test="${onlyOvertime}">checked</c:if>> 초과근무 있음만
								</label>

								<!-- 퇴사자 제외 -->
								<label class="form-check-label sal-overtime-check"
									style="margin-left: 10px;"> <input type="checkbox"
									name="excludeRetired" value="true"
									<c:if test="${excludeRetired}">checked</c:if>> 퇴사자 제외
								</label>

								<!-- 검색 버튼 -->
								<button type="submit" class="btn btn-search btn-sm">검색</button>

							</form>

							<!-- 오른쪽: 엑셀 + DataTables Search -->
							<div class="sal-filter-right">

								<!-- 현재 검색조건으로 엑셀 URL -->
								<c:url var="exportUrl" value="/sal/admin/export">
									<c:param name="month" value="${searchMonth}" />
									<c:param name="deptNo" value="${searchDeptNo}" />
									<c:param name="onlyOvertime" value="${onlyOvertime}" />
									<c:param name="excludeRetired" value="${excludeRetired}" />
								</c:url>

								<button type="button" class="btn btn-excel btn-sm"
									onclick="location.href='${exportUrl}'">엑셀 다운로드</button>

								<!-- DataTables 검색창이 JS에서 여기로 append -->
								<div class="sal-top-right"></div>
							</div>

						</div>
						<!-- // sal-filter-row 끝 -->

						<!-- ✅ 3) 테이블 영역 -->
						<c:choose>
							<c:when test="${not empty salList}">

								<table id="salTable" class="sal-table display">
									<thead>
										<tr>
											<th>지급월</th>
											<th>사번</th>
											<th>이름</th>
											<th>부서</th>
											<th>기본급</th>
											<th>초과근무</th>
											<th>성과급</th>
											<th>기타수당</th>
											<th>공제합계</th>
											<th>실지급액</th>
											<th>명세서</th>
											<th>정정</th>
										</tr>
									</thead>

									<tbody>
										<c:forEach var="s" items="${salList}">
											<tr
												class="<c:if test='${s.overtimePay != null && s.overtimePay > 0}'>has-overtime</c:if>">

												<td>${s.yearMonthLabel}</td>
												<td>${s.empNo}</td>
												<td>${s.empName}</td>
												<td>${s.deptName}</td>

												<td><fmt:formatNumber value="${s.salBase}"
														pattern="#,##0" />원</td>

												<td><fmt:formatNumber
														value="${s.overtimePay == null ? 0 : s.overtimePay}"
														pattern="#,##0" />원 <c:if
														test="${s.overtimePay != null && s.overtimePay > 0}">
														<span class="badge-overtime">초과</span>
													</c:if></td>

												<td><fmt:formatNumber value="${s.salBonus}"
														pattern="#,##0" />원</td>

												<td><fmt:formatNumber value="${s.salPlus}"
														pattern="#,##0" />원</td>

												<td><fmt:formatNumber value="${s.deductTotal}"
														pattern="#,##0" />원</td>

												<td><fmt:formatNumber value="${s.realPay}"
														pattern="#,##0" />원</td>

												<!-- 자세히(상세) -->
												<td class="text-center">
												<a href="${pageContext.request.contextPath}/sal/admin/detail?empNo=${s.empNo}&monthAttno=${s.monthAttno}">
														보기 </a></td>

												<!-- 정정(관리자 편집폼) -->
												<td class="text-center">
												<a href="${pageContext.request.contextPath}/sal/admin/edit?salNum=${s.salNum}">정정</a>

											</tr>
										</c:forEach>
									</tbody>

								</table>

							</c:when>

							<c:otherwise>
								<p class="text-muted mt-3">선택한 조건에 해당하는 급여 데이터가 없습니다.</p>
							</c:otherwise>
						</c:choose>

					</div>
					<!-- // container-fluid -->
				</div>
				<!-- // sal-admin-page -->

			</main>

			<!-- 푸터 -->
			<jsp:include page="../common/footer.jsp" />

		</div>
		<!-- // layoutSidenav_content -->
	</div>
	<!-- // layoutSidenav -->

	<!-- DataTables JS -->
	<script
		src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

	<c:if test="${not empty salList}">
		<script>
			$(function() {

				$('#salTable')
						.DataTable(
								{
									ordering : true,
									order : [ [ 0, 'desc' ], [ 1, 'asc' ] ],// 초기 정렬(서버 정렬 보조용)
									paging : true,
									pageLength : 10,
									lengthChange : false,
									searching : true,
									info : false,
									columnDefs : [ {
										orderable : false,
										targets : -1
									} ],
									language : {
										search : "",
										emptyTable : "표시할 급여 데이터가 없습니다.",
										paginate : {
											previous : "이전",
											next : "다음"
										}
									},
									initComplete : function() {
										var filter = $('#salTable_wrapper .dataTables_filter');
										filter
												.appendTo('.sal-filter-right .sal-top-right');
										$('.dataTables_filter input').attr(
												'placeholder', 'Search...');
									}
								});

			});
		</script>
	</c:if>

	<script>
		$(function() {
			$('.js-summary-card')
					.on(
							'click',
							function() {
								const filterType = $(this).data('filter');
								const baseUrl = '${pageContext.request.contextPath}/sal/admin/list';
								const params = new URLSearchParams();

								const month = $('input[name="month"]').val();
								const deptNo = $('select[name="deptNo"]').val();
								const excludeRetired = $(
										'input[name="excludeRetired"]').is(
										':checked');

								// ✅ 공통: 월/부서/퇴사자제외는 유지
								if (month)
									params.append('month', month);
								if (deptNo)
									params.append('deptNo', deptNo);
								if (excludeRetired)
									params.append('excludeRetired', 'true');

								if (filterType === 'overtime') {
									// ✅ overtime 카드: 초과근무 필터 강제 ON
									params.append('onlyOvertime', 'true');
								} else {
									// ✅ all 카드(총/평균): 초과근무 필터는 무조건 OFF (파라미터에 안 넣음)
									// (즉, onlyOvertime 파라미터를 아예 보내지 않음)
								}

								location.href = baseUrl + '?'
										+ params.toString();
							});
		});
	</script>


</body>
</html>
