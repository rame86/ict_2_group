<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>사원 근무 기록 달력</title>

<link
	href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/main.min.css'
	rel='stylesheet' />


</head>
<body>

	<div id="calendar"></div>

	<script
		src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>

	<script
		src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/locales-all.min.js'></script>


	<script>
	// 이벤트 색상 정의
    const colorMap = {
        // 출퇴근 정상 기록 (기본)        
        '출근': '#4CAF50', // 초록색 (정상근무와 동일하게 가정)
        // 휴가 상태
        '연차': '#2196F3', // 파란색
        '반차': '#00BCD4', // 하늘색
        '휴가': '#2196F3', // 파란색
        // 결근 상태
        '결근': '#FF9800', // 주황색
        '지각': '#FFEB3B', // 노란색
        '조퇴': '#FFC107', // 호박색
        // 기타
        '출장': '#9E9E9E' // 회색
    };


    const appendEvents = [       
        <c:forEach var="dayAttend" items="${result}" varStatus="status">
        { 
            title: "${dayAttend.attStatus}", 
            date: "${dayAttend.dateAttend}",
            // **[제거] start와 end 속성 제거**
            allDay: true,
            color: colorMap["${dayAttend.attStatus}"],
            
            // **[이동] 상세 정보를 이벤트 객체 자체에 포함**
            attStatus: "${dayAttend.attStatus}",
            inTime: "${dayAttend.inTime}",
            outTime: "${dayAttend.outTime}",
            breakTime: "01:00:00", // 휴게 시간은 Mock 값 그대로 유지
            dayFulltime: "${dayAttend.dayFulltime}"
         } <c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    console.log("FullCalendar Events Data:", appendEvents);    
    // **[삭제] mockWorkDetails 변수 제거**

        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');

            var calendar = new FullCalendar.Calendar(calendarEl, {
                // 현재 날짜를 2025년 11월 19일로 설정하여 예시 데이터가 보이도록 합니다.
                initialDate: '2025-11-19', 
                initialView: 'dayGridMonth',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                locale: 'ko', // 한글 설정
                
                // 1. FullCalendar 이벤트 소스 설정
                events: appendEvents, 
                
                // 2. 날짜 클릭 이벤트 처리
                dateClick: function(info) {
                    const clickedDate = info.dateStr; // 클릭한 날짜 (YYYY-MM-DD 형식)
                    // 0=일요일, 1=월요일, ..., 5=금요일, 6=토요일
                    const clickedDay = new Date(clickedDate).getDay(); 
                    
                    // **[수정] 해당 날짜의 이벤트 객체를 찾습니다.**
                    const workEvent = appendEvents.find(event => event.date === clickedDate);
                    
                    // 토요일(6) 또는 일요일(0)인지 확인
                    const isWeekend = (clickedDay === 0 || clickedDay === 6);


                    if (workEvent) {
                        // 근무 기록이 있는 경우 (찾은 workEvent 사용)
                        
                        alert(
                            `[${clickedDate} 근무 상세]\n` +
                            `상태: ${workEvent.attStatus}\n` +
                            `출근: ${workEvent.inTime}\n` +
                            `퇴근: ${workEvent.outTime}\n` +
                            `휴게시간: ${workEvent.breakTime}\n` +
                            `총 근무 시간: ${workEvent.dayFulltime}`
                        );
                    } else if (isWeekend) {
                        // 근무 기록은 없지만 토/일인 경우 (휴무일로 표시)
                        alert(`[${clickedDate}]은(는) **휴무일 (주말)** 입니다.`);
                    } else {
                        // 근무 기록이 없는 날짜 (평일 또는 기타 휴일)
                        alert(`[${clickedDate}] 해당 날짜에는 근무 기록이 없습니다. (근무 기록 누락 가능성)`);
                    }
                }
            });

            calendar.render();
        });
    </script>
</body>
</html>