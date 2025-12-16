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
								<div>
									<span class="info-label"> 지급월 : <c:choose>
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
								</div>
								<button type="button" class="btn-print no-print"
									onclick="window.print();">🖨 명세서 출력</button>
							</div>

							<div class="info-row">
								<span class="info-label"> 지급일 : <c:choose>
										<c:when test="${not empty sal.salDate}">
                                        ${sal.salDate}
                                    </c:when>
										<c:when test="${not empty sal.yearMonthLabel}">
                                        ${sal.yearMonthLabel} 15일
                                    </c:when>
										<c:otherwise>15일</c:otherwise>
									</c:choose>
								</span>
							</div>
<br>
							<div class="info-row">
								<span class="info-label">사번 : ${emp.empNo}</span> <span
									class="info-label">이름 : ${emp.empName}</span> <span
									class="info-label">부서 : ${emp.deptName}</span> <span
									class="info-label">재직상태 : ${emp.statusName}</span>
							</div>

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

						<!-- ================= 지급 / 공제 / 비율 ================= -->
						<div class="salary-wrapper">

							<!-- ✅ 지급 / 공제 원형 그래프 -->
							<div class="detail-card mini-card chart-card">
								<div class="salary-box">
									<h5>지급 / 공제 비율</h5>

									<canvas id="payDonutChart" data-pay="${sal.payTotal}"
										data-deduct="${sal.deductTotal}">
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

						<!-- 버튼 -->
						<div class="btn-area no-print">
							<button type="button" onclick="history.back();">급여 명세서
								목록으로 돌아가기</button>
						</div>

					</div>
				</div>
			</main>

			<jsp:include page="../common/footer.jsp" />

			<script>
				const pay = $
				{
					sal.payTotal
				};
				const deduct = $
				{
					sal.deductTotal
				};

				const ctx = document.getElementById('payDonutChart');

				new Chart(
						ctx,
						{
							type : 'doughnut',
							data : {
								labels : [ '지급', '공제' ],
								datasets : [ {
									data : [ pay, deduct ],
									backgroundColor : [ '#3b82f6', '#fb923c' ],
									borderColor: '#000000',   
									borderWidth : 0
								} ]
							},
							options : {
								responsive : true,
								cutout : '65%',
								plugins : {
									legend : {
										display : false
									},
									tooltip : {
										callbacks : {
											label : function(context) {
												return context.label
														+ ': '
														+ context.parsed
																.toLocaleString()
														+ '원';
											}
										}
									}
								}
							}
						});
			</script>

		</div>
	</div>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

	<script>
		document
				.addEventListener(
						'DOMContentLoaded',
						function() {
							const canvas = document
									.getElementById('payDonutChart');
							if (!canvas)
								return;

							// Chart.js 로드 체크
							if (typeof Chart === 'undefined') {
								console
										.error('Chart.js가 로드되지 않았어요. <script src="...chart.js"> 위치를 확인해주세요.');
								return;
							}

							const pay = Number(canvas.dataset.pay || 0);
							const deduct = Number(canvas.dataset.deduct || 0);

							// 값이 둘 다 0이면 임시로 1 넣어서 도넛이 안 보이는 문제 방지(선택)
							const dataPay = pay > 0 ? pay : 0;
							const dataDed = deduct > 0 ? deduct : 0;

							new Chart(canvas, {
								type : 'doughnut',
								data : {
									labels : [ '지급', '공제' ],
									datasets : [ {
										data : [ dataPay, dataDed ],
										backgroundColor : [ '#2563eb', '#ef4444' ],
										borderColor: '#000000',
										borderWidth : 0,
									} ]
								},
								options : {
									responsive : true,
									maintainAspectRatio : false,
									cutout : '65%',
									plugins : {
										legend : {
											display : false
										}
									}
								}
							});
						});
	</script>

</body>
</html>
