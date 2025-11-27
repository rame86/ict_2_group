<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>휴가 신청 폼 (통일 스타일 적용)</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Tailwind CSS CDN 로드 -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- jQuery CDN 로드 -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
    <script>
        // Tailwind Config: 첫 번째 폼과 동일한 설정을 적용
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'Noto Sans KR', 'sans-serif'],
                    },
                    colors: {
                        primary: '#f69022', // 주황색
                        'gray-light': '#e5e5e5', 
                        'blue-primary': '#1d4ed8', // 폼셋 레전드 및 버튼용 진한 파란색
                    }
                }
            }
        }

        jQuery(document).ready(function($) {
            
            // --- 휴가 정보 조회 모달 로직 시작 ---
            const remainingVacationData = [
                { name: "유급휴가", remaining: 4, total: 15 },
                { name: "포상휴가", remaining: 7, total: 7 },
                { name: "병가", remaining: "N/A", total: "N/A" } // N/A는 잔여 정보가 없는 경우 예시
            ];

            const $modal = $('#vacationModal');
            const $viewButton = $('#viewVacationInfoBtn');
            const $closeButton = $('#closeModalBtn');
            const $okButton = $('#okModalBtn');
            const $infoDisplay = $('#vacationInfoDisplay');

            // 잔여 휴가 정보를 HTML로 만들어 삽입하는 함수
            function displayVacationInfo() {
                let htmlContent = '';
                remainingVacationData.forEach(item => {
                    // 잔여 정보가 있는 경우 (예: 4일/15일)
                    const total = item.total !== "N/A" ? `/${item.total}일` : '';
                    const remaining = item.remaining !== "N/A" ? `${item.remaining}일` : '정보 없음';
                    
                    htmlContent += `
                        <p class="text-gray-700 text-base md:text-lg">
                            <span class="font-bold text-blue-primary">${item.name} 잔여:</span> 
                            ${remaining}${total}
                        </p>
                    `;
                });
                $infoDisplay.html(htmlContent);
            }

            // 모달 표시 함수
            function showModal() {
                displayVacationInfo(); // 모달 표시 전 데이터 업데이트
                $modal.removeClass('hidden').addClass('flex');
            }

            // 모달 숨김 함수
            function closeModal() {
                $modal.removeClass('flex').addClass('hidden');
            }

            // 이벤트 바인딩
            $viewButton.on('click', showModal);
            $closeButton.on('click', closeModal);
            $okButton.on('click', closeModal);

            // 모달 바깥 영역 클릭 시 모달 닫기
            $modal.on('click', function(e) {
                if (e.target === this) {
                    closeModal();
                }
            });
            // --- 휴가 정보 조회 모달 로직 끝 ---

            // 폼 제출 이벤트 핸들러 (더미)
            $('#vacationForm').on('submit', function(e) {
                e.preventDefault();
                console.log('휴가 신청 제출됨!');
                const formData = new FormData(this); 
                for (let [key, value] of formData.entries()) {
                    console.log(key + ': ' + value);
                }
                alert('휴가 신청이 성공적으로 접수되었습니다.'); 
                // this.reset();
            });

            // 취소 버튼 클릭 시 동작 (더미)
            $('#cancelBtn').on('click', function() {
                alert('휴가 신청을 취소합니다. (실제로는 이전 페이지로 이동)');
            });

            // 초기 로드 시 한 번 실행하여 폼 상태를 설정
            handleVacationTypeChange();

            // 시작일(startDate) 또는 종료일(endDate)이 변경될 때마다 calculateDays 함수 실행
            $('#startDate, #endDate').on('change', calculateDays);
            
            // 휴가 종류가 변경될 때마다 필드 가시성 제어 함수 실행
            $('#vacationType').on('change', handleVacationTypeChange);

            function handleVacationTypeChange() {
                const selectedType = $('#vacationType').val();
                const $endDateGroup = $('#endDateGroup');
                const $totalDaysGroup = $('#totalDaysGroup');
                const $startDateLabel = $('#startDateLabel');
                const $totalDaysInput = $('#totalDays');
                const $proofUploadGroup = $('#proofUploadGroup'); // 증빙 자료 그룹

                // 반차(half_am, half_pm)인 경우
                if (selectedType === 'half_am' || selectedType === 'half_pm') {
                    // 필드 숨기기
                    $endDateGroup.hide();
                    $totalDaysGroup.hide();
                    
                    // 시작일 라벨을 '신청일'로 변경
                    $startDateLabel.text('신청일:');
                    
                    // 반차일 때는 증빙 자료 숨김
                    $proofUploadGroup.hide();

                } else {
                    // 일반 휴가(연차, 병가, 보상 휴가 등)인 경우
                    $endDateGroup.show();
                    $totalDaysGroup.show();
                    
                    // 시작일 라벨을 '시작일'로 복원
                    $startDateLabel.text('시작일:');
                    
                    // 일수 재계산
                    calculateDays();

                    // 병가(sick)인 경우에만 증빙 자료 표시
                    if (selectedType === 'sick') {
                        $proofUploadGroup.show();
                    } else {
                        $proofUploadGroup.hide();
                    }
                }
            }

            function calculateDays() {
                const startValue = $('#startDate').val();
                const endValue = $('#endDate').val();
                const $totalDaysInput = $('#totalDays');
                const selectedType = $('#vacationType').val();

                // 반차일 경우 일수 계산 로직을 건너뜀
                if (selectedType === 'half_am' || selectedType === 'half_pm') {
                    $totalDaysInput.val('0.5 일'); // 반차는 0.5일로 고정
                    return;
                }

                if (!startValue || !endValue) {
                    $totalDaysInput.val('0 일');
                    return;
                }

                const startDate = new Date(startValue);
                const endDate = new Date(endValue);

                if (startDate > endDate) {
                    console.error('시작일은 종료일보다 늦을 수 없습니다.');
                    $totalDaysInput.val('0 일');
                    // 오류 시 종료일을 시작일로 강제 설정하여 사용자에게 수정 유도
                    $('#endDate').val(startValue); 
                    return;
                }

                // 날짜 차이 계산 (당일 포함을 위해 + 1)
                const timeDifference = endDate.getTime() - startDate.getTime();
                const millisecondsPerDay = 1000 * 60 * 60 * 24;
                // 평일(주말 제외)만 계산하는 로직이 필요하다면 더 복잡해지지만, 여기서는 단순 일수 차이만 계산
                const dayDifference = Math.round(timeDifference / millisecondsPerDay) + 1; 

                $totalDaysInput.val(dayDifference + ' 일');
            }
        });
    </script>
    <style>
        /* 버튼 스타일: 첫 번째 폼과 동일하게 둥근 모양 및 Tailwind 클래스 사용 */
        .custom-btn {
            padding: 12px 30px;
            border-radius: 9999px;
            font-weight: 600;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: all 0.2s ease-in-out;
            min-width: 120px;
            border: none;
        }
        .custom-btn:hover {
            background-color: #d4d4d4;
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            transform: translateY(-1px);
        }
        
        /* 폼 컨테이너 스타일: 첫 번째 폼과 동일하게 중앙 배치 및 크기 지정 */
        .form-container { 
            max-width: 500px; 
            margin: 40px auto; 
            padding: 30px; 
            background-color: white;
            border-radius: 12px; 
            box-shadow: 0 8px 30px rgba(0,0,0,0.1); 
        }
        
        /* 텍스트 영역 크기 조절 방지 */
        textarea {
            resize: none; 
        }

        /* 폼 그룹 스타일: 첫 번째 폼과 동일한 flex 레이아웃 */
        .form-group-flex {
            display: flex;
            align-items: center;
            margin-bottom: 1rem; /* mb-4 (1rem) */
        }

        /* 라벨 스타일: 너비 고정 */
        .form-label {
            width: 140px; /* 라벨 너비 고정 */
            font-size: 0.875rem; /* text-sm */
            font-weight: 600; /* font-semibold */
            color: #4b5563; /* text-gray-700 */
            flex-shrink: 0;
        }

        /* 입력/선택 필드 스타일 */
        .form-input {
            flex-grow: 1; /* flex-1 */
            padding: 0.5rem; /* p-2 */
            border: 1px solid #d1d5db; /* border border-gray-300 */
            border-radius: 0.375rem; /* rounded-md */
        }
        
        /* 자동 입력 필드 스타일 */
        .auto-filled-input {
            background-color: #f9fafb; /* bg-gray-50 */
            color: #4b5563; /* text-gray-600 */
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen">

    <div class="form-container">
        <h2 class="text-2xl font-bold text-gray-800 text-center mb-8 pb-2">휴가 신청</h2>
        
        <form id="vacationForm" action="#" method="POST" class="space-y-6" enctype="multipart/form-data">
            
            <!-- 1. 신청자 정보 (자동 입력) -->
            <fieldset class="p-4 border border-gray-200 rounded-lg">
                <legend class="text-sm font-bold text-blue-600 px-2">신청자 정보 (자동 입력)</legend>
                
                <div class="form-group-flex">
                    <label for="employeeName" class="form-label text-sm font-medium text-gray-600">이름:</label> 
                    <input type="text" id="employeeName" name="empName" value="${sessionScope.login.empName}" readonly class="form-input auto-filled-input">
                </div>
                
                <div class="form-group-flex">
                    <label for="employeeId" class="form-label text-sm font-medium text-gray-600">사번:</label> 
                    <input type="text" id="employeeId" name="empNo" value="${sessionScope.login.empNo}" readonly class="form-input auto-filled-input">
                </div>
                
                <div class="form-group-flex">
                    <label for="department" class="form-label text-sm font-medium text-gray-600">부서:</label> 
                    <input type="text" id="department" name="deptName" value="${sessionScope.login.deptName}" readonly class="form-input auto-filled-input">
                </div>
                
            </fieldset>
            
            <!-- 휴가 정보 조회 버튼 추가 -->
            <div class="flex justify-end pt-2 mb-4">
                <button type="button" id="viewVacationInfoBtn" class="bg-blue-primary text-white text-sm font-medium py-2 px-4 rounded-lg shadow-md hover:bg-blue-700 transition duration-150">
                    잔여 휴가 정보 조회
                </button>
            </div>

            <!-- 2. 휴가 정보 입력 -->
            <fieldset class="p-4 border border-gray-200 rounded-lg">
                <legend class="text-sm font-bold text-blue-600 px-2">휴가 정보 입력</legend>

                <!-- 휴가 종류 -->
                <div class="form-group-flex">
                    <label for="vacationType" class="form-label">휴가 종류:</label> 
                    <select id="vacationType" name="vacationType" required class="form-input focus:border-blue-500 focus:ring focus:ring-blue-200">
                        <option value="" disabled selected>선택하세요</option>
                        <option value="annual">연차</option>
                        <option value="half_am">반차 (오전)</option>
                        <option value="half_pm">반차 (오후)</option>
                        <option value="sick">병가</option>
                        <option value="compensatory">보상 휴가</option>
                        <option value="other">기타</option>
                    </select>
                </div>

                <!-- 시작일/신청일 -->
                <div class="form-group-flex">
                    <label for="startDate" id="startDateLabel" class="form-label">시작일:</label>
                    <input type="date" id="startDate" name="startDate" required class="form-input focus:border-blue-500 focus:ring focus:ring-blue-200"> 
                </div>

                <!-- 종료일 그룹 (JavaScript로 가시성 제어) -->
                <div class="form-group-flex" id="endDateGroup">
                    <label for="endDate" class="form-label">종료일:</label>
                    <input type="date" id="endDate" name="endDate" required class="form-input focus:border-blue-500 focus:ring focus:ring-blue-200">
                </div>
                
                <!-- 신청 일수 그룹 (JavaScript로 가시성 제어) -->
                <div class="form-group-flex" id="totalDaysGroup">
                    <label for="totalDays" class="form-label">신청 일수:</label>
                    <input type="text" id="totalDays" value="0 일" readonly class="form-input auto-filled-input">
                </div>

				<!-- 휴가 사유 -->
				<div class="flex flex-col mb-4">
                    <label for="reason" class="text-sm font-semibold text-gray-700 mb-2">휴가 사유:</label>
                    <textarea id="reason" name="reason" rows="6" placeholder="휴가 사유를 상세히 입력해 주세요." required class="w-full p-2 border border-gray-300 rounded-md resize-none focus:border-blue-500 focus:ring focus:ring-blue-200"></textarea>
                </div>
                
                <!-- 비상 연락처 -->
                <div class="form-group-flex">
                    <label for="emergencyContact" class="form-label">비상 연락처:</label> 
                    <input type="tel" id="emergencyContact" name="emergencyContact" placeholder="010-XXXX-XXXX" class="form-input focus:border-blue-500 focus:ring focus:ring-blue-200">
                </div>
                
                <!-- 증빙 자료 업로드 그룹 (병가 선택 시에만 표시) -->
                <div class="form-group-flex" id="proofUploadGroup" style="display:none;">
                    <label for="proofFile" class="form-label">증빙 자료 제출:</label>
                    <input type="file" id="proofFile" name="proofFile" accept=".pdf, .jpg, .png" class="flex-1 p-2 border border-gray-300 rounded-md focus:border-blue-500 focus:ring focus:ring-blue-200"> 
                </div>

            </fieldset>

            <!-- 버튼 영역 -->
            <div class="flex justify-center pt-4 space-x-4">
                <button type="submit" class="custom-btn bg-gray-light text-gray-800 hover:bg-primary hover:text-white">신청</button>
                <button type="button" id="cancelBtn" class="custom-btn bg-gray-light text-gray-800">취소</button>
            </div>
        </form>
    </div>
    
    <!-- 잔여 휴가 정보 모달 (숨김 상태) -->
    <div id="vacationModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden p-4">
        <div class="bg-white p-6 rounded-xl shadow-2xl w-full max-w-sm transform transition-all duration-300 scale-100 opacity-100">
            <div class="flex justify-between items-center border-b pb-3 mb-4">
                <h3 class="text-xl font-bold text-gray-800">잔여 휴가 정보</h3>
                <!-- 닫기 버튼 (X 아이콘) -->
                <button id="closeModalBtn" class="text-gray-500 hover:text-gray-800 text-3xl leading-none">&times;</button>
            </div>
            
            <div id="vacationInfoDisplay" class="space-y-4 text-base">
                <!-- Data will be injected here by jQuery -->
                <!-- 예시: <p class="text-gray-700"><span class="font-bold text-blue-primary">유급휴가 잔여:</span> 4일/15일</p> -->
            </div>

            <div class="mt-8 flex justify-center">
                <button type="button" id="okModalBtn" class="bg-primary text-white font-semibold py-2 px-6 rounded-lg hover:bg-orange-600 transition duration-150 shadow-md">
                    확인
                </button>
            </div>
        </div>
    </div>

</body>
</html>