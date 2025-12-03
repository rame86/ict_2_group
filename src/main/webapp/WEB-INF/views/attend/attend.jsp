<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>attend.jsp</title>

<link rel='stylesheet'
	href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/main.min.css' />
<link rel="stylesheet" href="/css/attend.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script	src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
<script	src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/locales-all.min.js'></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script src="/js/attend.js"></script>

<script type="text/javascript">
// =============================================================
//                       전역 데이터 정의
// =============================================================

var calendar; // FullCalendar 인스턴스 저장용 변수.

// 1. 이벤트 색상 정의: 근태 상태별 캘린더 색상 지정.
const colorMap = {
    '출근': '#4CAF50', '연차': '#2196F3', '반차': '#00BCD4', 
    '휴가': '#2196F3', '결근': '#FF9800', '지각': '#FFC107', 
    '조퇴': '#FFC107', '출장': '#9E9E9E', '외근': '#9E9E9E' 
};

// 2. 서버 데이터를 JavaScript 배열로 생성: DB에서 가져온 근태 기록을 캘린더 이벤트 형식으로 변환.
// appendEvents 변수는 FullCalendar 초기화 및 차트 업데이트에 사용됨.
let appendEvents = [       
 <c:forEach var="dayAttend" items="${result}" varStatus="status">
 <c:if test="${not empty dayAttend.dateAttend}">
 { 
     title: "${dayAttend.attStatus}",     // 근태 상태(출근, 휴가 등)
     date: "${dayAttend.dateAttend.substring(0, 10)}", // 날짜 YYYY-MM-DD
     allDay: true,
     color: colorMap["${dayAttend.attStatus}"],
     attStatus: "${dayAttend.attStatus}",
     
     // inTime: 휴가/결근 시 시간 제외 처리. HH:MM:SS 포맷.
     inTime: "<c:choose><c:when test="${empty dayAttend.inTime or dayAttend.attStatus eq '휴가' or dayAttend.attStatus eq '결근'}"></c:when><c:otherwise>${dayAttend.inTime.substring(11, 19)}</c:otherwise></c:choose>",
     // outTime: 휴가/결근 시 시간 제외 처리. HH:MM:SS 포맷.
     outTime: "<c:choose><c:when test="${empty dayAttend.outTime or dayAttend.attStatus eq '휴가' or dayAttend.attStatus eq '결근'}"></c:when><c:otherwise>${dayAttend.outTime.substring(11, 19)}</c:otherwise></c:choose>",
     
     breakTime: "01:00:00", // 기본 휴게시간
     dayFulltime: "${dayAttend.dayFulltime}", // 일일 총 근무 시간. 예: "0 8:0:0.0"
     memo: "${dayAttend.memo}" // 특이사항 메모
  }<c:if test="${!status.last && not empty result[status.index + 1].dateAttend}">,</c:if>
 </c:if>
 </c:forEach>
];

// =============================================================
//                       FullCalendar 초기화
// =============================================================
document.addEventListener('DOMContentLoaded', function(){
    
    var calendarEl = document.getElementById('calendar'); 

    // 캘린더 요소 없으면 에러 로그 찍고 종료.
    if (!calendarEl) {
        console.error("#calendar 요소를 찾을 수 없음.");
        return;
    }
    
    calendar = new FullCalendar.Calendar(calendarEl, {
        initialDate: new Date(),
        initialView: 'dayGridMonth',
        headerToolbar: {
             left: 'prev,next', // 이전/다음 달 이동 버튼.
             center: 'title', // 현재 월 표시.
             right: 'today' // 오늘 날짜로 이동.
        },
        locale: 'ko', // 한국어 설정.
        events: appendEvents, // 초기 로딩된 근태 이벤트 목록 사용.
        
        // 캘린더 날짜 클릭 시 이벤트 핸들러.
        dateClick: function(info) {
             const clickedDate = info.dateStr; 
             // 클릭한 날짜의 근태 기록 찾기.
             const workEvent = appendEvents.find(event => event.date === clickedDate);

             // 시간 표시 영역 초기화.
             $('#inTimeDisplay').text("출근시간: -");
             $('#outTimeDisplay').text("퇴근시간: -"); 
             $('#fieldworkDisplay').text(""); // 특이사항 영역 초기화.
             
             if (workEvent) {
                 // 출근 시간 표시.
                 if (workEvent.inTime && workEvent.inTime.trim() !== '') {                 
                     $('#inTimeDisplay').text("출근시간: " + workEvent.inTime); 
                 } else {
                     $('#inTimeDisplay').text("출근시간: 기록 없음");
                 }
                 
                 // 퇴근 시간 표시.
                 if (workEvent.outTime && workEvent.outTime.trim() !== '') {
                     $('#outTimeDisplay').text("퇴근시간: " + workEvent.outTime); 
                 } else {
                     $('#outTimeDisplay').text("퇴근시간: 기록 없음");
                 }
                 
                 // 메모(특이사항) 표시. null 또는 공백이 아닐 때만 출력함.
                 if (workEvent.memo && workEvent.memo.trim() !== '' && workEvent.memo.trim() !== 'null') {
                	 $('#fieldworkDisplay').text("특이사항: " + workEvent.memo);
                 } else {                
                	 $('#fieldworkDisplay').text(""); // 메모 없으면 비워둠.
                 }
                 
             } else {  
                 // 해당 날짜에 근태 기록이 없으면 모두 '기록 없음'으로 표시.
                 $('#inTimeDisplay').text("출근시간: 기록 없음");
                 $('#outTimeDisplay').text("퇴근시간: 기록 없음");
             }
            
             // 도넛 차트 업데이트 함수 호출 (attend.js에 정의됨).
             updateDonutChart(appendEvents, clickedDate);
        }
    });    
    
    calendar.render(); // 캘린더 렌더링.
 	
    const initialDate = calendar.getDate().toISOString().substring(0, 10);
    
    // 차트 생성 시점에 맞춰 초기 데이터로 차트 업데이트.
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
									<p id="fieldworkDisplay"></p>
								</div>
								<button class="btn-fieldwork" id="fieldwork">외 근</button>
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