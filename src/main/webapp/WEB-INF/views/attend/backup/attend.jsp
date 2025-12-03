
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="menu" value="status" scope="request" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>attend.jsp</title>

<link rel='stylesheet'
	href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/main.min.css' />
<link rel="stylesheet" href="/css/attend.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/locales-all.min.js'></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="/js/attend.js"></script>

<script type="text/javascript">
// =============================================================
//                       전역 데이터 정의
// =============================================================

var calendar;	
	
// 1. 이벤트 색상 정의
const colorMap = {
    '출근': '#4CAF50', '연차': '#2196F3', '반차': '#00BCD4', 
    '휴가': '#2196F3', '결근': '#FF9800', '지각': '#FFEB3B', 
    '조퇴': '#FFC107', '출장': '#9E9E9E', '외근': '#9E9E9E' 
};

// 2. 서버 데이터를 JavaScript 배열로 생성 (donutChart.jsp에서도 사용함)
// const로 선언하여 전역에서 접근 가능하도록 함
let appendEvents = [       
 <c:forEach var="dayAttend" items="${result}" varStatus="status">
 <c:if test="${not empty dayAttend.dateAttend}">
 { 
     title: "${dayAttend.attStatus}",     
     date: "${dayAttend.dateAttend.substring(0, 10)}", 
     allDay: true,
     color: colorMap["${dayAttend.attStatus}"],
     attStatus: "${dayAttend.attStatus}",
     
     // 휴가/결근 등은 시간 제외 처리
     inTime: "<c:choose><c:when test="${empty dayAttend.inTime or dayAttend.attStatus eq '휴가' or dayAttend.attStatus eq '결근'}"></c:when><c:otherwise>${dayAttend.inTime.substring(11, 19)}</c:otherwise></c:choose>",
     outTime: "<c:choose><c:when test="${empty dayAttend.outTime or dayAttend.attStatus eq '휴가' or dayAttend.attStatus eq '결근'}"></c:when><c:otherwise>${dayAttend.outTime.substring(11, 19)}</c:otherwise></c:choose>",
     
     breakTime: "01:00:00", 
     dayFulltime: "${dayAttend.dayFulltime}" // 예: "0 8:0:0.0"
  }<c:if test="${!status.last && not empty result[status.index + 1].dateAttend}">,</c:if>
 </c:if>
 </c:forEach>
];

// =============================================================
//                       FullCalendar 초기화
// =============================================================
document.addEventListener('DOMContentLoaded', function(){
    
    var calendarEl = document.getElementById('calendar'); 

    if (!calendarEl) {
        console.error("#calendar 요소를 찾을 수 없습니다.");
        return;
    }
    
    calendar = new FullCalendar.Calendar(calendarEl, {
        initialDate: new Date(),
        initialView: 'dayGridMonth',
        headerToolbar: {
             left: 'prev,next today',
             center: 'title',
             right: 'dayGridMonth,timeGridWeek,timeGridDay'
        },
        locale: 'ko', 
        events: appendEvents, // 전역 변수 appendEvents 사용
        
        dateClick: function(info) {
             const clickedDate = info.dateStr; 
             const workEvent = appendEvents.find(event => event.date === clickedDate);

             $('#inTimeDisplay').text("출근시간: -");
             $('#outTimeDisplay').text("퇴근시간: -"); 
             
             if (workEvent) {
                 if (workEvent.inTime && workEvent.inTime.trim() !== '') {                 
                     $('#inTimeDisplay').text("출근시간: " + workEvent.inTime); 
                 } else {
                     $('#inTimeDisplay').text("출근시간: 기록 없음");
                 }
                 
                 if (workEvent.outTime && workEvent.outTime.trim() !== '') {
                     $('#outTimeDisplay').text("퇴근시간: " + workEvent.outTime); 
                 } else {
                     $('#outTimeDisplay').text("퇴근시간: 기록 없음");
                 }
             } else {  
                 $('#inTimeDisplay').text("출근시간: 기록 없음");
                 $('#outTimeDisplay').text("퇴근시간: 기록 없음");
             }
             
             // [중요] 여기가 작동하려면 updateDonutChart가 js파일의 ready() 밖으로 나와있어야 합니다.
             updateDonutChart(appendEvents, clickedDate);
        }
    });    
    
    calendar.render();
 	
    const initialDate = calendar.getDate().toISOString().substring(0, 10);
    
    // donutChart.jsp의 차트 생성 시점과 맞추기 위해 setTimeout을 살짝 줄 수도 있음
    setTimeout(() => {
        updateDonutChart(appendEvents, initialDate); 
    }, 100);
});
</script>
</head>

<body class="sb-nav-fixed">

	<jsp:include page="../common/header.jsp" flush="true" />

	<div id="layoutSidenav">
		<jsp:include page="../common/sidebar.jsp" flush="true" />

		<div id="layoutSidenav_content">
			<main id="content-area">
				<div class="main-layout-container">

					<div class="report-section">
						<jsp:include page="../attend/donutChart.jsp" flush="true" />
					</div>

					<div class="calendar-section">
						<div class="top-calendar-group">
							<div class="controls">
								<button class="btn-checkin" id="checkIn">출 근</button>
								<button class="btn-checkout" id="checkOut">퇴 근</button>

								<div class="time-display">
									<p id="inTimeDisplay">출근시간: -</p>
									<p id="outTimeDisplay">퇴근시간: -</p>
								</div>
								<button class="btn-outside">외 근</button>
							</div>
							<div class="calendar">
								<div id="calendar"></div>
							</div>
						</div>

						<div class="actions">
							<button id="btnVacation">휴가 신청</button>
							<button id="btnCommuteCorrection">출/퇴근 정정 신청</button>
						</div>
					</div>
				</div>
			</main>
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