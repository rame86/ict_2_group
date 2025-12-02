<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>주간 & 월간 근무 시간 이중 그래프</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="/css/attend.css">
</head>
<body>

	<div class="chart-container">
		<canvas id="nestedWorkHoursChart"></canvas>
	</div>

	<div id="summaryBox"></div>

	<script>
document.addEventListener('DOMContentLoaded', function() {
    // =============================================================
    // 1. 데이터 파싱 및 계산 로직
    // =============================================================

    // attend.jsp의 전역 변수 appendEvents 가져오기 (없을 경우 빈 배열)
    const events = (typeof appendEvents !== 'undefined') ? appendEvents : [];
    
    // 현재 날짜 기준 설정
    // const today = new Date(); // 실제 환경에서는 이 날짜를 사용합니다.
    // 테스트 데이터가 필요하다면 아래와 같이 특정 날짜를 지정할 수 있습니다.
     const today = new Date('2025-11-20'); 

    let monthlyWorkedHours = 0;
    let weeklyWorkedHours = 0;

    // "0 8:0:0.0" 형태의 문자열을 시간(Number)으로 변환하는 함수
    function parseDurationToHours(dayFulltime) {
        if (!dayFulltime || dayFulltime.trim() === "") return 0;
        
        try {
            const parts = dayFulltime.split(' ');
            if (parts.length < 2) return 0;

            const timePart = parts[1];
            const timeComponents = timePart.split(':');

            const hours = parseInt(timeComponents[0], 10);
            const minutes = parseInt(timeComponents[1], 10);
            
            return hours + (minutes / 60);
        } catch (e) {
            console.error("시간 파싱 오류:", dayFulltime, e);
            return 0;
        }
    }

    // 주간 범위 계산 (이번주 일요일 ~ 토요일)
    const currentDay = today.getDay();
    const firstDayOfWeek = new Date(today);
    firstDayOfWeek.setDate(today.getDate() - currentDay);
    firstDayOfWeek.setHours(0,0,0,0);

    const lastDayOfWeek = new Date(firstDayOfWeek);
    lastDayOfWeek.setDate(firstDayOfWeek.getDate() + 6);
    lastDayOfWeek.setHours(23,59,59,999);

    // 이벤트 루프를 돌며 시간 합산
    events.forEach(event => {
        if (event.dayFulltime && event.dayFulltime.trim() !== "") {
            const workedHours = parseDurationToHours(event.dayFulltime);
            
            monthlyWorkedHours += workedHours;

            const eventDate = new Date(event.date);
            if (eventDate >= firstDayOfWeek && eventDate <= lastDayOfWeek) {
                weeklyWorkedHours += workedHours;
            }
        }
    });

    // 소수점 1자리까지만 유지
    monthlyWorkedHours = parseFloat(monthlyWorkedHours.toFixed(1));
    weeklyWorkedHours = parseFloat(weeklyWorkedHours.toFixed(1));


    // =============================================================
    // 2. 차트 설정 및 렌더링
    // =============================================================
    
    // 기준 시간 설정
    const monthlyTotalHours = 209;
    const weeklyTotalHours = 40;
    
    // 만약 데이터가 없어 0일 경우를 대비해 예시 데이터 사용 (배포 시 제거하거나 실제 데이터로 대체)
    // const monthlyWorkedHours = 107; 
    // const weeklyWorkedHours = 37;

    // 남은 시간 계산 (음수가 되지 않도록 0 처리)
    const monthlyRemainingHours = Math.max(0, monthlyTotalHours - monthlyWorkedHours);
    const weeklyRemainingHours = Math.max(0, weeklyTotalHours - weeklyWorkedHours);

    // 퍼센트 계산
    const monthlyWorkedPercentage = ((monthlyWorkedHours / monthlyTotalHours) * 100).toFixed(1);
    const weeklyWorkedPercentage = ((weeklyWorkedHours / weeklyTotalHours) * 100).toFixed(1);

    // 요약 박스 업데이트
    const summaryBox = document.getElementById('summaryBox');
    if(summaryBox) {
        summaryBox.innerHTML = 
            '<h3>월간 근무 현황</h3>' +
            '<p>총 근무: <b>' + monthlyWorkedHours + ' / ' + monthlyTotalHours + ' 시간</b> (' + monthlyWorkedPercentage + '%)</p>' +
            '<hr style="border: none; border-top: 1px dashed #ccc; margin: 10px 50px;">' +
            '<h3>주간 근무 현황</h3>' +
            '<p>총 근무: <b>' + weeklyWorkedHours + ' / ' + weeklyTotalHours + ' 시간</b> (' + weeklyWorkedPercentage + '%)</p>';
    }

    const data = {
        // [수정]: 툴팁이 작동하도록 레이블을 정의합니다. (툴팁 문제 해결)
    		labels: ['근무 시간', '잔여 시간'], 
            datasets: [
            // 바깥쪽 도넛 (월간)
            {
                label: '월간 근무 시간',
                data: [monthlyWorkedHours, monthlyRemainingHours],
                backgroundColor: [
                    'rgba(54, 162, 235, 0.7)', // 파란색 (월간 근무)
                    'rgba(201, 203, 207, 0.7)' // 회색 (월간 잔여)
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
                    'rgb(255, 159, 64)', // 주황색 (주간 근무)
                    'rgb(230, 230, 230)' // 연한 회색 (주간 잔여)
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
                        // [복원]: 월간/주간 근무/잔여 4가지 상세 범례를 복원합니다.
                        generateLabels: function(chart) {
                            // 월간 근무, 월간 남은 시간
                            const monthlyLabels = [{
                                text: '월간 근무 (' + monthlyWorkedPercentage + '%)',
                                fillStyle: 'rgba(54, 162, 235, 0.7)', // 파란색
                                strokeStyle: 'white',
                                lineWidth: 2
                            }, {
                                text: '월간 남은 (' + (100 - monthlyWorkedPercentage).toFixed(1) + '%)',
                                fillStyle: 'rgba(201, 203, 207, 0.7)', // 회색
                                strokeStyle: 'white',
                                lineWidth: 2
                            }];
                            
                            // 주간 근무, 주간 남은 시간
                            const weeklyLabels = [{
                                text: '주간 근무 (' + weeklyWorkedPercentage + '%)',
                                fillStyle: 'rgb(255, 159, 64)', // 주황색
                                strokeStyle: 'white',
                                lineWidth: 2
                            }, {
                                text: '주간 남은 (' + (100 - weeklyWorkedPercentage).toFixed(1) + '%)',
                                fillStyle: 'rgb(230, 230, 230)', // 연한 회색
                                strokeStyle: 'white',
                                lineWidth: 2
                            }];

                            // 월간 -> 주간 순으로 4개 레이블 모두 반환
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
                        label: function(context) {
                            const datasetIndex = context.datasetIndex;
                            const value = context.parsed;
                            let total, labelPrefix, percentage;

                            if (datasetIndex === 0) { // 월간 데이터셋 (바깥)
                                total = monthlyTotalHours;
                                labelPrefix = (context.dataIndex === 0) ? '월간 근무: ' : '월간 잔여: ';
                            } else { // 주간 데이터셋 (안쪽)
                                total = weeklyTotalHours;
                                labelPrefix = (context.dataIndex === 0) ? '주간 근무: ' : '주간 잔여: ';
                            }
                            
                            percentage = ((value / total) * 100).toFixed(1);
                            
                            return labelPrefix + value + '시간 (' + percentage + '%)';
                        }
                    }
                }
            }
        },
    };

    const canvas = document.getElementById('nestedWorkHoursChart');
    if (canvas) {
        new Chart(canvas, config);
    }
});
	</script>
</body>
</html>