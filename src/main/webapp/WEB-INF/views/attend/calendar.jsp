<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사원 근무 기록 달력</title>

    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/main.min.css' rel='stylesheet' />
    
    <style>
        /* 토요일과 일요일의 날짜 텍스트를 빨간색으로 설정 */
        .fc-day-sat .fc-daygrid-day-number,
        .fc-day-sun .fc-daygrid-day-number {
            color: #F44336; /* 빨간색 */
        }
        
        /* 요일 헤더(토/일)도 빨간색으로 설정 */
        .fc-day-sat.fc-col-header-cell .fc-col-header-cell-cushion,
        .fc-day-sun.fc-col-header-cell .fc-col-header-cell-cushion {
            color: #F44336;
        }

        /* 참고: 금요일은 기본 색상(검정)을 유지합니다. */
    </style>
    </head>
<body>

    <div id="calendar"></div>

    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
    
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/locales-all.min.js'></script>


    <script>
      
        const mockEvents = [
            { title: "근무", start: "2025-11-03", allDay: true, color: "#4CAF50" },
            { title: "근무", start: "2025-11-04", allDay: true, color: "#4CAF50" },
            { title: "근무", start: "2025-11-05", allDay: true, color: "#4CAF50" },
            { title: "근무", start: "2025-11-06", allDay: true, color: "#4CAF50" },
            { title: "근무", start: "2025-11-07", allDay: true, color: "#4CAF50" },
            { title: "근무", start: "2025-11-10", allDay: true, color: "#4CAF50" },
            { title: "근무", start: "2025-11-11", allDay: true, color: "#4CAF50" },
            { title: "근무", start: "2025-11-12", allDay: true, color: "#4CAF50" },
            { title: "근무", start: "2025-11-13", allDay: true, color: "#4CAF50" },
            { title: "근무", start: "2025-11-14", allDay: true, color: "#4CAF50" },
            { title: "근무", start: "2025-11-17", allDay: true, color: "#4CAF50" },
            { title: "근무", start: "2025-11-18", allDay: true, color: "#4CAF50" },
            { title: "근무", start: "2025-11-19", allDay: true, color: "#4CAF50" }
        ];

        // 2. 특정 날짜 근무 상세 정보 (API 2의 응답 역할)
        const mockWorkDetails = {
            status: "정상 근무",
            checkIn: "09:00:00",
            checkOut: "17:00:00",
            breakTime: "01:00:00",
            totalWorkHours: "07:00:00"
        };


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
                
                // 1. FullCalendar 이벤트 소스 설정 (Mock 데이터 직접 사용)
                events: mockEvents, 
                
                // 2. 날짜 클릭 이벤트 처리
                dateClick: function(info) {
                    const clickedDate = info.dateStr; // 클릭한 날짜 (YYYY-MM-DD 형식)
                    // 0=일요일, 1=월요일, ..., 5=금요일, 6=토요일
                    const clickedDay = new Date(clickedDate).getDay(); 
                    
                    // 해당 날짜에 근무 기록이 있는지 mockEvents 배열에서 확인
                    const isWorkDay = mockEvents.some(event => event.start === clickedDate);
                    
                    // 토요일(6) 또는 일요일(0)인지 확인
                    const isWeekend = (clickedDay === 0 || clickedDay === 6);


                    if (isWorkDay) {
                        // 근무 기록이 있는 경우
                        
                        // Mock 데이터 사용: 모든 근무일은 동일한 상세 정보를 가집니다.
                        alert(
                            `[${clickedDate} 근무 상세]\n` +
                            `상태: ${mockWorkDetails.status}\n` +
                            `출근: ${mockWorkDetails.checkIn}\n` +
                            `퇴근: ${mockWorkDetails.checkOut}\n` +
                            `휴게시간: ${mockWorkDetails.breakTime}\n` +
                            `총 근무 시간: ${mockWorkDetails.totalWorkHours}`
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