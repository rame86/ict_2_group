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
<link
	href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/main.min.css'
	rel='stylesheet' />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/locales-all.min.js'></script>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="/js/attend.js"></script>

<script type="text/javascript">
//*******************달력 영역 ************************
//이벤트 색상 정의
const colorMap = {
'출근': '#4CAF50', 
'연차': '#2196F3', 
'반차': '#00BCD4', 
'휴가': '#2196F3', 
'결근': '#FF9800', 
'지각': '#FFEB3B', 
'조퇴': '#FFC107', 
'출장': '#9E9E9E' 
};

//JSP/JSTL을 사용하여 서버 데이터를 JavaScript 배열로 생성 
const appendEvents = [       
 <c:forEach var="dayAttend" items="${result}" varStatus="status">
 <c:if test="${not empty dayAttend.dateAttend}">
 { 
     title: "${dayAttend.attStatus}",     
     date: "${dayAttend.dateAttend.substring(0, 10)}", 
     allDay: true,
     color: colorMap["${dayAttend.attStatus}"],
     attStatus: "${dayAttend.attStatus}",
     
     
     inTime: "<c:choose><c:when test="${empty dayAttend.inTime or dayAttend.attStatus eq '휴가' or dayAttend.attStatus eq '결근'}"></c:when><c:otherwise>${dayAttend.inTime.substring(11, 19)}</c:otherwise></c:choose>",
           
     
     outTime: "<c:choose><c:when test="${empty dayAttend.outTime or dayAttend.attStatus eq '휴가' or dayAttend.attStatus eq '결근'}"></c:when><c:otherwise>${dayAttend.outTime.substring(11, 19)}</c:otherwise></c:choose>",

     breakTime: "01:00:00", 
     dayFulltime: "${dayAttend.dayFulltime}"
  }<c:if test="${!status.last && not empty result[status.index + 1].dateAttend}">,</c:if>
 </c:if>
 </c:forEach>
];

document.addEventListener('DOMContentLoaded', function() {

    // 데이터 확인 (이 부분은 유지)
    console.log("--- FullCalendar 이벤트 데이터 (appendEvents) 시작 ---");
    console.log(appendEvents);
    console.log("--- FullCalendar 이벤트 데이터 (appendEvents) 끝 ---");

    var calendarEl = document.getElementById('calendar'); 

    if (!calendarEl) {
        console.error("FullCalendar를 초기화할 DOM 요소 (#calendar)를 찾을 수 없습니다.");
        return;
    }
    
    var calendar = new FullCalendar.Calendar(calendarEl, {
      initialDate: '2025-11-19', 
      initialView: 'dayGridMonth',
      headerToolbar: {
          left: 'prev,next today',
          center: 'title',
          right: 'dayGridMonth,timeGridWeek,timeGridDay'
      },
      locale: 'ko', 
      events: appendEvents, 
      
      // 2. 날짜 클릭 이벤트 처리 (단순화된 로직)
      dateClick: function(info) {
          const clickedDate = info.dateStr; // 클릭한 날짜 (YYYY-MM-DD 형식)
          
          // 해당 날짜의 첫 번째 이벤트 객체를 찾습니다.
          const workEvent = appendEvents.find(event => event.date === clickedDate);

          // 우선 출퇴근 표시 영역을 초기화합니다.
          $('#inTimeDisplay').text("출근시간: -");
          $('#outTimeDisplay').text("퇴근시간: -"); 
          

			if (workEvent) {
              
              const inTime = workEvent.inTime;
              const outTime = workEvent.outTime;
              
              
              // 1. inTime
              if (inTime && inTime.trim() !== '') {              
                  $('#inTimeDisplay').text("출근시간: " + inTime); 
              } else {
 
                  $('#inTimeDisplay').text("출근시간: 기록 없음");
              }
      	   
              // 2. outTime
              if (outTime && outTime.trim() !== '') {
                  $('#outTimeDisplay').text("퇴근시간: " + outTime); 
              } else {
       
                  $('#outTimeDisplay').text("퇴근시간: 기록 없음");
              }
            
          } else {  
                  
              $('#inTimeDisplay').text("출근시간: 기록 없음");
              $('#outTimeDisplay').text("퇴근시간: 기록 없음");
          }
      }
    });
    calendar.render();
    
  //****************** 도넛 그래프 영역 **********************************
    // --- 1. 월간 근무 시간 데이터 설정 (바깥쪽 도넛) ---
    const monthlyTotalHours = 209;
    const monthlyWorkedHours = 107;
    const monthlyRemainingHours = monthlyTotalHours - monthlyWorkedHours;
    const monthlyWorkedPercentage = ((monthlyWorkedHours / monthlyTotalHours) * 100).toFixed(1);

    // --- 2. 주간 근무 시간 데이터 설정 (안쪽 도넛) ---
    const weeklyTotalHours = 40;
    const weeklyWorkedHours = 37;
    const weeklyRemainingHours = weeklyTotalHours - weeklyWorkedHours;
    const weeklyWorkedPercentage = ((weeklyWorkedHours / weeklyTotalHours) * 100).toFixed(1);

    // --- HTML 요약 상자에 내용 채우기 (문자열 결합 방식으로 통일) ---
    document.getElementById('summaryBox').innerHTML = 
        '<h3>월간 근무 현황</h3>' +
        '<p>총 근무: **' + monthlyWorkedHours + ' / ' + monthlyTotalHours + ' 시간** (' + monthlyWorkedPercentage + '%)</p>' +
        '<hr style="border: none; border-top: 1px dashed #ccc; margin: 10px 50px;">' +
        '<h3>주간 근무 현황</h3>' +
        '<p>총 근무: **' + weeklyWorkedHours + ' / ' + weeklyTotalHours + ' 시간** (' + weeklyWorkedPercentage + '%)</p>';

    
    // --- 차트에 사용될 데이터셋 ---
    const data = {
        labels: [], 
        datasets: [
            // 바깥쪽 도넛 (월간)
            {
                label: '월간 근무 시간',
                data: [monthlyWorkedHours, monthlyRemainingHours],
                backgroundColor: [
                    'rgba(54, 162, 235, 0.7)', 
                    'rgba(201, 203, 207, 0.7)' 
                ],
                borderColor: 'white', 
                borderWidth: 2,
                hoverOffset: 4,
                cutout: '65%',
                borderRadius: 5 
            },
            // 안쪽 도넛 (주간)
            {
                label: '주간 근무 시간',
                data: [weeklyWorkedHours, weeklyRemainingHours],
                backgroundColor: [
                    'rgb(255, 159, 64)',
                    'rgb(230, 230, 230)'
                ],
                borderColor: 'white',
                borderWidth: 2,
                hoverOffset: 4,
                cutout: '35%',
                borderRadius: 5
            }
        ]
    };
       
    const config = {
        type: 'doughnut',
        data: data,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        generateLabels: function(chart) {
                            // 월간 근무, 월간 남은 시간 (백틱 제거)
                            const monthlyLabels = [{
                                text: '월간 근무 (' + monthlyWorkedPercentage + '%)',
                                fillStyle: 'rgba(54, 162, 235, 0.7)',
                                strokeStyle: 'white',
                                lineWidth: 2
                            }, {
                                text: '월간 남은 (' + (100 - monthlyWorkedPercentage).toFixed(1) + '%)',
                                fillStyle: 'rgba(201, 203, 207, 0.7)',
                                strokeStyle: 'white',
                                lineWidth: 2
                            }];
                            
                            // 주간 근무, 주간 남은 시간 (백틱 제거)
                            const weeklyLabels = [{
                                text: '주간 근무 (' + weeklyWorkedPercentage + '%)',
                                fillStyle: 'rgb(255, 159, 64)',
                                strokeStyle: 'white',
                                lineWidth: 2
                            }, {
                                text: '주간 남은 (' + (100 - weeklyWorkedPercentage).toFixed(1) + '%)',
                                fillStyle: 'rgb(230, 230, 230)',
                                strokeStyle: 'white',
                                lineWidth: 2
                            }];

                            return [...monthlyLabels, ...weeklyLabels];
                        }
                    }
                },
                title: {
                    display: true,
                    text: '월간 및 주간 근무 시간 비교',
                    font: {
                        size: 18,
                        weight: 'bold'
                    }
                },
                tooltip: {
                    callbacks: {
                        // 툴팁 출력 설정 (백틱 제거)
                        label: function(context) {
                            const datasetIndex = context.datasetIndex;
                            const value = context.parsed;
                            let total, labelPrefix, percentage;

                            if (datasetIndex === 0) { // 월간 데이터셋
                                total = monthlyTotalHours;
                                labelPrefix = (context.dataIndex === 0) ? '월간 근무: ' : '월간 남은: ';
                            } else { // 주간 데이터셋
                                total = weeklyTotalHours;
                                labelPrefix = (context.dataIndex === 0) ? '주간 근무: ' : '주간 남은: ';
                            }
                            
                            percentage = ((value / total) * 100).toFixed(1);
                            
                            // 툴팁 최종 리턴값도 문자열 결합으로 변경
                            return labelPrefix + value + '시간 (' + percentage + '%)';
                        }
                    }
                }
            }
        },
    };

    // 캔버스 요소를 가져와 차트 생성
    const nestedWorkHoursChart = new Chart(
        document.getElementById('nestedWorkHoursChart'),
        config
    );
    
	//****************** 도넛 그래프 영역 끝 **********************************
    
    
    
    
});
</script>


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
						<div class="chart-container">
							<canvas id="nestedWorkHoursChart"></canvas>
						</div>

						<div id="summaryBox"></div>
					</div>

					<div class="calendar-section">

						<div class="top-calendar-group">

							<div class="controls">
								<button class="btn-checkin">출 근</button>
								<button class="btn-checkout">퇴 근</button>

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