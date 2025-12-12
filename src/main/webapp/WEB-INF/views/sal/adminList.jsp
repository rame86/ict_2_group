<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>급여 관리 관리자모드</title>

<!-- 공통 header (부트스트랩 / jQuery 포함) -->
<jsp:include page="../common/header.jsp" />

<!-- 급여 관리자/상세 공통 CSS -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/salDetail.css">

<!-- DataTables CSS -->
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

<!-- jQuery (header.jsp에 이미 있으면 중복되면 제거 가능) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>

	<div id="layoutSidenav">

		<!-- 사이드바 -->
		<jsp:include page="../common/sidebar.jsp" />

		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid px-4">

					<h3 class="mt-4">급여 관리 관리자모드</h3>
					<br>
					<h4>급여 명세 목록</h4>
					
					<!-- ✅ 1) 상단 요약 카드 -->
					<div class="sal-summary-row">

						<!-- 총 실지급액 -->
						<div class="summary-card summary-main">
							<div class="summary-label">총 실지급액</div>
							<div class="summary-value">
								<fmt:formatNumber value="${summary.totalRealPay}"
									pattern="#,##0" />
								원
							</div>
							<div class="summary-sub">선택한 조건에 해당하는 모든 직원의 실지급액 합계</div>
						</div>

						<!-- 평균 실지급액 -->
						<div class="summary-card">
							<div class="summary-label">평균 실지급액</div>
							<div class="summary-value">
								<fmt:formatNumber value="${summary.avgRealPay}" pattern="#,##0" />
								원
							</div>
							<div class="summary-sub">지급 인원 기준 1인당 평균</div>
						</div>

						<!-- 검색 조건 사원 수 -->
						<div class="summary-card">
							<div class="summary-label">검색 조건에 해당하는 사원 수</div>
							<div class="summary-value">
								<fmt:formatNumber value="${summary.empCount}" pattern="#,##0" />
								명
							</div>
							<div class="summary-sub">필터에 포함된 직원 인원</div>
						</div>
					</div>

					<!-- ✅ 2) 검색/필터 영역 (월 + 부서 + 초과근무 + 엑셀 버튼 + Search...) -->
					<div class="sal-filter-row">

						<!-- 왼쪽: 월/부서/초과근무 + 검색 -->
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

							<!-- 검색 버튼 -->
							<button type="submit" class="btn btn-primary btn-sm">검색
							</button>
						</form>

						<!-- 오른쪽: 엑셀 다운로드 + DataTables 검색창 자리 -->
						<div class="sal-filter-right">
							<!-- 엑셀 다운로드 버튼 -->
							<%-- 🔹 현재 검색 조건으로 엑셀 다운로드 URL 만들기 --%>
							<c:url var="exportUrl" value="/sal/admin/export">
								<c:param name="month" value="${searchMonth}" />
								<c:param name="deptNo" value="${searchDeptNo}" />
								<c:param name="onlyOvertime" value="${onlyOvertime}" />
							</c:url>

							<button type="button" class="btn btn-outline-secondary btn-sm"
								onclick="location.href='${exportUrl}'">엑셀 다운로드</button>

							<!-- DataTables 검색창이 JS에서 여기로 append 됨 -->
							<div class="sal-top-right"></div>
						</div>

					</div>

					<!-- =========================
                     3) 테이블 영역
                   ========================= -->
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
										<th>자세히</th>
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
													<span class="badge-overtime"></span>
												</c:if></td>
											<td><fmt:formatNumber value="${s.salBonus}"
													pattern="#,##0" />원</td>
											<td><fmt:formatNumber value="${s.salPlus}"
													pattern="#,##0" />원</td>
											<td><fmt:formatNumber value="${s.deductTotal}"
													pattern="#,##0" />원</td>
											<td><fmt:formatNumber value="${s.realPay}"
													pattern="#,##0" />원</td>
											<td><a
												href="${pageContext.request.contextPath}/sal/admin/detail?empNo=${s.empNo}&monthAttno=${s.monthAttno}">
													보기 </a></td>
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
    $(function () {

        // 1) DataTables 설정
        var table = $('#salTable').DataTable({
            ordering: true,
            order: [[0, 'desc'], [1, 'asc']],   // 지급월 ↓, 사번 ↑
            paging: true,
            pageLength: 10,
            lengthChange: false,
            searching: true,
            info: false,
            columnDefs: [
                { orderable: false, targets: -1 }   // '자세히'는 정렬 X
            ],
            language: {
                search: "",
                emptyTable: "표시할 급여 데이터가 없습니다.",
                paginate: {
                    previous: "이전",
                    next: "다음"
                }
            }
        });

        // 2) 검색창 위치 이동 → 오른쪽 상단 박스 안으로
        var filter = $('#salTable_wrapper .dataTables_filter');
        filter.appendTo('.sal-search-placeholder');
        filter.addClass('sal-search-box');
        $('.dataTables_filter input').attr('placeholder', 'Search...');

        // 3) 엑셀 다운로드 버튼 클릭 시 → 현재 필터 조건 그대로 전달
        $('#btnAdminExport').on('click', function () {
            const baseUrl = '${pageContext.request.contextPath}/sal/admin/export';

            const month = $('input[name="month"]').val();
            const deptNo = $('select[name="deptNo"]').val();
            const onlyOvertime = $('input[name="onlyOvertime"]').is(':checked');

            const params = new URLSearchParams();
            if (month) params.append('month', month);
            if (deptNo) params.append('deptNo', deptNo);
            if (onlyOvertime) params.append('onlyOvertime', 'true');

            location.href = baseUrl + '?' + params.toString();
        });
        
     // 🔹 검색창을 우리가 만든 오른쪽 박스 안으로 옮기기
        var filter = $('#salTable_wrapper .dataTables_filter');
        filter.appendTo('.sal-filter-right .sal-top-right');
        filter.addClass('sal-search-box');

        $('.dataTables_filter input').attr('placeholder', 'Search...');
    });

    });
</script>
	</c:if>

</body>
</html>
