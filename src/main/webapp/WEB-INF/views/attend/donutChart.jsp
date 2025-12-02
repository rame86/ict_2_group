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
	//****************** 도넛 그래프 영역 **********************************
    // --- 1. 월간 근무 시간 데이터 설정 (바깥쪽 도넛) ---
    const monthlyTotalHours = 209;
    const monthlyWorkedHours = 107;
    const monthlyRemainingHours = monthlyTotalHours - monthlyWorkedHours;
    const monthlyWorkedPercentage = ((monthlyWorkedHours / monthlyTotalHours) * 100).toFixed(1);

    // --- 2. 주간 근무 시간 데이터 설정 (안쪽 도넛) ---
    const weeklyTotalHours = 40;
    const weeklyWorkedHours = 37;
    const weeklyRemainingHours = weeklyTotalHours - weeklyWorkedHours;
    const weeklyWorkedPercentage = ((weeklyWorkedHours / weeklyTotalHours) * 100).toFixed(1);

    // --- HTML 요약 상자에 내용 채우기 (문자열 결합 방식으로 통일) ---
    document.getElementById('summaryBox').innerHTML = 
        '<h3>월간 근무 현황</h3>' +
        '<p>총 근무: **' + monthlyWorkedHours + ' / ' + monthlyTotalHours + ' 시간** (' + monthlyWorkedPercentage + '%)</p>' +
        '<hr style="border: none; border-top: 1px dashed #ccc; margin: 10px 50px;">' +
        '<h3>주간 근무 현황</h3>' +
        '<p>총 근무: **' + weeklyWorkedHours + ' / ' + weeklyTotalHours + ' 시간** (' + weeklyWorkedPercentage + '%)</p>';

    
    // --- 차트에 사용될 데이터셋 ---
    const data = {
        labels: [], 
        datasets: [
            // 바깥쪽 도넛 (월간)
            {
                label: '월간 근무 시간',
                data: [monthlyWorkedHours, monthlyRemainingHours],
                backgroundColor: [
                    'rgba(54, 162, 235, 0.7)', 
                    'rgba(201, 203, 207, 0.7)' 
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
                    'rgb(255, 159, 64)',
                    'rgb(230, 230, 230)'
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
                        generateLabels: function(chart) {
                            // 월간 근무, 월간 남은 시간 (백틱 제거)
                            const monthlyLabels = [{
                                text: '월간 근무 (' + monthlyWorkedPercentage + '%)',
                                fillStyle: 'rgba(54, 162, 235, 0.7)',
                                strokeStyle: 'white',
                                lineWidth: 2
                            }, {
                                text: '월간 남은 (' + (100 - monthlyWorkedPercentage).toFixed(1) + '%)',
                                fillStyle: 'rgba(201, 203, 207, 0.7)',
                                strokeStyle: 'white',
                                lineWidth: 2
                            }];
                            
                            // 주간 근무, 주간 남은 시간 (백틱 제거)
                            const weeklyLabels = [{
                                text: '주간 근무 (' + weeklyWorkedPercentage + '%)',
                                fillStyle: 'rgb(255, 159, 64)',
                                strokeStyle: 'white',
                                lineWidth: 2
                            }, {
                                text: '주간 남은 (' + (100 - weeklyWorkedPercentage).toFixed(1) + '%)',
                                fillStyle: 'rgb(230, 230, 230)',
                                strokeStyle: 'white',
                                lineWidth: 2
                            }];

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
                        // 툴팁 출력 설정 (백틱 제거)
                        label: function(context) {
                            const datasetIndex = context.datasetIndex;
                            const value = context.parsed;
                            let total, labelPrefix, percentage;

                            if (datasetIndex === 0) { // 월간 데이터셋
                                total = monthlyTotalHours;
                                labelPrefix = (context.dataIndex === 0) ? '월간 근무: ' : '월간 남은: ';
                            } else { // 주간 데이터셋
                                total = weeklyTotalHours;
                                labelPrefix = (context.dataIndex === 0) ? '주간 근무: ' : '주간 남은: ';
                            }
                            
                            percentage = ((value / total) * 100).toFixed(1);
                            
                            // 툴팁 최종 리턴값도 문자열 결합으로 변경
                            return labelPrefix + value + '시간 (' + percentage + '%)';
                        }
                    }
                }
            }
        },
    };

    // 캔버스 요소를 가져와 차트 생성
    const nestedWorkHoursChart = new Chart(
        document.getElementById('nestedWorkHoursChart'),
        config
    );
    
	//****************** 도넛 그래프 영역 끝 **********************************
    </script>
</body>
</html>