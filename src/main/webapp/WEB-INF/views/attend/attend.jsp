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

<script>
    tailwind.config = {
        theme: { extend: { colors: { primary: '#f69022', 'blue-primary': '#1d4ed8' } } }
    }
</script>

<style>
    body { background-color: #f3f4f6; } 
    .chart-container { width: 100%; max-width: 350px; height: 350px; margin: 20px auto; position: relative; }
    #summaryBox { width: 100%; max-width: 350px; margin: 10px auto; padding: 15px; border: 1px solid #ddd; border-radius: 8px; text-align: center; background-color: #f9f9f9; }
    #summaryBox h3 { margin: 0 0 5px 0; font-size: 1.1em; color: #333; font-weight: bold; }
    #summaryBox p { margin: 5px 0; font-size: 0.9em; color: #666; }
    
    /* 모달 */
    .modal { display: none; position: fixed; z-index: 9999; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); overflow: auto; opacity: 0; transition: opacity 0.3s ease-in-out; }
    .modal.show { display: block; opacity: 1; }
    .modal-content { background-color: #fff; margin: 5% auto; padding: 25px; border: 1px solid #888; width: 90%; max-width: 600px; border-radius: 12px; position: relative; transform: translateY(20px); transition: transform 0.3s ease-in-out; }
    .modal.show .modal-content { transform: translateY(0); }
    .close { position: absolute; right: 20px; top: 15px; font-size: 28px; cursor: pointer; color: #aaa; }
    .custom-btn { padding: 10px 20px; border-radius: 9999px; font-weight: bold; transition: transform 0.2s; border: none; }
    .custom-btn:hover { transform: translateY(-2px); }
    
    /* 캘린더 */
    .fc-day-sat .fc-daygrid-day-number, .fc-day-sun .fc-daygrid-day-number { color: #F44336; }
    .fc-daygrid-day-frame, .fc-event { cursor: pointer; }
    .sb-sidenav-menu-nested.nav a { visibility: visible !important; }
  
</style>

<script>
    // 전역 변수
    let myChart = null;
    let calendar = null;
    
    const colorMap = {
        '출근': '#4CAF50', '연차': '#2196F3', '반차': '#00BCD4', '오전반차': '#00BCD4', '오후반차': '#00BCD4',
        '휴가': '#2196F3', '결근': '#FF9800', '지각': '#FFC107', '조퇴': '#FFC107', 
        '외근': '#9E9E9E', '퇴근': '#2196F3'
    };

    // 서버 데이터 초기화
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

    // =========================================
    // 유틸리티 및 계산 로직
    // =========================================
    
    function getLocalTodayDate() {
        const d = new Date();
        return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
    }

    function parseFulltimeToSeconds(fulltimeStr) {
        if (!fulltimeStr || fulltimeStr.trim() === 'null') return 0;
        try {
            let timePart = fulltimeStr.includes(" ") ? fulltimeStr.split(" ")[1] : fulltimeStr;
            const parts = timePart.split(":");
            if (parts.length >= 2) {
                return (parseInt(parts[0], 10) * 3600) + (parseInt(parts[1], 10) * 60) + (parts.length > 2 ? parseInt(parts[2], 10) : 0);
            }
        } catch (e) { console.error(e); }
        return 0;
    }

    // 날짜 객체 복사를 통해 '제멋대로 나오는 시간' 버그 수정
    function getWeekRange(dateParam) {
        const target = dateParam ? new Date(dateParam) : new Date();
        const current = new Date(target); // 복사본 생성 (원본 보호)
        
        const day = current.getDay();
        const diff = current.getDate() - day + (day == 0 ? -6 : 1); // 월요일 계산
        
        const monday = new Date(current); 
        monday.setDate(diff); // 월요일 설정

        const sunday = new Date(monday); 
        sunday.setDate(monday.getDate() + 6); // 월요일 기준 6일 뒤

        const fmt = d => d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
        return { start: fmt(monday), end: fmt(sunday) };
    }

    // [핵심 로직] 실근무, 휴가, 연장근무(Overtime) 계산
    function calculateWorkAndVacation(events, startDate, endDate) {
        let realWorkSeconds = 0;
        let vacationSeconds = 0;
        let overtimeSeconds = 0; // 연장 근무 시간 누적 변수

        events.forEach(e => {
            if (e.date >= startDate && e.date <= endDate) {
                // dayFulltime은 이미 휴게시간 1시간이 제외된 순수 근무시간
                let seconds = parseFulltimeToSeconds(e.dayFulltime);
                
                // 1. 연장 근무 계산 (일일 8시간 = 28800초 초과분)
                if (seconds > (8 * 3600)) {
                    overtimeSeconds += (seconds - (8 * 3600));
                }

                // 2. 근태 상태별 계산
                if (e.attStatus === '연차' || e.attStatus === '휴가') {
                    // 연차: 출근 안 함 -> 휴가 8시간 인정
                    vacationSeconds += (8 * 3600);
                } 
                else if (e.attStatus.includes('반차')) {
                    // 반차: 휴가 4시간 + 실제 근무시간(seconds)
                    vacationSeconds += (4 * 3600);
                    realWorkSeconds += seconds; 
                } 
                else {
                    // 일반 근무: 실제 근무시간 누적
                    realWorkSeconds += seconds;
                }
            }
        });
        
        return {
            work: parseFloat((realWorkSeconds / 3600).toFixed(1)),
            vacation: parseFloat((vacationSeconds / 3600).toFixed(1)),
            overtime: parseFloat((overtimeSeconds / 3600).toFixed(1)) // 시간 단위 반환
        };
    }

    // =========================================
    // 차트 업데이트
    // =========================================
    function updateDonutChart(events, currentDisplayDate) {
        const monthlyTotalHours = 209; 
        const weeklyTotalHours = 40; 

        // 날짜 범위 계산
        const d = new Date(currentDisplayDate);
        const monthStart = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-01';
        const monthEnd   = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-31';
        const weekRange = getWeekRange(currentDisplayDate);

        // 데이터 계산 (연장 근무 포함)
        const mData = calculateWorkAndVacation(events, monthStart, monthEnd);
        const wData = calculateWorkAndVacation(events, weekRange.start, weekRange.end);

        // 잔여 시간 계산
        const mRemaining = Math.max(0, monthlyTotalHours - (mData.work + mData.vacation));
        const wRemaining = Math.max(0, weeklyTotalHours - (wData.work + wData.vacation));

        const mTotalDone = (mData.work + mData.vacation).toFixed(1);
        const wTotalDone = (wData.work + wData.vacation).toFixed(1);
        const wPercent = ((wTotalDone / weeklyTotalHours) * 100).toFixed(1);

        // 요약 박스 업데이트 (연장 근무 표시 추가)
        const summaryBox = document.getElementById('summaryBox');
        if (summaryBox) {
            let overtimeHtml = '';
            if (wData.overtime > 0) {
                overtimeHtml = '<p class="text-red-500 font-bold text-sm mt-1">※ 주간 연장 근무: +' + wData.overtime + 'h</p>';
            }

            summaryBox.innerHTML =
                '<h3>주간 현황 (' + wPercent + '%)</h3>' +
                '<p>실근무: ' + wData.work + 'h <span class="text-gray-300">|</span> 휴가: ' + wData.vacation + 'h</p>' +
                '<p class="font-bold text-blue-600">총 인정: ' + wTotalDone + ' / ' + weeklyTotalHours + ' 시간</p>' +
                overtimeHtml + // 연장 근무 출력 위치
                '<hr style="border-top:1px dashed #ccc; margin:10px 0;">' +
                '<h3>월간 누적</h3>' +
                '<p>총 ' + mTotalDone + ' / ' + monthlyTotalHours + ' 시간</p>';
        }

        // 차트 렌더링
        const canvas = document.getElementById('nestedWorkHoursChart');
        if (!canvas) return;

        if (myChart) {
            myChart.data.datasets[0].data = [mData.work, mData.vacation, mRemaining]; // 월간
            myChart.data.datasets[1].data = [wData.work, wData.vacation, wRemaining]; // 주간
            myChart.update();
        } else {
            myChart = new Chart(canvas, {
                type: 'doughnut',
                data: {
                    labels: ['실근무', '유급휴가(연/반차)', '잔여'],
                    datasets: [
                        {   // 월간 (바깥쪽)
                            label: '월간',
                            data: [mData.work, mData.vacation, mRemaining],
                            backgroundColor: ['#4CAF50', '#81C784', '#E0E0E0'], 
                            borderWidth: 2, borderColor: '#fff', cutout: '65%'
                        },
                        {   // 주간 (안쪽)
                            label: '주간',
                            data: [wData.work, wData.vacation, wRemaining],
                            backgroundColor: ['#FF9800', '#FFCC80', '#F5F5F5'], 
                            borderWidth: 2, borderColor: '#fff', cutout: '30%'
                        }
                    ]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom', labels: { boxWidth: 12 } },
                        title: { display: true, text: '근무 시간 상세 (휴가 포함)', font: { size: 16 } },
                        tooltip: {
                            callbacks: {
                                label: function(ctx) {
                                    let label = ctx.dataset.label + ' ' + ctx.label + ': ';
                                    let val = ctx.raw;
                                    label += val + '시간';
                                    return label;
                                }
                            }
                        }
                    }
                }
            });
        }
    }

    // VO -> FullCalendar 변환
    function convertVoToFullCalendarEvents(voList) {
        return voList.filter(vo => vo.dateAttend).map(vo => {
            const attStatus = vo.attStatus;
            const dateStr = vo.dateAttend.substring(0, 10);
            return {
                title: attStatus,
                date: dateStr,
                allDay: true,
                color: colorMap[attStatus] || '#999',
                attStatus: attStatus,
                inTime: (vo.inTime && vo.inTime.trim() !== '') ? vo.inTime.substring(11, 19) : '',
                outTime: (vo.outTime && vo.outTime.trim() !== '') ? vo.outTime.substring(11, 19) : '',
                dayFulltime: vo.dayFulltime
            };
        });
    }

    // DOM Ready
    document.addEventListener('DOMContentLoaded', function(){
        var calendarEl = document.getElementById('calendar'); 
        let isInitialLoad = true;

        calendar = new FullCalendar.Calendar(calendarEl, {
            initialDate: new Date(),
            initialView: 'dayGridMonth',
            headerToolbar: { left: 'prev,next', center: 'title', right: 'today' },
            locale: 'ko',
            events: appendEvents,
            height: 'auto',
            datesSet: function(info) {
                if(isInitialLoad) { isInitialLoad = false; return; }
                const d = calendar.getDate(); 
                const dateStr = d.getFullYear() + "-" + String(d.getMonth() + 1).padStart(2, '0');
                
                $.ajax({
                    type: 'get', url: '/attend/calendar', data: { date: dateStr },
                    success: function(voList) {
                        calendar.removeAllEvents();
                        const newEvents = convertVoToFullCalendarEvents(voList);
                        newEvents.forEach(e => calendar.addEvent(e));
                        appendEvents = newEvents;
                        updateDonutChart(newEvents, dateStr + "-01");
                    }
                });
            },
            dateClick: function(info) {
                 const e = appendEvents.find(ev => ev.date === info.dateStr);
                 $('#inTimeDisplay').text(e && e.inTime ? "출근: " + e.inTime : "출근: -");
                 $('#outTimeDisplay').text(e && e.outTime ? "퇴근: " + e.outTime : "퇴근: -");
                 updateDonutChart(appendEvents, info.dateStr);
            }
        });    
        calendar.render();
        setTimeout(() => { updateDonutChart(appendEvents, getLocalTodayDate()); }, 100);
    });

    $(document).ready(function() {
        const $vacationModal = $('#vacationModal');
        const $correctionModal = $('#commuteCorrectionModal');

        $('#btnVacation').click(() => $vacationModal.addClass('show'));
        $('#btnCommuteCorrection').click(() => {
            $('#correctionForm')[0].reset(); $('#existingTime').val('');
            $correctionModal.addClass('show');
        });
        $('.close, .btn-close-modal').click(function() { $(this).closest('.modal').removeClass('show'); });
        $(window).click((e) => {
            if($(e.target).is($vacationModal)) $vacationModal.removeClass('show');
            if($(e.target).is($correctionModal)) $correctionModal.removeClass('show');
        });

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

        $('#vacationType').change(function() {
            if($(this).val().includes('half')) { $('#endDateGroup').hide(); $('#totalDays').val('0.5 일'); } 
            else { $('#endDateGroup').show(); calculateDays(); }
        });
        $('#startDate, #endDate').change(calculateDays);
        function calculateDays() {
            if($('#vacationType').val().includes('half')) return;
            const s = new Date($('#startDate').val()), e = new Date($('#endDate').val());
            if(s && e && s <= e) $('#totalDays').val((Math.round((e-s)/86400000)+1) + ' 일');
            else $('#totalDays').val('0 일');
        }

        // ============================================================
        // [수정 완료] 결재 문서 본문 생성 로직 (JSP 충돌 방지를 위한 문자열 결합 방식)
        // ============================================================
        $('form.ajax-form').on('submit', function(e) {
            e.preventDefault();
            const $form = $(this);
            const formId = $form.attr('id');
            const $modal = $form.closest('.modal');
            
            if(formId === 'vacationForm' && $('#vacationType').val().includes('half')) {
                $('#endDate').prop('disabled', false).val($('#startDate').val());
            }

            const formData = new FormData(this);
            
            // --- 결재 본문(docContent) HTML 테이블 생성 ---
            let generatedContent = "";
            const userReason = formData.get('docContent'); 

            // 스타일 정의
            const tableStyle = 'width: 100%; border-collapse: collapse; border: 1px solid #ddd; font-size: 14px;';
            const thStyle = 'background-color: #f8f9fa; border: 1px solid #ddd; padding: 10px; text-align: left; width: 120px; font-weight: bold;';
            const tdStyle = 'border: 1px solid #ddd; padding: 10px;';

            // [오류 해결] 백틱(`) 대신 작은따옴표(')와 더하기(+) 연산자 사용
            if (formId === 'vacationForm') {
                const typeText = $('#vacationType option:checked').text(); 
                const period = $('#startDate').val() + ($('#endDate').val() ? ' ~ ' + $('#endDate').val() : '');
                let days = formData.get('totalDays').replace(' 일', ''); 
                
                if($('#vacationType').val().includes('half')) days = "0.5";

                generatedContent = 
                    '<h3 style="color: #333;">[휴가 신청서]</h3>' +
                    '<table style="' + tableStyle + '">' +
                        '<tr><th style="' + thStyle + '">휴가 종류</th><td style="' + tdStyle + '">' + typeText + '</td></tr>' +
                        '<tr><th style="' + thStyle + '">신청 기간</th><td style="' + tdStyle + '">' + period + '</td></tr>' +
                        '<tr><th style="' + thStyle + '">사용 일수</th><td style="' + tdStyle + '">' + days + '일</td></tr>' +
                        '<tr><th style="' + thStyle + '">신청 사유</th><td style="' + tdStyle + '">' + userReason.replace(/\n/g, '<br>') + '</td></tr>' +
                    '</table>' +
                    '<p style="margin-top: 20px; color: #666; font-size: 12px;">위와 같이 휴가를 신청하오니 결재 바랍니다.</p>';

            } else if (formId === 'correctionForm') {
                const date = $('#correctionDate').val();
                const typeText = $('#correctionType option:checked').text(); 
                const oldTime = $('#existingTime').val() || '(기록 없음)';
                const newTime = $('input[name="newmodifyTime"]').val();

                generatedContent = 
                    '<h3 style="color: #333;">[근태 정정 신청서]</h3>' +
                    '<table style="' + tableStyle + '">' +
                        '<tr><th style="' + thStyle + '">정정 대상일</th><td style="' + tdStyle + '">' + date + '</td></tr>' +
                        '<tr><th style="' + thStyle + '">정정 구분</th><td style="' + tdStyle + '">' + typeText + '</td></tr>' +
                        '<tr><th style="' + thStyle + '">변경 전</th><td style="' + tdStyle + '" style="color: #e74a3b;">' + oldTime + '</td></tr>' +
                        '<tr><th style="' + thStyle + '">변경 후</th><td style="' + tdStyle + '" style="color: #4e73df; font-weight: bold;">' + newTime + '</td></tr>' +
                        '<tr><th style="' + thStyle + '">정정 사유</th><td style="' + tdStyle + '">' + userReason.replace(/\n/g, '<br>') + '</td></tr>' +
                    '</table>' +
                    '<p style="margin-top: 20px; color: #666; font-size: 12px;">위와 같이 근태 기록 정정을 신청하오니 결재 바랍니다.</p>';
            }

            if(generatedContent) {
                formData.set('docContent', generatedContent);
            }

            if(formData.has('totalDays')) {
                formData.set('totalDays', formData.get('totalDays').replace(' 일', ''));
            }

            $.ajax({
                url: $form.attr('action'),
                type: 'POST',
                data: formData,
                processData: false, 
                contentType: false,
                dataType: 'json',
                success: function(res) {
                    if(res.success) {
                        alert('✅ 상신 완료되었습니다.\n[전자결재 > 결재 현황]에서 확인 가능합니다.');
                        $modal.removeClass('show');
                        location.reload(); 
                    } else {
                        alert('❌ 실패: ' + res.message);
                    }
                },
                error: function(xhr) {
                    console.error(xhr);
                    alert('❌ 오류 발생\n' + xhr.responseText.substring(0, 100));
                }
            });
        });
        
        $('#checkIn').click(() => confirm('출근하시겠습니까?') && $.get('/attend/checkIn', (res)=> { alert("출근: "+res); location.reload(); }));
        $('#checkOut').click(() => confirm('퇴근하시겠습니까?') && $.get('/attend/checkOut', (res)=> { alert("퇴근: "+res); location.reload(); }));
    });
</script>
</head>

<body class="sb-nav-fixed bg-gray-100">
    <jsp:include page="../common/header.jsp" flush="true" />
    
    <div id="layoutSidenav">        
        <jsp:include page="../common/sidebar.jsp" flush="true" />
        
        <div id="layoutSidenav_content">
            <main class="px-4 py-1">
              <div class="container-fluid px-4">
                <h2 class="mt-4">근태 현황</h2>
					<ol class="breadcrumb mb-4">
						<li class="breadcrumb-item active">Attendance status</li>
					</ol>
                <div class="flex flex-col lg:flex-row gap-6">
                    <div class="w-full lg:w-1/3 bg-white p-4 rounded-xl shadow border">
                        <div class="chart-container">
                            <canvas id="nestedWorkHoursChart"></canvas>
                        </div>
                        <div id="summaryBox"><p>데이터 계산 중...</p></div>
                    </div>
                    <div class="w-full lg:w-2/3 bg-white p-6 rounded-xl shadow border">
                        <div class="flex justify-between mb-4">
                            <div class="space-x-2">
                                <button id="checkIn" class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600 font-bold shadow-xl">출근</button>
                                <button id="checkOut" class="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600 font-bold shadow-xl">퇴근</button>
                            </div>
                           <div class="p-3 bg-gray-100 rounded-lg"> 
							    <div class="text-sm font-medium pt-1">
							        <span class="mr-6 text-green-700"><i class="fas fa-sign-in-alt me-1"></i><span id="inTimeDisplay"> 출근: - </span></span>
							        <span class="text-blue-700"><i class="fas fa-sign-out-alt me-1"></i><span id="outTimeDisplay"> 퇴근: - </span></span>
							    </div>
							</div>
                        </div>
                        <div id="calendar"></div>
                        <div class="flex justify-end gap-3 mt-4 border-t pt-4">
                            <button id="btnVacation" class="custom-btn bg-blue-400 text-white hover:bg-blue-500 shadow-xl"><i class="fas fa-plane-departure text-gray-200"></i> 휴가 신청</button>
                            <button id="btnCommuteCorrection" class="custom-btn bg-blue-400 text-white hover:bg-blue-500 shadow-xl"><i class="fas fa-wrench text-gray-200"></i> 출/퇴근 정정</button>
                        </div>
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
            <h2 class="text-2xl font-bold text-center mb-6"><i class="fas fa-plane-departure text-warning"></i> 휴가 신청</h2>
            <form id="vacationForm" action="${pageContext.request.contextPath}/approve/approve-ajax" method="POST" class="ajax-form space-y-4">
                <input type="hidden" name="DocType" value="4"> 
                <input type="hidden" name="DocTitle" value="[휴가신청]"> 
                <input type="hidden" name="step1ManagerNo" value="${sessionScope.login.managerEmpNo}"> 
                <div class="bg-gray-50 p-3 rounded text-sm grid grid-cols-3 gap-2 border">
                    <div>이름: ${sessionScope.login.empName}</div> <div>사번: ${sessionScope.login.empNo}</div> <div>부서: ${sessionScope.login.deptName}</div>
                </div>
                <div class="space-y-3">
                    <div class="flex items-center"><label class="w-20 font-bold">종류</label>
                        <select id="vacationType" name="attStatus" class="flex-1 p-2 border rounded" required>
                            <option value="" disabled selected>선택</option> <option value="annual">연차</option> <option value="half_am">오전반차</option> <option value="half_pm">오후반차</option> <option value="sick">병가</option>
                        </select>
                    </div>
                    <div class="flex items-center"><label class="w-20 font-bold">시작일</label><input type="date" id="startDate" name="startDate" class="flex-1 p-2 border rounded" required></div>
                    <div class="flex items-center" id="endDateGroup"><label class="w-20 font-bold">종료일</label><input type="date" id="endDate" name="endDate" class="flex-1 p-2 border rounded" required></div>
                    <div class="flex items-center"><label class="w-20 font-bold">일수</label><input type="text" id="totalDays" name="totalDays" readonly class="flex-1 p-2 bg-gray-100 border rounded"></div>
                    <div><textarea name="docContent" rows="3" class="w-full p-2 border rounded" placeholder="사유 입력" required></textarea></div>
                </div>
                <div class="flex justify-center gap-2 pt-4"><button type="submit" class="custom-btn bg-primary text-white">신청</button><button type="button" class="btn-close-modal custom-btn bg-gray-200">취소</button></div>
            </form>
        </div>
    </div>
    <div id="commuteCorrectionModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2 class="text-2xl font-bold text-center mb-6">출/퇴근 정정</h2>
            <form id="correctionForm" action="${pageContext.request.contextPath}/approve/approve-ajax" method="POST" class="ajax-form space-y-4">
                <input type="hidden" name="DocType" value="5"> <input type="hidden" name="DocTitle" value="[근태정정]">
                <input type="hidden" name="step1ManagerNo" value="${sessionScope.login.managerEmpNo}"> <input type="hidden" name="step2ManagerNo" value="${sessionScope.login.parentDeptNo}">
                <div class="space-y-3">
                    <div class="flex items-center"><label class="w-20 font-bold">정정일</label><input type="date" id="correctionDate" name="startDate" class="flex-1 p-2 border rounded" required></div>
                    <div class="flex items-center"><label class="w-20 font-bold">구분</label>
                        <select id="correctionType" name="memo" class="flex-1 p-2 border rounded" required><option value="" disabled selected>선택</option><option value="inTime">출근시간</option><option value="outTime">퇴근시간</option></select>
                    </div>
                    <div class="flex items-center"><label class="w-20 font-bold">기존</label><input type="time" id="existingTime" readonly class="flex-1 p-2 bg-gray-100 border rounded"></div>
                    <div class="flex items-center"><label class="w-20 font-bold">정정</label><input type="time" name="newmodifyTime" class="flex-1 p-2 border rounded border-blue-500" required></div>
                    <div><textarea name="docContent" rows="3" class="w-full p-2 border rounded" placeholder="사유 입력" required></textarea></div>
                </div>
                <div class="flex justify-center gap-2 pt-4"><button type="submit" class="custom-btn bg-primary text-white">신청</button><button type="button" class="btn-close-modal custom-btn bg-gray-200">취소</button></div>
            </form>
        </div>
    </div>
</body>
</html>