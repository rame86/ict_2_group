<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="menu" value="status" scope="request" />


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>attend</title>
<link rel="stylesheet" href="/css/attend.css">

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/locales-all.min.js'></script>

<script src="/js/attend.js"></script>
</head>

<body class="sb-nav-fixed">

	<!-- 헤더(헤더에 로그인정보 히든속성으로 저장) -->
	<jsp:include page="../common/header.jsp" flush="true" />

	<div id="layoutSidenav">
		<!-- 사이드 바 -->
		<jsp:include page="../common/sidebar.jsp" flush="true" />

		<!-- 메인 바 -->
		<div id="layoutSidenav_content">
		
			<main id="content-area">
			
				<div class="main-layout-container">				
					<div class="report-section">
						<jsp:include page="../attend/donutChart.jsp" flush="true" />
					</div>

					<div class="calendar-section">

						<div class="top-calendar-group">

							<div class="controls">
								<button class="btn-checkin">출 근</button>
								<button class="btn-checkout">퇴 근</button>

								<div class="time-display">
									<p>출근시간: -</p>
									<p>퇴근시간: -</p>
								</div>

								<button class="btn-outside">외 근</button>
							</div>
							<div class="calendar">
								<jsp:include page="../attend/calendar.jsp" flush="true" />
							</div>
						</div>

						<div class="actions">
							<button id="btnVacation">휴가 신청</button>
							<button id="btnCommuteCorrection">출/퇴근 정정 신청</button>
						</div>
					</div>

				</div>
			</main>

			<!-- 푸터 -->
			<jsp:include page="../common/footer.jsp" flush="true" />

		</div>

	</div>

	<div id="vacationModal" class="modal">
		<div class="modal-content">
			<span class="close">&times;</span>
			<div id="vacationFormContent">
				<jsp:include page="vacationForm.jsp" flush="true" />
			</div>
		</div>
	</div>

	<div id="commuteCorrectionModal" class="modal">
		<div class="modal-content">
			<span class="close">&times;</span>
			<div id="commuteCorrectionFormContent">
				<jsp:include page="commuteCorrectionForm.jsp" flush="true" />
			</div>
		</div>
	</div>

</body>
</html>