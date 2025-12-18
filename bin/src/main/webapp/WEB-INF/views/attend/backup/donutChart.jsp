<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>donutChart.jsp</title>
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <link rel="stylesheet" href="/css/attend.css">
        </head>

        <body>

            <div class="chart-container">
                <canvas id="nestedWorkHoursChart"></canvas>
            </div>

            <div id="summaryBox"></div>

            <script>
                let myChart; // 전역 변수 선언

                document.addEventListener('DOMContentLoaded', function () {
                    // =============================================================
                    // 1. 데이터 파싱 및 계산 로직
                    // =============================================================

                    // attend.jsp의 전역 변수 appendEvents 가져오기 (없을 경우 빈 배열)
                    const events = (typeof appendEvents !== 'undefined') ? appendEvents : [];

                    // 현재 날짜 기준 설정
                    const today = new Date(); // 현재 날짜로 변경 (실제 사용 시)

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


                    // 주간 범위 계산 (이번주 월요일 ~ 일요일)
                    const currentDay = today.getDay(); // 0=일요일, 1=월요일, ..., 6=토요일

                    // 월요일을 주의 시작(1)으로 맞추기 위한 조정:
                    // 오늘이 일요일(0)이면 6일을 빼고, 아니면 day-1 만큼 뺀다.
                    const startOffset = currentDay === 0 ? 6 : currentDay - 1;

                    const firstDayOfWeek = new Date(today);
                    firstDayOfWeek.setDate(today.getDate() - startOffset); // 월요일로 설정
                    firstDayOfWeek.setHours(0, 0, 0, 0);

                    const lastDayOfWeek = new Date(firstDayOfWeek);
                    lastDayOfWeek.setDate(firstDayOfWeek.getDate() + 6); // 일요일로 설정
                    lastDayOfWeek.setHours(23, 59, 59, 999);

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
                    let monthlyTotalHours = 209;
                    let weeklyTotalHours = 40;

                    // 남은 시간 계산 (음수가 되지 않도록 0 처리)
                    let monthlyRemainingHours = Math.max(0, monthlyTotalHours - monthlyWorkedHours);
                    let weeklyRemainingHours = Math.max(0, weeklyTotalHours - weeklyWorkedHours);

                    // 퍼센트 계산
                    let monthlyWorkedPercentage = ((monthlyWorkedHours / monthlyTotalHours) * 100).toFixed(1);
                    let weeklyWorkedPercentage = ((weeklyWorkedHours / weeklyTotalHours) * 100).toFixed(1);

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

                    const data = {
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
                                borderRadius: 5,
                                totalHours: monthlyTotalHours
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
                                borderRadius: 5,
                                totalHours: weeklyTotalHours
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
                                        generateLabels: function (chart) {
                                            // 차트 옵션에서 최신 퍼센트 값 로드
                                            const chartTotals = chart.options.chartTotals || {
                                                monthlyWorkedPercentage: monthlyWorkedPercentage,
                                                weeklyWorkedPercentage: weeklyWorkedPercentage
                                            };

                                            const mPerc = chartTotals.monthlyWorkedPercentage;
                                            const wPerc = chartTotals.weeklyWorkedPercentage;

                                            // 월간 근무, 월간 남은 시간
                                            const monthlyLabels = [{
                                                text: '월간 근무 (' + mPerc + '%)',
                                                fillStyle: 'rgba(54, 162, 235, 0.7)',
                                                strokeStyle: 'white',
                                                lineWidth: 2
                                            }, {
                                                text: '월간 남은 (' + (100 - mPerc).toFixed(1) + '%)',
                                                fillStyle: 'rgba(201, 203, 207, 0.7)',
                                                strokeStyle: 'white',
                                                lineWidth: 2
                                            }];

                                            // 주간 근무, 주간 남은 시간
                                            const weeklyLabels = [{
                                                text: '주간 근무 (' + wPerc + '%)',
                                                fillStyle: 'rgb(255, 159, 64)',
                                                strokeStyle: 'white',
                                                lineWidth: 2
                                            }, {
                                                text: '주간 남은 (' + (100 - wPerc).toFixed(1) + '%)',
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
                                        // [수정] 툴팁 콜백이 데이터셋에 저장된 totalHours를 사용하도록 변경
                                        label: function (context) {
                                            const value = context.parsed;
                                            // 데이터셋에 직접 저장된 totalHours 값 사용
                                            const total = context.dataset.totalHours;

                                            let labelPrefix = (context.dataIndex === 0) ? '근무: ' : '잔여: ';

                                            // 월간/주간 레이블 식별
                                            if (context.datasetIndex === 0) {
                                                labelPrefix = '월간 ' + labelPrefix;
                                            } else {
                                                labelPrefix = '주간 ' + labelPrefix;
                                            }

                                            const percentage = ((value / total) * 100).toFixed(1);

                                            return labelPrefix + value + '시간 (' + percentage + '%)';
                                        }
                                    }
                                }
                            },
                            // [추가] 갱신된 퍼센트 값을 저장할 임시 옵션 객체
                            chartTotals: {
                                monthlyWorkedPercentage: monthlyWorkedPercentage,
                                weeklyWorkedPercentage: weeklyWorkedPercentage
                            }
                        },
                    };

                    const canvas = document.getElementById('nestedWorkHoursChart');
                    if (canvas) {
                        myChart = new Chart(canvas, config);
                    }
                });
            </script>
        </body>

        </html>