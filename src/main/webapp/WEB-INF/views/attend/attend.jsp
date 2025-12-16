<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>attend.jsp</title>

<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/main.min.css' />
<link rel="stylesheet" href="/css/attend.css">

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/locales-all.min.js'></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="/js/attend.js"></script>

<script type="text/javascript">
// =============================================================
//                       전역 데이터 정의
// =============================================================
var calendar; // FullCalendar 인스턴스

// 1. 이벤트 색상 정의
const colorMap = {
    '출근': '#4CAF50', '연차': '#2196F3', '반차': '#00BCD4', 
    '휴가': '#2196F3', '결근': '#FF9800', '지각': '#FFC107', 
    '조퇴': '#FFC107', '출장': '#9E9E9E', '외근': '#9E9E9E' 
};

// 2. 서버 데이터 -> FullCalendar 이벤트 배열 변환
let appendEvents = [       
    <c:forEach var="dayAttend" items="${result}" varStatus="status">
    <c:if test="${not empty dayAttend.dateAttend}">
    { 
        title: "${dayAttend.attStatus}",
        date: "${dayAttend.dateAttend.substring(0, 10)}",
        allDay: true,
        color: colorMap["${dayAttend.attStatus}"],
        attStatus: "${dayAttend.attStatus}",
        
        // 휴가/결근 시 시간 표시 제외
        inTime: "<c:choose><c:when test="${empty dayAttend.inTime or dayAttend.attStatus eq '휴가' or dayAttend.attStatus eq '결근'}"></c:when><c:otherwise>${dayAttend.inTime.substring(11, 19)}</c:otherwise></c:choose>",
        outTime: "<c:choose><c:when test="${empty dayAttend.outTime or dayAttend.attStatus eq '휴가' or dayAttend.attStatus eq '결근'}"></c:when><c:otherwise>${dayAttend.outTime.substring(11, 19)}</c:otherwise></c:choose>",
        
        breakTime: "01:00:00",
        dayFulltime: "${dayAttend.dayFulltime}",
        memo: "${dayAttend.memo}"
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
        console.error("#calendar 요소를 찾을 수 없음.");
        return;
    }
    
    calendar = new FullCalendar.Calendar(calendarEl, {
        initialDate: new Date(),
        initialView: 'dayGridMonth',
        headerToolbar: {
             left: 'prev,next',
             center: 'title',
             right: 'today'
        },
        locale: 'ko',
        events: appendEvents,
        fixedWeekCount: false,
        // 날짜 클릭 이벤트
        dateClick: function(info) {
             const clickedDate = info.dateStr; 
             const workEvent = appendEvents.find(event => event.date === clickedDate);

             // 디스플레이 초기화
             $('#inTimeDisplay').text("출근시간: -");
             $('#outTimeDisplay').text("퇴근시간: -"); 
             $('#fieldworkDisplay').text(""); 
             
             if (workEvent) {
                 // 출근
                 if (workEvent.inTime && workEvent.inTime.trim() !== '') {                 
                     $('#inTimeDisplay').text("출근시간: " + workEvent.inTime); 
                 } else {
                     $('#inTimeDisplay').text("출근시간: 기록 없음");
                 }
                 // 퇴근
                 if (workEvent.outTime && workEvent.outTime.trim() !== '') {
                     $('#outTimeDisplay').text("퇴근시간: " + workEvent.outTime); 
                 } else {
                     $('#outTimeDisplay').text("퇴근시간: 기록 없음");
                 }
                 // 특이사항
                 if (workEvent.memo && workEvent.memo.trim() !== '' && workEvent.memo.trim() !== 'null') {
                     $('#fieldworkDisplay').text("특이사항: " + workEvent.memo);
                 } else {                
                     $('#fieldworkDisplay').text("");
                 }
             } else {  
                 $('#inTimeDisplay').text("출근시간: 기록 없음");
                 $('#outTimeDisplay').text("퇴근시간: 기록 없음");
             }
            
             updateDonutChart(appendEvents, clickedDate);
        }
    });    
    
    calendar.render(); 
    
    const initialDate = calendar.getDate().toISOString().substring(0, 10);
    setTimeout(() => {
        updateDonutChart(appendEvents, initialDate); 
    }, 100);
});

// =============================================================
//                       모달 및 버튼 이벤트 제어
// =============================================================
$(document).ready(function() {
 
    // 모달 선택자 정의
    const $vacationModal = $('#vacationModal');
    const $correctionModal = $('#commuteCorrectionModal');
    
    // --- [1] 모달 열기 이벤트 ---
    
    // 휴가 신청 버튼
    $('#btnVacation').on('click', function() {
        $vacationModal.show(); // .css('display', 'block')과 동일
    });
    
    // 출/퇴근 정정 신청 버튼
    $('#btnCommuteCorrection').on('click', function() {
        $correctionModal.show();
        // 모달 열 때 폼 리셋 (선택사항)
        if($('#correctionForm').length) {
            $('#correctionForm')[0].reset();
            $('#existingTime').val('');
        }
    });

    // --- [2] 모달 닫기 이벤트 ---
    
    // X 버튼 클릭
    $('.modal .close').on('click', function() {
        $(this).closest('.modal').hide();
    });
    
    // 모달 외부 영역 클릭
    $(window).on('click', function(event) {
        if ($(event.target).is($vacationModal)) {
            $vacationModal.hide();
        }
        if ($(event.target).is($correctionModal)) {
            $correctionModal.hide();
        }
    });

    // 내부 jsp의 '취소' 버튼 클릭 처리 (동적 바인딩)
    $(document).on('click', '#cancelBtn', function(event) {
        event.preventDefault();
        $(this).closest('.modal').hide();
        // 필요한 경우 폼 리셋
        // $('#correctionForm')[0].reset(); 
    });

    // --- [3] 모달 제어 전역 함수 (Child JSP에서 호출용) ---
    
    // 출/퇴근 정정 모달 닫기
    window.closeModal = function() {
        $correctionModal.hide();
    };
    
    // 휴가 신청 모달 닫기
    window.closeVacationModal = function() {
        $vacationModal.hide();
    };
    
    
    // =============================================================
    //                    특수 기능 버튼 (결근 처리)
    // =============================================================

    // 1. 미출근 결근 처리
    const attendButton = document.getElementById('processAbsence');
    if (attendButton) {
        attendButton.addEventListener('click', function() {
            if (!confirm('오늘 날짜의 결근 처리 로직을 실행하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) return;
            
            attendButton.disabled = true;
            attendButton.textContent = '처리 중...';

            fetch('/attend/processAbsence', { method: 'GET' })
            .then(response => {
                if (!response.ok) throw new Error(response.statusText);
                return response.text();
            })
            .then(data => {
                alert('성공적으로 처리되었습니다!\n\n' + data);
            })
            .catch(error => {
                alert('처리 중 오류가 발생했습니다.');
                console.error(error);
            })
            .finally(() => {
                attendButton.disabled = false;
                attendButton.textContent = '미출근 결근 처리';
            });
        });
    }
    
    // 2. 미퇴근 결근 처리
    const incompleteButton = document.getElementById('incompleteAttendCheck');
    if (incompleteButton) {
        incompleteButton.addEventListener('click', function() {
            if (!confirm('미퇴근 상태의 출근/지각 기록을 오늘 날짜로 결근 처리하시겠습니까?')) return;
            
            incompleteButton.disabled = true;
            incompleteButton.textContent = '처리 중...';
            
            const contextPath = "${pageContext.request.contextPath}"; 

            fetch(contextPath + '/attend/processIncomplete', { method: 'GET' })
            .then(response => {
                if (!response.ok) return response.text().then(text => { throw new Error(text); });
                return response.text(); 
            })
            .then(data => {
                alert('결과:\n\n' + data);
            })
            .catch(error => {
                alert('처리 중 오류가 발생했습니다.');
                console.error(error);
            })
            .finally(() => {
                incompleteButton.disabled = false;
                incompleteButton.textContent = '미퇴근 결근 처리';
            });
        });
    }
});
</script>
</head>

<body class="sb-nav-fixed">

    <jsp:include page="../common/header.jsp" flush="true" />

    <div id="layoutSidenav">
        <jsp:include page="../common/sidebar.jsp" flush="true" />

        <div id="layoutSidenav_content">
            <div class="container-fluid px-4">
                <h3 class="mt-4 custom-title">근태 현황</h3>
                <hr />
            </div>
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
                                <button class="btn-fieldwork" id="processAbsence">미출근 결근 처리</button>
                                <button class="btn-fieldwork" id="incompleteAttendCheck">미퇴근 결근 처리</button>
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