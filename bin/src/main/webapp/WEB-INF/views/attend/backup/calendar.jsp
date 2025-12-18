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
    		'퇴근': '#2196F3', '출근': '#4CAF50', '지각': '#FFC107', '조퇴': '#FFC107',
    		'외근': '#9E9E9E', '연차': '#2196F3', '오전반차': '#00BCD4', '오후반차': '#00BCD4',
    		'결근': '#FF9800', '출장': '#9E9E9E'
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
                               
            });

            calendar.render();
        });
    </script>
</body>
</html>