<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>근태 현황</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/main.min.css' />
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/locales-all.min.js'></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="/js/attend.js"></script>

<script>
    // Tailwind 설정
    tailwind.config = {
        theme: {
            extend: {
                colors: { primary: '#f69022', 'blue-primary': '#1d4ed8' }
            }
        }
    }
</script>

<style>
    /* 모달 스타일 */
    .modal {
        display: none; position: fixed; z-index: 9999;
        left: 0; top: 0; width: 100%; height: 100%;
        background-color: rgba(0,0,0,0.5); overflow: auto;
    }
    .modal.show { display: block; }
    .modal-content {
        background-color: #fff; margin: 5% auto; padding: 25px;
        border: 1px solid #888; width: 90%; max-width: 600px;
        border-radius: 12px; position: relative;
    }
    .close {
        position: absolute; right: 20px; top: 15px; font-size: 28px; cursor: pointer; color: #aaa;
    }
    .close:hover { color: #000; }
    
    /* 버튼 스타일 */
    .custom-btn {
        padding: 10px 20px; border-radius: 9999px; font-weight: bold;
        transition: transform 0.2s; border: none;
    }
    .custom-btn:hover { transform: translateY(-2px); }
</style>

<script>
// [2] 전역 데이터 초기화
const colorMap = {
    '출근': '#4CAF50', '연차': '#2196F3', '반차': '#00BCD4', '휴가': '#2196F3',
    '결근': '#FF9800', '지각': '#FFC107', '조퇴': '#FFC107', '외근': '#9E9E9E'
};

// 서버 데이터를 JS 배열로 변환
let appendEvents = [       
    <c:forEach var="dayAttend" items="${result}" varStatus="status">
    <c:if test="${not empty dayAttend.dateAttend}">
    { 
        title: "${dayAttend.attStatus}",
        date: "${dayAttend.dateAttend.substring(0, 10)}",
        allDay: true,
        color: colorMap["${dayAttend.attStatus}"] || '#999',
        attStatus: "${dayAttend.attStatus}",
        inTime: "${dayAttend.inTime != null ? dayAttend.inTime.substring(11, 19) : ''}",
        outTime: "${dayAttend.outTime != null ? dayAttend.outTime.substring(11, 19) : ''}",
        memo: "${dayAttend.memo}",
        dayFulltime: "${dayAttend.dayFulltime}"
    }<c:if test="${!status.last}">,</c:if>
    </c:if>
    </c:forEach>
];

document.addEventListener('DOMContentLoaded', function(){
    // 캘린더 렌더링
    var calendarEl = document.getElementById('calendar'); 
    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialDate: new Date(),
        initialView: 'dayGridMonth',
        headerToolbar: { left: 'prev,next', center: 'title', right: 'today' },
        locale: 'ko',
        events: appendEvents,
        height: 'auto',
        dateClick: function(info) {
             const event = appendEvents.find(e => e.date === info.dateStr);
             $('#inTimeDisplay').text(event && event.inTime ? "출근: " + event.inTime : "출근: -");
             $('#outTimeDisplay').text(event && event.outTime ? "퇴근: " + event.outTime : "퇴근: -");
             if(typeof updateDonutChart === 'function') updateDonutChart(appendEvents, info.dateStr);
        }
    });    
    calendar.render();
    
    // 차트 초기화
    setTimeout(() => { if(typeof updateDonutChart === 'function') updateDonutChart(appendEvents, new Date().toISOString().slice(0,10)); }, 100);
});

$(document).ready(function() {
    // 모달 제어
    const $vacationModal = $('#vacationModal');
    const $correctionModal = $('#commuteCorrectionModal');

    $('#btnVacation').click(() => $vacationModal.addClass('show'));
    $('#btnCommuteCorrection').click(() => {
        $('#correctionForm')[0].reset();
        $('#existingTime').val('');
        $correctionModal.addClass('show');
    });
    $('.close, .btn-close-modal').click(function() { $(this).closest('.modal').removeClass('show'); });
    $(window).click((e) => {
        if($(e.target).is($vacationModal)) $vacationModal.removeClass('show');
        if($(e.target).is($correctionModal)) $correctionModal.removeClass('show');
    });

    // 출퇴근 정정: 기존 시간 자동 조회
    $('#correctionDate, #correctionType').change(function() {
        const date = $('#correctionDate').val();
        const type = $('#correctionType').val();
        const record = appendEvents.find(r => r.date === date);
        let time = '';
        if(record) {
            if(type === 'inTime' && record.inTime) time = record.inTime.substring(0, 5);
            else if(type === 'outTime' && record.outTime) time = record.outTime.substring(0, 5);
        }
        $('#existingTime').val(time);
    });

    // 휴가 신청: 반차 로직
    $('#vacationType').change(function() {
        if($(this).val().includes('half')) {
            $('#endDateGroup').hide(); $('#totalDays').val('0.5 일');
        } else {
            $('#endDateGroup').show(); calculateDays();
        }
    });
    $('#startDate, #endDate').change(calculateDays);
    function calculateDays() {
        if($('#vacationType').val().includes('half')) return;
        const s = new Date($('#startDate').val()), e = new Date($('#endDate').val());
        if(s && e && s <= e) $('#totalDays').val((Math.round((e-s)/86400000)+1) + ' 일');
        else $('#totalDays').val('0 일');
    }

    // AJAX 전송 (공통)
    $('form.ajax-form').on('submit', function(e) {
        e.preventDefault();
        const $form = $(this);
        const $modal = $form.closest('.modal');
        
        // 반차 날짜 보정
        if($form.attr('id') === 'vacationForm' && $('#vacationType').val().includes('half')) {
            $('#endDate').prop('disabled', false).val($('#startDate').val());
        }

        const formData = new FormData(this);
        if(formData.has('totalDays')) formData.set('totalDays', formData.get('totalDays').replace(' 일', ''));

        $.ajax({
            url: $form.attr('action'),
            type: 'POST',
            data: formData,
            processData: false, contentType: false,
            dataType: 'json',
            success: function(res) {
                if(res.success) {
                    alert('✅ 완료되었습니다.');
                    $modal.removeClass('show');
                } else {
                    alert('❌ 실패: ' + res.message);
                }
            },
            error: function(xhr) {
                console.error(xhr);
                alert('❌ 오류 발생 (로그인 확인 필요)\n' + xhr.responseText.substring(0, 100) + "...");
            }
        });
    });
    
    // 출퇴근 버튼
    $('#checkIn').click(() => confirm('출근하시겠습니까?') && $.get('/attend/checkIn', (res)=> { alert(res); $('#inTimeDisplay').text("출근: "+res); }));
    $('#checkOut').click(() => confirm('퇴근하시겠습니까?') && $.get('/attend/checkOut', (res)=> { alert(res); $('#outTimeDisplay').text("퇴근: "+res); }));
});
</script>
</head>

<body class="sb-nav-fixed bg-gray-100">
    <jsp:include page="../common/header.jsp" flush="true" />
    <div id="layoutSidenav">
        <jsp:include page="../common/sidebar.jsp" flush="true" />
        <div id="layoutSidenav_content">
            <main class="px-4 py-6">
                <h3 class="font-bold text-2xl text-gray-800 mb-4">근태 현황</h3>
                
                <div class="flex flex-col lg:flex-row gap-6">
                    <div class="w-full lg:w-1/3 bg-white p-4 rounded-xl shadow border">
                        <jsp:include page="../attend/donutChart.jsp" flush="true" />
                    </div>
                    
                    <div class="w-full lg:w-2/3 bg-white p-6 rounded-xl shadow border">
                        <div class="flex justify-between mb-4">
                            <div class="space-x-2">
                                <button id="checkIn" class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600 font-bold">출근</button>
                                <button id="checkOut" class="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600 font-bold">퇴근</button>
                            </div>
                            <div class="text-sm font-medium pt-1">
                                <span id="inTimeDisplay" class="mr-3 text-green-700">출근: -</span>
                                <span id="outTimeDisplay" class="text-blue-700">퇴근: -</span>
                            </div>
                        </div>
                        
                        <div id="calendar"></div>

                        <div class="flex justify-end gap-3 mt-4 border-t pt-4">
                            <button id="btnVacation" class="custom-btn bg-primary text-white hover:bg-orange-600 shadow-md">휴가 신청</button>
                            <button id="btnCommuteCorrection" class="custom-btn bg-blue-primary text-white hover:bg-blue-800 shadow-md">출/퇴근 정정</button>
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
            <h2 class="text-2xl font-bold text-center mb-6">휴가 신청</h2>
            <form id="vacationForm" action="${pageContext.request.contextPath}/approve/approve-ajax" method="POST" class="ajax-form space-y-4">
                <input type="hidden" name="DocType" value="4"> 
                <input type="hidden" name="DocTitle" value="[휴가신청]"> 
                <input type="hidden" name="step1ManagerNo" value="${sessionScope.login.managerEmpNo}"> 
                
                <div class="bg-gray-50 p-3 rounded text-sm grid grid-cols-3 gap-2 border">
                    <div>이름: ${sessionScope.login.empName}</div>
                    <div>사번: ${sessionScope.login.empNo}</div>
                    <div>부서: ${sessionScope.login.deptName}</div>
                </div>

                <div class="space-y-3">
                    <div class="flex items-center"><label class="w-20 font-bold">종류</label>
                        <select id="vacationType" name="attStatus" class="flex-1 p-2 border rounded" required>
                            <option value="" disabled selected>선택</option>
                            <option value="annual">연차</option>
                            <option value="half_am">오전반차</option>
                            <option value="half_pm">오후반차</option>
                            <option value="sick">병가</option>
                        </select>
                    </div>
                    <div class="flex items-center"><label class="w-20 font-bold">시작일</label>
                        <input type="date" id="startDate" name="startDate" class="flex-1 p-2 border rounded" required>
                    </div>
                    <div class="flex items-center" id="endDateGroup"><label class="w-20 font-bold">종료일</label>
                        <input type="date" id="endDate" name="endDate" class="flex-1 p-2 border rounded" required>
                    </div>
                    <div class="flex items-center"><label class="w-20 font-bold">일수</label>
                        <input type="text" id="totalDays" name="totalDays" readonly class="flex-1 p-2 bg-gray-100 border rounded">
                    </div>
                    <div><textarea name="docContent" rows="3" class="w-full p-2 border rounded" placeholder="사유 입력" required></textarea></div>
                </div>
                
                <div class="flex justify-center gap-2 pt-4">
                    <button type="submit" class="custom-btn bg-primary text-white">신청</button>
                    <button type="button" class="btn-close-modal custom-btn bg-gray-200">취소</button>
                </div>
            </form>
        </div>
    </div>

    <div id="commuteCorrectionModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2 class="text-2xl font-bold text-center mb-6">출/퇴근 정정</h2>
            <form id="correctionForm" action="${pageContext.request.contextPath}/approve/approve-ajax" method="POST" class="ajax-form space-y-4">
                <input type="hidden" name="DocType" value="5">
                <input type="hidden" name="DocTitle" value="[근태정정]">
                <input type="hidden" name="step1ManagerNo" value="${sessionScope.login.managerEmpNo}">
                <input type="hidden" name="step2ManagerNo" value="${sessionScope.login.parentDeptNo}">
                
                <div class="space-y-3">
                    <div class="flex items-center"><label class="w-20 font-bold">정정일</label>
                        <input type="date" id="correctionDate" name="startDate" class="flex-1 p-2 border rounded" required>
                    </div>
                    <div class="flex items-center"><label class="w-20 font-bold">구분</label>
                        <select id="correctionType" name="memo" class="flex-1 p-2 border rounded" required>
                            <option value="" disabled selected>선택</option>
                            <option value="inTime">출근시간</option>
                            <option value="outTime">퇴근시간</option>
                        </select>
                    </div>
                    <div class="flex items-center"><label class="w-20 font-bold">기존</label>
                        <input type="time" id="existingTime" readonly class="flex-1 p-2 bg-gray-100 border rounded">
                    </div>
                    <div class="flex items-center"><label class="w-20 font-bold">정정</label>
                        <input type="time" name="newmodifyTime" class="flex-1 p-2 border rounded border-blue-500" required>
                    </div>
                    <div><textarea name="docContent" rows="3" class="w-full p-2 border rounded" placeholder="사유 입력" required></textarea></div>
                </div>

                <div class="flex justify-center gap-2 pt-4">
                    <button type="submit" class="custom-btn bg-primary text-white">신청</button>
                    <button type="button" class="btn-close-modal custom-btn bg-gray-200">취소</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>