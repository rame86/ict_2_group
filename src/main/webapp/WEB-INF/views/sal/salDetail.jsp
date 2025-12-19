<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
/* =========================================================
✅ 메뉴 활성화(사이드바 하이라이트용)
- 컨트롤러에서 menu를 안 내려줘도 기본값으로 'salemp'
========================================================= */
if (request.getAttribute("menu") == null) {
	Object isAdminObj = request.getAttribute("isAdmin");
	boolean isAdmin = (isAdminObj != null) && Boolean.TRUE.equals(isAdminObj);
	request.setAttribute("menu", isAdmin ? "saladmin" : "salemp");
}
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>급여 명세서</title>

<!-- ✅ 공통 header (부트스트랩/기본 JS 포함) -->
<jsp:include page="../common/header.jsp" />

<!-- ✅ salDetail 전용 CSS -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/salDetail.css">

<!-- ✅ SUIT 폰트 -->
<link href="https://cdn.jsdelivr.net/npm/suit-font/dist/suit.min.css"
	rel="stylesheet">

<!-- ✅ Chart.js (차트 생성 전에 1번만 로드) -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>
	<div id="layoutSidenav">

		<!-- ✅ 사이드바 -->
		<jsp:include page="../common/sidebar.jsp" />

		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid px-4">

					<!-- =========================================================
                     ✅ 페이지 타이틀
                     ========================================================= -->
					<div class="page-title-wrap">
						<h3 class="mt-4">급여 관리</h3>
					</div>

					<h4 class="sal-List-Title">급여 명세서</h4>

					<div class="content-wrapper">

						<!-- =========================================================
                         ✅ 상단 정보 카드
                         - 지급월/지급일/사원 정보 + (총지급/공제/실지급) 칩
                         ========================================================= -->
						<div class="info-card">

							<!-- 1) 상단 헤더: 지급월 + 출력 버튼 -->
							<div class="info-card-header">
								<div class="info-row info-row--single">
									<span class="info-item"> <span class="info-label">지급월
											:</span> <span class="info-value"> <c:choose>
												<%-- 우선순위: yearMonthLabel → yearMonth → monthAttno --%>
												<c:when test="${not empty sal.yearMonthLabel}">
                                                ${sal.yearMonthLabel}
                                            </c:when>
												<c:when test="${not empty sal.yearMonth}">
                                                ${sal.yearMonth}
                                            </c:when>
												<c:otherwise>
                                                ${sal.monthAttno}
                                            </c:otherwise>
											</c:choose>
									</span>
									</span>
								</div>

								<!-- ✅ 인쇄 버튼: 인쇄 시 숨김(no-print) -->
								<button type="button" class="btn-print no-print"
									onclick="window.print();">🖨 명세서 출력</button>
							</div>

							<!-- 2) 본문: 지급일 + 사원 기본 정보 -->
							<div class="info-body">
								<div class="info-row info-row--single">
									<span class="info-item"> <span class="info-label">지급일
											:</span> <span class="info-value"> <c:choose>
												<%-- sal.salDate가 있으면 그걸 사용 --%>
												<c:when test="${not empty sal.salDate}">
                                                ${sal.salDate}
                                            </c:when>
												<%-- 없으면 지급월 라벨 기준으로 15일로 표기 --%>
												<c:when test="${not empty sal.yearMonthLabel}">
                                                ${sal.yearMonthLabel} 15일
                                            </c:when>
												<c:otherwise>
                                                15일
                                            </c:otherwise>
											</c:choose>
									</span>
									</span>
								</div>

								<!-- ✅ 사원 정보 4칸 -->
								<div class="info-grid">
									<div class="info-pair">
										<span class="k">사번</span><span class="v">${emp.empNo}</span>
									</div>
									<div class="info-pair">
										<span class="k">이름</span><span class="v">${emp.empName}</span>
									</div>
									<div class="info-pair">
										<span class="k">부서</span><span class="v">${emp.deptName}</span>
									</div>
									<div class="info-pair">
										<span class="k">재직상태</span><span class="v">${emp.statusName}</span>
									</div>
								</div>
							</div>

							<!-- 3) 칩: 총지급/공제/실지급 -->
							<div class="info-chips">
								<div class="summary-chips">
									<span class="chip chip-pay"> 총 지급 <b><fmt:formatNumber
												value="${sal.payTotal}" pattern="#,###" /></b>원
									</span> <span class="chip chip-deduct"> 공제 <b><fmt:formatNumber
												value="${sal.deductTotal}" pattern="#,###" /></b>원
									</span> <span class="chip chip-net"> 실지급 <b><fmt:formatNumber
												value="${sal.realPay}" pattern="#,###" /></b>원
									</span>
								</div>
							</div>

						</div>
						<!-- // info-card -->

						<!-- =========================================================
                         ✅ 지급 / 공제 / 비율(차트) 영역
                         - 좌: 도넛 차트
                         - 중: 지급 내역
                         - 우: 공제 내역
                         ========================================================= -->
						<div class="salary-wrapper">

							<!-- 1) 지급/공제 도넛 차트 -->
							<div class="detail-card mini-card chart-card">
								<div class="salary-box">
									<h5>지급 / 공제 비율</h5>

									<!-- ✅ 숫자 데이터는 dataset으로 전달(스크립트에서 안전 파싱) -->
									<canvas id="payDonutChart"
										data-pay="${empty sal.payTotal ? 0 : sal.payTotal}"
										data-deduct="${empty sal.deductTotal ? 0 : sal.deductTotal}"
										data-realpay="${empty sal.realPay ? 0 : sal.realPay}">
									</canvas>


									<div class="chart-legend">
										<span class="legend pay">● 지급</span> <span
											class="legend deduct">● 공제</span>
									</div>
								</div>
							</div>

							<!-- 2) 지급 내역 -->
							<div class="detail-card pay-card">
								<div class="salary-box">
									<h5>지급 내역</h5>
									<table class="salary-table">
										<tr>
											<th>기본급</th>
											<td><fmt:formatNumber value="${sal.salBase}"
													pattern="#,##0" />원</td>
										</tr>
										<tr>
											<th>성과급</th>
											<td><span
												class="${sal.salBonus == 0 ? 'amount-zero' : ''}"> <fmt:formatNumber
														value="${sal.salBonus}" pattern="#,##0" />원
											</span></td>
										</tr>
										<tr>
											<th>기타 수당</th>
											<td><span
												class="${sal.salPlus == 0 ? 'amount-zero' : ''}"> <fmt:formatNumber
														value="${sal.salPlus}" pattern="#,##0" />원
											</span></td>
										</tr>
										<tr>
											<th>초과근무 수당</th>
											<td><fmt:formatNumber value="${sal.overtimePay}"
													pattern="#,##0" />원</td>
										</tr>
									</table>
								</div>
							</div>

							<!-- 3) 공제 내역 -->
							<div class="detail-card deduct-card">
								<div class="salary-box">
									<h5>공제 내역</h5>
									<table class="salary-table">
										<tr>
											<th>4대 보험</th>
											<td><fmt:formatNumber value="${sal.insurance}"
													pattern="#,##0" />원</td>
										</tr>
										<tr>
											<th>세금</th>
											<td><fmt:formatNumber value="${sal.tax}" pattern="#,##0" />원</td>
										</tr>
									</table>
								</div>
							</div>

						</div>
						<!-- // salary-wrapper -->

						<!-- =========================================================
                         ✅ 하단 요약(문구 + 합계 + 실지급 강조)
                         ========================================================= -->
						<div class="net-salary-box">

							<!-- 좌측 안내 문구 -->
							<div class="net-left">
								<div class="pay-note">* 결재 승인은 월말 당일 중에 완료 될 수 있도록 협력
									부탁드립니다. *</div>
							</div>

							<!-- 우측 합계 박스 -->
							<div class="summary-box">
								<div class="summary-row">
									<span class="summary-label">총 지급액</span> <span><fmt:formatNumber
											value="${sal.payTotal}" pattern="#,##0" />원</span>
								</div>
								<div class="summary-row">
									<span class="summary-label">공제 합계</span> <span><fmt:formatNumber
											value="${sal.deductTotal}" pattern="#,##0" />원</span>
								</div>
								<div class="summary-row real-pay-row">
									<span class="summary-label">실지급액</span> <span
										class="net-salary"> <fmt:formatNumber
											value="${sal.realPay}" pattern="#,##0" />원
									</span>
								</div>
							</div>
						</div>
						<!-- // net-salary-box -->


						<!-- =========================================================
                         ✅ 관리자 전용: 급여 정정 이력
                         ---------------------------------------------------------
                         [중요]
                         - 이 블록은 "관리자 상세"에서만 보이도록 구성되어야 해요.
                         - 지금 JSP는 아래 조건으로 노출 중:
                           1) isAdmin == true
                           2) edits 리스트가 비어있지 않음
                         ---------------------------------------------------------
                         ✅ 컨트롤러에서 반드시 내려줘야 하는 값:
                         - model.addAttribute("isAdmin", true/false);
                         - model.addAttribute("edits", List<SalEditVO>);
                         ========================================================= -->
						<c:if test="${isAdmin}">
							<div class="detail-card edit-history">
								<h5 class="m-title">급여 정정 이력</h5>

								<table class="salary-table">
									<colgroup>
										<col style="width: 22%;">
										<col style="width: 14%;">
										<col style="width: 34%;">
										<col style="width: 30%;">
										<!-- ✅ 실지급액(전→후) 넓게 -->
									</colgroup>

									<thead>
										<tr>
											<th>정정일시</th>
											<th>정정 사원</th>
											<th>정정 사유</th>
											<th>실지급액 (전 → 후)</th>
										</tr>
									</thead>

									<tbody>

										<c:if test="${empty edits}">
											<tr>
												<td colspan="4"
													style="text-align: center; color: #6B7280; padding: 12px;">
													정정 이력이 없습니다.</td>
											</tr>
										</c:if>

										<c:forEach var="e" items="${edits}">
											<tr>
												<td>${e.editDate}</td>
												<td><c:choose>
														<c:when test="${not empty e.editByName}">
											            ${e.editByName} (${e.editBy})
											          </c:when>
														<c:otherwise>
											            ${e.editBy}
											          </c:otherwise>
													</c:choose></td>
												<td class="edit-reason">${e.editReason}</td>
												<td><fmt:formatNumber value="${e.beforeRealPay}"
														pattern="#,##0" />원 → <fmt:formatNumber
														value="${e.afterRealPay}" pattern="#,##0" />원</td>
											</tr>
										</c:forEach>

									</tbody>


								</table>
							</div>
						</c:if>
						<!-- // edit-history -->

						<!-- =========================================================
                         ✅ 하단 버튼 (인쇄 시 숨김)
                         ========================================================= -->
						<div class="btn-area no-print">
							<button type="button" onclick="history.back();">급여 명세서
								목록으로 돌아가기</button>
						</div>

					</div>
					<!-- // content-wrapper -->
				</div>
				<!-- // container-fluid -->
			</main>

			<!-- ✅ 푸터 -->
			<jsp:include page="../common/footer.jsp" />
		</div>
		<!-- // layoutSidenav_content -->
	</div>
	<!-- // layoutSidenav -->


	<!-- =========================================================
     ✅ 차트 스크립트 (1번만)
     - dataset 값을 숫자로 변환해서 도넛 생성
     - 중앙 텍스트(실지급액) 표시 플러그인 포함
     ========================================================= -->
	<script>
  // ✅ 도넛 중앙 텍스트 플러그인
  const donutCenterText = {
    id: 'donutCenterText',
    afterDraw(chart, args, pluginOptions) {
      const { ctx, chartArea } = chart;
      if (!chartArea) return;

      const text1 = pluginOptions.text1 || '';
      const text2 = pluginOptions.text2 || '';

      const centerX = (chartArea.left + chartArea.right) / 2;
      const centerY = (chartArea.top + chartArea.bottom) / 2;

      ctx.save();
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';

      ctx.font = '700 12px SUIT, Pretendard, sans-serif';
      ctx.fillStyle = '#6B7280';
      ctx.fillText(text1, centerX, centerY - 10);

      ctx.font = '800 16px SUIT, Pretendard, sans-serif';
      ctx.fillStyle = '#111827';
      ctx.fillText(text2, centerX, centerY + 12);

      ctx.restore();
    }
  };

  document.addEventListener('DOMContentLoaded', function () {
    const canvas = document.getElementById('payDonutChart');
    if (!canvas) return;

    // ✅ dataset 값은 문자열로 올 수 있으니 Number로 안전 변환
    const pay = Number(canvas.dataset.pay || 0);
    const deduct = Number(canvas.dataset.deduct || 0);
    const realPay = Number(canvas.dataset.realpay || (pay - deduct));

    new Chart(canvas, {
      type: 'doughnut',
      data: {
        labels: ['지급', '공제'],
        datasets: [{
          data: [pay, deduct],
          backgroundColor: ['#7783BD', '#BA5A6D'], // ✅ 필요하면 색만 변경
          borderWidth: 0,
          hoverOffset: 2
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 1,
        cutout: '68%',
        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: {
              label: function(context) {
                return context.label + ': ' + Number(context.parsed || 0).toLocaleString() + '원';
              }
            }
          },
          donutCenterText: {
            text1: '실지급액',
            text2: realPay.toLocaleString() + '원'
          }
        }
      },
      plugins: [donutCenterText]
    });
  });
</script>

</body>
</html>
