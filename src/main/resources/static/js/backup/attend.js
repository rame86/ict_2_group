// /js/attend.js 파일 내용 
$(document).ready(function() {
	// 1. 요소 선택 및 변수 정의
	const $VacationModal = $('#vacationModal');
	const $btnVacation = $('#btnVacation');

	// 출/퇴근 정정 모달 및 버튼
	const $CommuteCorrectionModal = $('#commuteCorrectionModal');
	const $btnCommuteCorrection = $('#btnCommuteCorrection');

	// 2. '휴가 신청' 버튼 클릭 이벤트
	$btnVacation.on('click', function() {
		$VacationModal.addClass('show');
	});

	// 3. '출/퇴근 정정 신청' 버튼 클릭 이벤트
	$btnCommuteCorrection.on('click', function() {
		$CommuteCorrectionModal.addClass('show');
	});

	// 4. 공통 닫기 로직 (모달 내 'X' 버튼 클릭)
	$('.close').on('click', function() {
		$(this).closest('.modal').removeClass('show');
	});

	// 5. 모달 바깥 영역 클릭 시 (모달 닫기)
	$(window).on('click', function(event) {
		if (event.target === $VacationModal[0]) {
			$VacationModal.removeClass('show');
		}
		if (event.target === $CommuteCorrectionModal[0]) {
			$CommuteCorrectionModal.removeClass('show');
		}
	});

	// 체크인 버튼
	$('#checkIn').on('click', function() {
		alert("출근버튼 클릭");
		$.ajax({
			type: 'get'
			, url: '/attend/checkIn'
			, success: function(result) {
				// 체크시간 출력
				if (result) {
					alert("출근시간~" + result)
					$('#inTimeDisplay').text("출근시간: " + result);
				}
			},
			error: function(err) {
				alert('실패:' + err.responseText);
			}
		})

	});

	//달력 전환 함수
	function convertVoToFullCalendarEvents(voList) {
		return voList.filter(vo => vo.dateAttend).map(vo => {
			const attStatus = vo.attStatus;

			// 날짜 형식 정리 (VO에서 dateAttend는 yyyy-MM-dd HH:mm:ss 형태일 수 있음)
			const dateStr = vo.dateAttend.substring(0, 10);

			// 시간 정리
			const inTime = (vo.inTime && vo.inTime.trim() !== '') ? vo.inTime.substring(11, 19) : '';
			const outTime = (vo.outTime && vo.outTime.trim() !== '') ? vo.outTime.substring(11, 19) : '';

			return {
				title: attStatus,
				date: dateStr,
				allDay: true,
				color: colorMap[attStatus],
				attStatus: attStatus,

				// dateClick에서 사용하기 위한 추가 데이터
				inTime: inTime,
				outTime: outTime,
				breakTime: "01:00:00",
				dayFulltime: vo.dayFulltime
			};
		}).filter(event => event.color); // colorMap에 없는 상태는 제외 (안전장치)
	}


	// 달력 월 이동 버튼 이벤트
	$('#calendar').on('click', '.fc-toolbar-chunk', function(e) {
		// 1. 클릭된 요소가 버튼인지 확인 (매우 중요!)
		const $target = $(e.target).closest('button');
		// 2. 버튼이 아닌 곳을 클릭했거나, 닫기 아이콘(span)을 클릭한 경우 함수 종료
		if ($target.length === 0) {
			return;
		}

		e.stopPropagation();
		/*alert($('#fc-dom-1').text());*/
		let dateKr = $('#fc-dom-1').text();
		let ConvertDate = dateKr.replace('년', '-').replace('월', '').replaceAll(' ', '');
		let param = { date: ConvertDate };

		$.ajax({
			type: 'get'
			, url: '/attend/calendar'
			, data: param
			, success: function(voList) {
				alert("성공! 데이터 개수: " + voList.length) // 디버깅용

				// 1. FullCalendar에서 현재 모든 이벤트를 제거
				calendar.removeAllEvents();

				// 2. 서버에서 받은 데이터를 FullCalendar 이벤트 객체로 변환
				const newEvents = convertVoToFullCalendarEvents(voList);

				// 3. 변환된 이벤트를 달력에 추가
				newEvents.forEach(event => {
					calendar.addEvent(event);
				});

				// 4. 전역 appendEvents 배열을 업데이트
				appendEvents = newEvents;

				// [추가] 현재 달력의 표시 날짜를 가져옵니다.
				// FullCalendar의 getDate()는 현재 표시된 뷰의 중간 날짜를 반환합니다.
				const currentDisplayDate = calendar.getDate().toISOString().substring(0, 10); // YYYY-MM-DD

				// 5. 차트 및 요약 박스 업데이트 함수 호출 (수정된 인자 전달)
				updateDonutChart(appendEvents, currentDisplayDate); // <--- currentDisplayDate 전달
			},
			error: function(err) {
				alert('실패:' + err.responseText);
			}
		})
	});

	// /js/attend.js 파일 내용 (기존 코드 아래에 추가)

	// =============================================================
	//                   주간 근무 시간 계산 유틸리티
	// =============================================================


	function parseFulltimeToMinutes(fulltimeStr) {
		if (!fulltimeStr || fulltimeStr.trim() === 'null') return 0;

		try {
			// 1. "0 8:0:0.0" -> ["0", "8:0:0.0"]
			const timePart = fulltimeStr.split(" ")[1];
			// 2. "8:0:0.0" -> ["8", "0", "0.0"]
			const parts = timePart.split(":");

			if (parts.length === 3) {
				const hours = parseInt(parts[0], 10);
				const minutes = parseInt(parts[1], 10);

				// 초(seconds)는 무시하거나 반올림할 수 있으나, 여기서는 시/분만 사용
				return (hours * 60) + minutes;
			}
		} catch (e) {
			console.error("근무 시간 파싱 오류:", fulltimeStr, e);
		}
		return 0;
	}

	// 기준이 되는 날짜(FullCalendar의 현재 표시 월)를 인자로 받도록 수정합니다.
	// dateParam은 'YYYY-MM-DD' 형태의 날짜 문자열이어야 합니다.
	function getCurrentWeekRange(dateParam) {
		// 1. 인자로 받은 날짜를 기준으로 Date 객체를 생성합니다.
		const today = dateParam ? new Date(dateParam) : new Date();

		const dayOfWeek = today.getDay(); // 0=일요일, 1=월요일, ..., 6=토요일
		// 월요일을 주의 시작(1)으로 맞추기 위한 조정
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


	/**
	 * 전역 appendEvents 배열을 사용하여 주간 총 근무 시간을 계산합니다.
	 * @param {Array} events - appendEvents 배열
	 * @param {string} currentDisplayDate - 현재 달력에 표시된 월/주/일의 기준 날짜 (YYYY-MM-DD)
	 * @returns {number} 총 근무 시간 (분)
	 */
	function calculateTotalWeeklyMinutes(events, currentDisplayDate) {
		// 수정된 getCurrentWeekRange 함수에 기준 날짜를 전달합니다.
		const { start, end } = getCurrentWeekRange(currentDisplayDate);
		let totalMinutes = 0;

		events.forEach(event => {
			const eventDate = event.date; // YYYY-MM-DD 포맷

			// 1. 이번 주차에 해당하는 이벤트인지 확인
			if (eventDate >= start && eventDate <= end) {
				// 2. 출근, 지각, 외근, 출장 등의 근무 상태인 경우만 합산 (결근, 휴가는 제외)
				if (['출근', '지각', '외근', '출장'].includes(event.attStatus)) {
					totalMinutes += parseFulltimeToMinutes(event.dayFulltime);
				}
			}
		});

		return totalMinutes;
	}

	/**
	 * 전역 appendEvents 배열을 사용하여 월간 총 근무 시간을 계산합니다.
	 * @param {Array} events - appendEvents 배열 (해당 월 전체 데이터)
	 * @returns {number} 총 근무 시간 (시간)
	 */
	function calculateTotalMonthlyHours(events) {
		let monthlyHours = 0;

		events.forEach(event => {
			if (event.dayFulltime && event.dayFulltime.trim() !== "") {
				// 이 함수는 donutChart.jsp의 parseDurationToHours 함수를 복사해야 함
				// 하지만, 이 예제에서는 편의상 parseFulltimeToMinutes를 재활용하여 시간으로 변환합니다.

				// 주의: parseFulltimeToMinutes는 분을 반환하므로 60으로 나누어 시간으로 변환
				monthlyHours += parseFulltimeToMinutes(event.dayFulltime) / 60;
			}
		});

		return parseFloat(monthlyHours.toFixed(1));
	}

	/**
	 * 분을 "HH:MM" 문자열로 포맷합니다.
	 */
	function formatMinutesToTime(totalMinutes) {
		const hours = Math.floor(totalMinutes / 60);
		const minutes = totalMinutes % 60;
		return `${hours}시간 ${String(minutes).padStart(2, '0')}분`;
	}


	// =============================================================
	//                   도넛 차트 업데이트 함수 (대폭 수정)
	// =============================================================

	/**
	 * 전역 appendEvents 배열과 차트를 사용하여 월간/주간 근무 데이터를 모두 업데이트합니다.
	 * @param {Array} events - appendEvents 배열 (해당 월 전체 데이터)
	 * @param {string} currentDisplayDate - 현재 달력의 표시 날짜 (YYYY-MM-DD) <--- 인자 추가
	 */
	function updateDonutChart(events, currentDisplayDate) {
		if (typeof myChart === 'undefined') {
			console.warn("Chart.js 객체(myChart)를 찾을 수 없습니다.");
			return;
		}

		// 기준 시간 (donutChart.jsp와 동일)
		const monthlyTotalHours = 209;
		const weeklyTotalHours = 40;

		// 1. 월간 근무 시간 계산 (Hours)
		const monthlyWorkedHours = calculateTotalMonthlyHours(events);
		const monthlyRemainingHours = Math.max(0, monthlyTotalHours - monthlyWorkedHours);
		const monthlyWorkedPercentage = ((monthlyWorkedHours / monthlyTotalHours) * 100).toFixed(1);

		// 2. 주간 근무 시간 계산 (Hours)
		const totalWeeklyMinutes = calculateTotalWeeklyMinutes(events); // 분 단위
		const weeklyWorkedHours = parseFloat((totalWeeklyMinutes / 60).toFixed(1)); // 시간 단위 (소수점 1자리)
		const weeklyRemainingHours = Math.max(0, weeklyTotalHours - weeklyWorkedHours);
		const weeklyWorkedPercentage = ((weeklyWorkedHours / weeklyTotalHours) * 100).toFixed(1);

		// 3. 차트 데이터셋 업데이트
		// 월간 데이터셋(인덱스 0) 업데이트
		myChart.data.datasets[0].data = [monthlyWorkedHours, monthlyRemainingHours];
		// 주간 데이터셋(인덱스 1) 업데이트
		myChart.data.datasets[1].data = [weeklyWorkedHours, weeklyRemainingHours];

		// [핵심 수정] Chart 옵션의 퍼센트 값을 업데이트하여 범례에 반영되도록 함
		if (!myChart.options.chartTotals) {
			myChart.options.chartTotals = {};
		}
		myChart.options.chartTotals.monthlyWorkedPercentage = monthlyWorkedPercentage;
		myChart.options.chartTotals.weeklyWorkedPercentage = weeklyWorkedPercentage;


		// 4. 요약 박스(summaryBox) 업데이트 (변경 없음)
		const summaryBox = document.getElementById('summaryBox');
		if (summaryBox) {
			summaryBox.innerHTML =
				'<h3>월간 근무 현황</h3>' +
				'<p>총 근무: <b>' + monthlyWorkedHours + ' / ' + monthlyTotalHours + ' 시간</b> (' + monthlyWorkedPercentage + '%)</p>' +
				'<hr style="border: none; border-top: 1px dashed #ccc; margin: 10px 50px;">' +
				'<h3>주간 근무 현황</h3>' +
				'<p>총 근무: <b>' + weeklyWorkedHours + ' / ' + weeklyTotalHours + ' 시간</b> (' + weeklyWorkedPercentage + '%)</p>';
		}

		// 5. 범례 업데이트 및 차트 갱신
		myChart.update();
	}

})