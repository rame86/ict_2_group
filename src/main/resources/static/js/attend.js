// attend.js

// [근무 시간 문자열을 분(Minutes)으로 변환함]
function parseFulltimeToMinutes(fulltimeStr) {
	// fulltimeStr이 null이거나 비어있으면 0분 반환됨.
	if (!fulltimeStr || fulltimeStr.trim() === 'null') return 0;
	try {
		// "날짜 시간" 형태에서 시간 부분만 분리함.
		const timePart = fulltimeStr.split(" ")[1];
		// 시, 분, 초로 분리함.
		const parts = timePart.split(":");
		if (parts.length === 3) {
			const hours = parseInt(parts[0], 10);
			const minutes = parseInt(parts[1], 10);
			// 시간은 60분으로 환산하여 총 분을 계산해 반환함. (초는 무시됨)
			return (hours * 60) + minutes;
		}
	} catch (e) {
		// 파싱 중 오류 발생 시 콘솔에 에러를 기록하고 0분 반환됨.
		console.error("근무 시간 파싱 오류:", fulltimeStr, e);
	}
	return 0;
}

// [특정 날짜가 속한 주의 시작일과 종료일(YYYY-MM-DD)을 계산함]
function getCurrentWeekRange(dateParam) {
	// 파라미터가 없으면 오늘 날짜를 기준으로 함.
	const today = dateParam ? new Date(dateParam) : new Date();
	const dayOfWeek = today.getDay(); // 0(일요일) ~ 6(토요일)
	// 시작일 계산: 오늘 날짜에서 (요일 - 1)만큼 빼서 월요일을 주의 시작으로 맞춤. (일요일이면 6일 뺌)
	let startOfWeek = new Date(today.setDate(today.getDate() - (dayOfWeek === 0 ? 6 : dayOfWeek - 1)));
	const endOfWeek = new Date(startOfWeek);
	// 종료일 계산: 시작일에서 6일을 더함.
	endOfWeek.setDate(startOfWeek.getDate() + 6);

	const formatDate = (date) => {
		const y = date.getFullYear();
		const m = String(date.getMonth() + 1).padStart(2, '0');
		const d = String(date.getDate()).padStart(2, '0');
		// YYYY-MM-DD 형식으로 반환함.
		return `${y}-${m}-${d}`;
	};

	// 시작일과 종료일을 반환함.
	return {
		start: formatDate(startOfWeek),
		end: formatDate(endOfWeek)
	};
}

// [현재 주간의 총 근무 시간(분)을 계산함]
function calculateTotalWeeklyMinutes(events, currentDisplayDate) {
	// 기준 날짜를 통해 해당 주의 시작일과 종료일을 가져옴.
	const { start, end } = getCurrentWeekRange(currentDisplayDate);
	let totalMinutes = 0;

	events.forEach(event => {
		const eventDate = event.date;
		// 이벤트 날짜가 해당 주간 범위 내에 포함되는지 확인.
		if (eventDate >= start && eventDate <= end) {
			// dayFulltime 값이 있으면 근무 시간을 분으로 변환하여 총합에 추가함.
			if (event.dayFulltime && event.dayFulltime.trim() !== "") {
				totalMinutes += parseFulltimeToMinutes(event.dayFulltime);
			}
		}
	});
	return totalMinutes;
}

// [전체 월간 근무 시간을 시간(Hours) 단위로 계산함]
function calculateTotalMonthlyHours(events) {
	let monthlyHours = 0;
	events.forEach(event => {
		// dayFulltime 값을 분으로 변환 후, 60으로 나누어 시간 단위로 누적함.
		if (event.dayFulltime && event.dayFulltime.trim() !== "") {
			monthlyHours += parseFulltimeToMinutes(event.dayFulltime) / 60;
		}
	});
	// 소수점 첫째 자리까지 반올림하여 반환함.
	return parseFloat(monthlyHours.toFixed(1));
}


// [도넛 차트 및 근무 현황 요약 박스를 업데이트함]
function updateDonutChart(events, currentDisplayDate) {

	// 차트 객체가 로딩되지 않았으면 경고 후 종료함.
	if (typeof myChart === 'undefined') {

		console.warn("Chart 객체 없음 (로딩 중일 수 있음)");
		return;
	}

	const monthlyTotalHours = 209; // 월 최대 근무 시간
	const weeklyTotalHours = 40; // 주 최대 근무 시간

	// 월간 근무 시간 계산 및 잔여 시간, 퍼센트 계산.
	const monthlyWorkedHours = calculateTotalMonthlyHours(events);
	const monthlyRemainingHours = Math.max(0, monthlyTotalHours - monthlyWorkedHours);
	const monthlyWorkedPercentage = ((monthlyWorkedHours / monthlyTotalHours) * 100).toFixed(1);

	// 주간 근무 시간 계산 및 잔여 시간, 퍼센트 계산.
	const totalWeeklyMinutes = calculateTotalWeeklyMinutes(events, currentDisplayDate);
	const weeklyWorkedHours = parseFloat((totalWeeklyMinutes / 60).toFixed(1));
	const weeklyRemainingHours = Math.max(0, weeklyTotalHours - weeklyWorkedHours);
	const weeklyWorkedPercentage = ((weeklyWorkedHours / weeklyTotalHours) * 100).toFixed(1);

	// 차트의 데이터셋(월간/주간)에 계산된 값들을 업데이트함.
	myChart.data.datasets[0].data = [monthlyWorkedHours, monthlyRemainingHours];
	myChart.data.datasets[1].data = [weeklyWorkedHours, weeklyRemainingHours];

	// 차트 옵션에 근무 퍼센트 정보를 추가하여 업데이트함.
	if (!myChart.options.chartTotals) {
		myChart.options.chartTotals = {};
	}
	myChart.options.chartTotals.monthlyWorkedPercentage = monthlyWorkedPercentage;
	myChart.options.chartTotals.weeklyWorkedPercentage = weeklyWorkedPercentage;

	// HTML 요약 박스('summaryBox')에 월간 및 주간 근무 현황을 표시하도록 업데이트함.
	const summaryBox = document.getElementById('summaryBox');
	if (summaryBox) {
		summaryBox.innerHTML =
			'<h3>월간 근무 현황</h3>' +
			'<p>총 근무: <b>' + monthlyWorkedHours + ' / ' + monthlyTotalHours + ' 시간</b> (' + monthlyWorkedPercentage + '%)</p>' +
			'<hr style="border: none; border-top: 1px dashed #ccc; margin: 10px 50px;">' +
			'<h3>주간 근무 현황</h3>' +
			'<p>총 근무: <b>' + weeklyWorkedHours + ' / ' + weeklyTotalHours + ' 시간</b> (' + weeklyWorkedPercentage + '%)</p>';
	}

	// 차트 갱신을 요청함.
	myChart.update();
}

// [서버 VO 목록을 FullCalendar 이벤트 객체 배열로 변환함]
function convertVoToFullCalendarEvents(voList) {
	// 근태 상태별 색상 맵 정의됨.
	const colorMapLocal = {
		'퇴근': '#2196F3', '출근': '#4CAF50', '지각': '#FFC107', '조퇴': '#FFC107',
		'외근': '#9E9E9E', '연차': '#2196F3', '오전반차': '#00BCD4', '오후반차': '#00BCD4',
		'결근': '#FF9800', '출장': '#9E9E9E'
	};

	return voList.filter(vo => vo.dateAttend).map(vo => { // 날짜 정보가 있는 VO만 필터링 후 매핑함.
		const attStatus = vo.attStatus;
		const dateStr = vo.dateAttend.substring(0, 10); // YYYY-MM-DD만 추출함.
		const inTime = (vo.inTime && vo.inTime.trim() !== '') ? vo.inTime.substring(11, 19) : ''; // HH:MM:SS만 추출함.
		const outTime = (vo.outTime && vo.outTime.trim() !== '') ? vo.outTime.substring(11, 19) : ''; // HH:MM:SS만 추출함.

		return {
			title: attStatus,
			date: dateStr,
			allDay: true, // 종일 이벤트로 설정함.
			color: colorMapLocal[attStatus] || '#999',
			attStatus: attStatus,
			inTime: inTime,
			outTime: outTime,
			breakTime: "01:00:00",
			dayFulltime: vo.dayFulltime // 근무 시간 정보를 포함함.
		};
	}).filter(event => event.color); // 색상이 정의된 이벤트만 최종적으로 반환함.
}


// =============================================================
//  [이벤트 핸들러 영역] Document Ready 내부 (페이지 로드 완료 시 실행)
// =============================================================
$(document).ready(function() {
	const $VacationModal = $('#vacationModal');
	const $btnVacation = $('#btnVacation');
	const $CommuteCorrectionModal = $('#commuteCorrectionModal');
	const $btnCommuteCorrection = $('#btnCommuteCorrection');

	// 휴가 신청 버튼 클릭 시 모달창을 띄움.
	$btnVacation.on('click', function() {
		$VacationModal.addClass('show');
	});

	// 출/퇴근 정정 신청 버튼 클릭 시 모달창을 띄움.
	$btnCommuteCorrection.on('click', function() {
		$CommuteCorrectionModal.addClass('show');
	});

	// 모달창 내부의 닫기 버튼(클래스 'close') 클릭 시 해당 모달을 닫음.
	$('.close').on('click', function() {
		$(this).closest('.modal').removeClass('show');
	});

	// 모달창 외부 영역 클릭 시 모달창을 닫음.
	$(window).on('click', function(event) {
		if (event.target === $VacationModal[0]) {
			$VacationModal.removeClass('show');
		}
		if (event.target === $CommuteCorrectionModal[0]) {
			$CommuteCorrectionModal.removeClass('show');
		}
	});

	// 출근버튼 - 출근 등록
	$('#checkIn').on('click', function() {
		// '/attend/checkIn' 경로로 AJAX GET 요청을 보냄.
		$.ajax({
			type: 'get'
			, url: '/attend/checkIn'
			, success: function(result) {
				if (result) {
					alert("출근시간 등록 :" + result)
					// 출근 시간을 화면에 표시함.
					$('#inTimeDisplay').text("출근시간: " + result);
				}
			},
			error: function(err) {
				alert('출첵 실패' + err.responseText);
			}
		})
	});

	// 퇴근버튼 - 퇴근 등록
	$('#checkOut').on('click', function() {
		// '/attend/checkOut' 경로로 AJAX GET 요청을 보냄.
		$.ajax({
			type: 'get'
			, url: '/attend/checkOut'
			, success: function(result) {
				if (result) {
					alert("퇴근시간 등록 :" + result)
					// 퇴근 시간을 화면에 표시함.
					$('#outTimeDisplay').text("퇴근시간: " + result);
				}
			},
			error: function(err) {
				alert('출첵 실패' + err.responseText);
			}
		})
	});

	// 외근버튼 - 외근 등록
	$('#fieldwork').on('click', function() {
		// '/attend/fieldwork' 경로로 AJAX GET 요청을 보냄.
		$.ajax({
			type: 'get'
			, url: '/attend/fieldwork'
			, success: function(result) {
				if (result) {
					alert("외근 시작시간 등록 :" + result)
					// 외근 시작 시간을 화면에 표시함.
					$('#fieldworkDisplay').text("외근시작: " + result);
				}
			},
			error: function(err) {
				alert('외근 등록 실패' + err.responseText);
			}
		})
	});

	// 달력 월 이동 버튼 이벤트 (FullCalendar의 툴바 청크 클릭 감지)
	$('#calendar').on('click', '.fc-toolbar-chunk', function(e) {
		const $target = $(e.target).closest('button');
		if ($target.length === 0) return; // 버튼 클릭이 아니면 무시함.

		e.stopPropagation();

		// 현재 캘린더 제목에서 "2025년 11월" 같은 텍스트를 추출함.
		let dateKr = $('#fc-dom-1').text();
		// "2025년 11월"을 서버에 보낼 "2025-11" 형태로 변환함.
		let ConvertDate = dateKr.replace('년', '-').replace('월', '').replaceAll(' ', '');
		let param = { date: ConvertDate };

		// '/attend/calendar' 경로로 해당 월의 근태 기록을 요청함.
		$.ajax({
			type: 'get'
			, url: '/attend/calendar'
			, data: param
			, success: function(voList) {
				// 1. 기존 달력 이벤트 모두 제거함.
				calendar.removeAllEvents();
				// 2. 서버에서 받은 VO 목록을 FullCalendar 이벤트 형식으로 변환함.
				const newEvents = convertVoToFullCalendarEvents(voList);
				// 3. 변환된 이벤트들을 달력에 추가함.
				newEvents.forEach(event => {
					calendar.addEvent(event);
				});
				// 4. 전역 변수 appendEvents를 새 이벤트 목록으로 갱신함.
				if (typeof appendEvents !== 'undefined') {
					appendEvents = newEvents;
				}

				// 5. 갱신된 데이터와 해당 월의 1일을 기준으로 차트를 업데이트함.
				const newBaseDate = ConvertDate + "-01";
				updateDonutChart(newEvents, newBaseDate);
			},
			error: function(err) {
				alert('실패:' + err.responseText);
			}
		})
	});
});