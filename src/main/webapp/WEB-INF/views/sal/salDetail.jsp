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
<title>급여 명세서</title>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/salDetail.css">
<link href="https://cdn.jsdelivr.net/npm/suit-font/dist/suit.min.css"
	rel="stylesheet">

<!-- ✅ Chart.js는 차트 생성 전에 1번만 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>
	<div id="layoutSidenav">

		<jsp:include page="../common/sidebar.jsp" />

		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid px-4">

					<div class="page-title-wrap">
						<h3 class="mt-4">급여 관리</h3>
					</div>
					<br>
					<h4 class="sal-List-Title">급여 명세서</h4>

					<div class="content-wrapper">

						<!-- ================= 상단 정보 ================= -->
						<div class="info-card">

							<div class="info-card-header">
								<div class="info-row info-row--single">
									<span class="info-item"> <span class="info-label">지급월
											:</span> <span class="info-value"> <c:choose>
												<c:when test="${not empty sal.yearMonthLabel}">${sal.yearMonthLabel}</c:when>
												<c:when test="${not empty sal.yearMonth}">${sal.yearMonth}</c:when>
												<c:otherwise>${sal.monthAttno}</c:otherwise>
											</c:choose>
									</span>
									</span>
								</div>

								<button type="button" class="btn-print no-print"
									onclick="window.print();">🖨 명세서 출력</button>
							</div>

							<!-- ✅ 본문(지급일 + 사원정보) -->
							<div class="info-body">
								<div class="info-row info-row--single">
									<span class="info-item"> <span class="info-label">지급일
											:</span> <span class="info-value"> <c:choose>
												<c:when test="${not empty sal.salDate}">${sal.salDate}</c:when>
												<c:when test="${not empty sal.yearMonthLabel}">${sal.yearMonthLabel} 15일</c:when>
												<c:otherwise>15일</c:otherwise>
											</c:choose>
									</span>
									</span>
								</div>

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

							<!-- ✅ 칩 영역을 카드 하단 “한 덩어리”로 -->
							<div class="info-chips">
								<div class="summary-chips">
									<span class="chip chip-pay">총 지급 <b><fmt:formatNumber
												value="${sal.payTotal}" pattern="#,###" /></b>원
									</span> <span class="chip chip-deduct">공제 <b><fmt:formatNumber
												value="${sal.deductTotal}" pattern="#,###" /></b>원
									</span> <span class="chip chip-net">실지급 <b><fmt:formatNumber
												value="${sal.realPay}" pattern="#,###" /></b>원
									</span>
								</div>
							</div>

						</div>

						<!-- 🔹 관리자 전용: 급여 정정 버튼 -->
						<c:if test="${isAdmin}">
							<div class="no-print"
								style="text-align: right; margin: 8px 0 16px;">
								<a class="btn btn-primary"
									href="${pageContext.request.contextPath}/sal/admin/edit?salNum=${sal.salNum}">
									✏️ 급여 정정 </a>
							</div>
						</c:if>



						<!-- ================= 지급 / 공제 / 비율 ================= -->
						<div class="salary-wrapper">

							<!-- ✅ 지급/공제 도넛 차트 -->
							<div class="detail-card mini-card chart-card">
								<div class="salary-box">
									<h5>지급 / 공제 비율</h5>

									<!-- ✅ 데이터는 dataset으로 안전하게 전달 -->
									<canvas id="payDonutChart" data-pay="${sal.payTotal}"
										data-deduct="${sal.deductTotal}" data-realpay="${sal.realPay}">
                                </canvas>

									<div class="chart-legend">
										<span class="legend pay">● 지급</span> <span
											class="legend deduct">● 공제</span>
									</div>
								</div>
							</div>

							<!-- 지급 -->
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

							<!-- 공제 -->
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
						<!-- salary-wrapper 끝 -->

						<!-- ================= 하단 요약 ================= -->
						<div class="net-salary-box">

							<!-- ✅ 문구: 실지급액 왼쪽 영역 -->
							<div class="net-left">
								<div class="pay-note">* 결재 승인은 월말 당일 중에 완료 될 수 있도록 협력
									부탁드립니다. *</div>
							</div>

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
										class="net-salary"><fmt:formatNumber
											value="${sal.realPay}" pattern="#,##0" />원</span>
								</div>
							</div>
						</div>

						<!-- 🔹 관리자 전용: 급여 정정 이력 -->
						<c:if test="${isAdmin && not empty edits}">
							<div class="detail-card" style="margin-top: 24px;">
								<h5 style="margin-bottom: 12px;">급여 정정 이력</h5>

								<table class="salary-table">
									<thead>
										<tr>
											<th>정정일시</th>
											<th>수정자</th>
											<th>정정 사유</th>
											<th>실지급액 (전 → 후)</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="e" items="${edits}">
											<tr>
												<td>${e.editDate}</td>
												<td>${e.editBy}</td>
												<td style="text-align: left;">${e.editReason}</td>
												<td><fmt:formatNumber value="${e.beforeRealPay}"
														pattern="#,##0" />원 → <fmt:formatNumber
														value="${e.afterRealPay}" pattern="#,##0" />원</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</c:if>


						<!-- 버튼 -->
						<div class="btn-area no-print">
							<button type="button" onclick="history.back();">급여 명세서
								목록으로 돌아가기</button>
						</div>

					</div>
					<!-- content-wrapper -->
				</div>
				<!-- container -->
			</main>

			<jsp:include page="../common/footer.jsp" />
		</div>
		<!-- layoutSidenav_content -->
	</div>
	<!-- layoutSidenav -->


	<!-- ===================== 차트 스크립트 (1번만) ===================== -->
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

    const pay = Number(canvas.dataset.pay || 0);
    const deduct = Number(canvas.dataset.deduct || 0);
    const realPay = Number(canvas.dataset.realpay || (pay - deduct));

    new Chart(canvas, {
      type: 'doughnut',
      data: {
        labels: ['지급', '공제'],
        datasets: [{
          data: [pay, deduct],
          backgroundColor: ['#7783BD', '#BA5A6D'], // ✅ 원하시면 여기 색 바꾸면 돼요
          borderWidth: 0,
          hoverOffset: 2
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
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
