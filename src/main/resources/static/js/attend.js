// attend.js

function parseFulltimeToMinutes(fulltimeStr) {
	if (!fulltimeStr || fulltimeStr.trim() === 'null') return 0;
	try {
		const timePart = fulltimeStr.split(" ")[1];
		const parts = timePart.split(":");
		if (parts.length === 3) {
			const hours = parseInt(parts[0], 10);
			const minutes = parseInt(parts[1], 10);
			return (hours * 60) + minutes;
		}
	} catch (e) {
		console.error("근무 시간 파싱 오류:", fulltimeStr, e);
	}
	return 0;
}

function getCurrentWeekRange(dateParam) {
	const today = dateParam ? new Date(dateParam) : new Date();
	const dayOfWeek = today.getDay();
	let startOfWeek = new Date(today.setDate(today.getDate() - (dayOfWeek === 0 ? 6 : dayOfWeek - 1)));
	const endOfWeek = new Date(startOfWeek);
	endOfWeek.setDate(startOfWeek.getDate() + 6);

	const formatDate = (date) => {
		const y = date.getFullYear();
		const m = String(date.getMonth() + 1).padStart(2, '0');
		const d = String(date.getDate()).padStart(2, '0');
		return `${y}-${m}-${d}`;
	};

	return {
		start: formatDate(startOfWeek),
		end: formatDate(endOfWeek)
	};
}

function calculateTotalWeeklyMinutes(events, currentDisplayDate) {
	const { start, end } = getCurrentWeekRange(currentDisplayDate);
	let totalMinutes = 0;

	events.forEach(event => {
		const eventDate = event.date;
		if (eventDate >= start && eventDate <= end) {
			if (['출근', '지각', '외근', '출장'].includes(event.attStatus)) {
				totalMinutes += parseFulltimeToMinutes(event.dayFulltime);
			}
		}
	});
	return totalMinutes;
}

function calculateTotalMonthlyHours(events) {
	let monthlyHours = 0;
	events.forEach(event => {
		if (event.dayFulltime && event.dayFulltime.trim() !== "") {
			monthlyHours += parseFulltimeToMinutes(event.dayFulltime) / 60;
		}
	});
	return parseFloat(monthlyHours.toFixed(1));
}


function updateDonutChart(events, currentDisplayDate) {

	if (typeof myChart === 'undefined') {

		console.warn("Chart 객체 없음 (로딩 중일 수 있음)");
		return;
	}

	const monthlyTotalHours = 209;
	const weeklyTotalHours = 40;

	const monthlyWorkedHours = calculateTotalMonthlyHours(events);
	const monthlyRemainingHours = Math.max(0, monthlyTotalHours - monthlyWorkedHours);
	const monthlyWorkedPercentage = ((monthlyWorkedHours / monthlyTotalHours) * 100).toFixed(1);

	const totalWeeklyMinutes = calculateTotalWeeklyMinutes(events, currentDisplayDate);
	const weeklyWorkedHours = parseFloat((totalWeeklyMinutes / 60).toFixed(1));
	const weeklyRemainingHours = Math.max(0, weeklyTotalHours - weeklyWorkedHours);
	const weeklyWorkedPercentage = ((weeklyWorkedHours / weeklyTotalHours) * 100).toFixed(1);

	// 데이터셋 업데이트
	myChart.data.datasets[0].data = [monthlyWorkedHours, monthlyRemainingHours];
	myChart.data.datasets[1].data = [weeklyWorkedHours, weeklyRemainingHours];

	// 차트 옵션(Totals) 업데이트
	if (!myChart.options.chartTotals) {
		myChart.options.chartTotals = {};
	}
	myChart.options.chartTotals.monthlyWorkedPercentage = monthlyWorkedPercentage;
	myChart.options.chartTotals.weeklyWorkedPercentage = weeklyWorkedPercentage;

	// 요약 박스 업데이트
	const summaryBox = document.getElementById('summaryBox');
	if (summaryBox) {
		summaryBox.innerHTML =
			'<h3>월간 근무 현황</h3>' +
			'<p>총 근무: <b>' + monthlyWorkedHours + ' / ' + monthlyTotalHours + ' 시간</b> (' + monthlyWorkedPercentage + '%)</p>' +
			'<hr style="border: none; border-top: 1px dashed #ccc; margin: 10px 50px;">' +
			'<h3>주간 근무 현황</h3>' +
			'<p>총 근무: <b>' + weeklyWorkedHours + ' / ' + weeklyTotalHours + ' 시간</b> (' + weeklyWorkedPercentage + '%)</p>';
	}

	myChart.update();
}

function convertVoToFullCalendarEvents(voList) {
	// 색상 맵은 내부 혹은 전역에 있어야 함. 안전하게 내부에 정의하거나 전역 변수 참조
	const colorMapLocal = {
		'출근': '#4CAF50', '연차': '#2196F3', '반차': '#00BCD4',
		'휴가': '#2196F3', '결근': '#FF9800', '지각': '#FFEB3B',
		'조퇴': '#FFC107', '출장': '#9E9E9E', '외근': '#9E9E9E'
	};

	return voList.filter(vo => vo.dateAttend).map(vo => {
		const attStatus = vo.attStatus;
		const dateStr = vo.dateAttend.substring(0, 10);
		const inTime = (vo.inTime && vo.inTime.trim() !== '') ? vo.inTime.substring(11, 19) : '';
		const outTime = (vo.outTime && vo.outTime.trim() !== '') ? vo.outTime.substring(11, 19) : '';

		return {
			title: attStatus,
			date: dateStr,
			allDay: true,
			color: colorMapLocal[attStatus] || '#999',
			attStatus: attStatus,
			inTime: inTime,
			outTime: outTime,
			breakTime: "01:00:00",
			dayFulltime: vo.dayFulltime
		};
	}).filter(event => event.color);
}


// =============================================================
//  [이벤트 핸들러 영역] Document Ready 내부
// =============================================================
$(document).ready(function() {
	const $VacationModal = $('#vacationModal');
	const $btnVacation = $('#btnVacation');
	const $CommuteCorrectionModal = $('#commuteCorrectionModal');
	const $btnCommuteCorrection = $('#btnCommuteCorrection');

	$btnVacation.on('click', function() {
		$VacationModal.addClass('show');
	});

	$btnCommuteCorrection.on('click', function() {
		$CommuteCorrectionModal.addClass('show');
	});

	$('.close').on('click', function() {
		$(this).closest('.modal').removeClass('show');
	});

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
		// alert("출근버튼 클릭");
		$.ajax({
			type: 'get'
			, url: '/attend/checkIn'
			, success: function(result) {
				if (result) {
					alert("출근시간 등록 :" + result)
					$('#inTimeDisplay').text("출근시간: " + result);
				}
			},
			error: function(err) {
				alert('출첵 실패~' + err.responseText);
			}
		})
	});

	// 퇴근버튼 - 퇴근 등록
	$('#checkOut').on('click', function() {

		$.ajax({
			type: 'get'
			, url: '/attend/checkOut'
			, success: function(result) {
				if (result) {
					alert("퇴근시간 등록 :" + result)
					$('#outTimeDisplay').text("퇴근시간: " + result);
				}
			},
			error: function(err) {
				alert('출첵 실패~' + err.responseText);
			}
		})
	});

	// 달력 월 이동 버튼 이벤트
	$('#calendar').on('click', '.fc-toolbar-chunk', function(e) {
		const $target = $(e.target).closest('button');
		if ($target.length === 0) return;

		e.stopPropagation();

		// 텍스트 추출 (예: "2025년 11월")
		let dateKr = $('#fc-dom-1').text();
		// 변환 (예: "2025-11")
		let ConvertDate = dateKr.replace('년', '-').replace('월', '').replaceAll(' ', '');
		let param = { date: ConvertDate };

		$.ajax({
			type: 'get'
			, url: '/attend/calendar'
			, data: param
			, success: function(voList) {
				// 1. 달력 이벤트 리셋
				calendar.removeAllEvents();
				// 2. 변환
				const newEvents = convertVoToFullCalendarEvents(voList);
				// 3. 추가
				newEvents.forEach(event => {
					calendar.addEvent(event);
				});
				// 4. 전역 변수 업데이트 (attend.jsp에 있는 appendEvents)
				// 주의: appendEvents가 const가 아닌 let으로 선언되어 있어야 함
				if (typeof appendEvents !== 'undefined') {
					appendEvents = newEvents;
				}

				// 5. 차트 업데이트 (기준일: 해당 월의 1일)
				const newBaseDate = ConvertDate + "-01";
				updateDonutChart(newEvents, newBaseDate);
			},
			error: function(err) {
				alert('실패:' + err.responseText);
			}
		})
	});
});