<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>vacationForm.jsp</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://cdn.tailwindcss.com"></script>
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

            // 폼 제출 이벤트 핸들러 (AJAX 전송)
			$('#vacationForm').on('submit', function(e) {
			    e.preventDefault(); // 기본 폼 제출 동작 방지
			    
			    const $form = $(this);
			    const actionUrl = $form.attr('action'); // 폼의 action 속성 값 (../approve/approve-form)
			    
			    // FormData 객체를 사용하여 폼의 모든 데이터 (텍스트 필드 + 파일)를 캡처
			    const formData = new FormData(this);
			    
			    // 폼 유효성 검사 (간단 예시)
			    if ($('#vacationType').val() === "") {
			        alert("휴가 종류를 선택해 주세요.");
			        return; 
			    }
                // **********************************************
                // 서버 전송 전 '일' 텍스트 제거 (서버 처리를 위해)
                const totalDaysVal = $('#totalDays').val().replace(' 일', '').trim();
                // 폼 데이터에 최종 숫자 값으로 덮어쓰기
                formData.set('totalDays', totalDaysVal);
                // **********************************************
			    
			    console.log('휴가 신청 AJAX 제출 시작...');
			
			    // 로딩 스피너 등을 표시하는 코드를 여기에 추가할 수 있습니다.
			    
			    $.ajax({
			        url: actionUrl,
			        type: 'POST',
			        data: formData,
			        processData: false, // FormData 사용 시 필수: 데이터를 쿼리 문자열로 변환하지 않음
			        contentType: false, // FormData 사용 시 필수: 적절한 Content-Type 헤더를 설정하도록 브라우저에 지시 (multipart/form-data)
			        
			        success: function(response) {
			            console.log('AJAX 성공 응답:', response);
			            
			            // 서버 응답에 따라 성공/실패 메시지 처리
			            if (response && response.success) { // 휴가 신청 성공 시
			                alert('✅ 휴가 신청이 성공적으로 접수되었습니다. 창을 닫습니다.');
			                
			                // ⭐⭐⭐ 요청하신 기능: 성공 시 현재 창을 닫습니다. ⭐⭐⭐
			                window.close();
			                
			            } else if (response && response.message) {
			                alert('❌ 휴가 신청 실패: ' + response.message);
			            } else {
			                // 응답 메시지가 없더라도 성공으로 간주
			                alert('✅ 휴가 신청이 성공적으로 접수되었습니다. (응답 메시지 없음) 창을 닫습니다.');
			                
			                // ⭐⭐⭐ 요청하신 기능: 성공 시 현재 창을 닫습니다. ⭐⭐⭐
			                window.close(); 
			            }
			        },
			        error: function(xhr, status, error) {
			            console.error('AJAX 오류 발생:', status, error, xhr.responseText);
			            // 서버 오류(5xx), 클라이언트 오류(4xx), 네트워크 오류 등 처리
			            alert('❌ 휴가 신청 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요. \n\n' + error);
			        },
			        complete: function() {
			            // 로딩 스피너 등을 숨기는 코드를 여기에 추가할 수 있습니다.
			            console.log('AJAX 요청 완료.');
			            // 폼 초기화 후 상태 재설정 (반차 상태 해제) - 창이 닫히면 이 코드는 실행되지 않지만, 실패 시를 대비해 유지
			            handleVacationTypeChange(); 
			        }
			    });
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
                
                // ⭐ 입력 필드 요소들
                const $startDateInput = $('#startDate'); 
                const $endDateInput = $('#endDate'); 
                const startDateValue = $startDateInput.val(); 
                
                // 초기화: 모든 필드를 일단 활성화/표시 상태로 시작
                $endDateGroup.show();
                $totalDaysGroup.show();
                $endDateInput.prop('disabled', false).prop('required', true); // 종료일 활성화 및 필수 설정
                $startDateLabel.text('시작일:');
                $proofUploadGroup.hide();


                // 반차(half_am, half_pm)인 경우
                if (selectedType === 'half_am' || selectedType === 'half_pm') {
                    
                    // 1. 종료일 그룹 숨김 및 비활성화
                    $endDateGroup.hide();
                    $endDateInput.prop('disabled', true).prop('required', false);
                    
                    // 2. 신청 일수 그룹은 숨김
                    $totalDaysGroup.hide();
                    
                    // 3. 시작일(신청일)이 있다면, 종료일 값을 시작일과 같은 날짜로 자동 설정 (서버 전송을 위해)
                    if (startDateValue) {
                        $endDateInput.val(startDateValue);
                    } else {
                        $endDateInput.val(''); // 시작일이 없다면 종료일 값도 비움
                    }
                    
                    // 4. 시작일 라벨을 '신청일'로 변경
                    $startDateLabel.text('신청일:');
                    
                    // 5. 반차일 때는 증빙 자료 숨김
                    $proofUploadGroup.hide();
                    
                    // 6. 일수 재계산 (0.5일 고정 반영)
                    calculateDays();

                } else {
                    // 일반 휴가(연차, 병가, 보상 휴가, 기타)인 경우
                    // 종료일 그룹 표시, 활성화, 필수 설정 (초기화 상태 유지)
                    // 신청 일수 그룹 표시 (초기화 상태 유지)
                    $endDateInput.prop('disabled', false).prop('required', true); 
                    
                    // 시작일 라벨을 '시작일'로 복원 (초기화 상태 유지)
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
                    // 서버 전송을 위해 name="totalDays"인 필드에 '0.5' 값을 설정
                    $totalDaysInput.val('0.5 일'); 
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
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
	transition: all 0.2s ease-in-out;
	min-width: 120px;
	border: none;
}

.custom-btn:hover {
	background-color: #d4d4d4;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
	transform: translateY(-1px);
}

/* 폼 컨테이너 스타일: 첫 번째 폼과 동일하게 중앙 배치 및 크기 지정 */
.form-container {
	max-width: 500px;
	margin: 40px auto;
	padding: 30px;
	background-color: white;
	border-radius: 12px;
	box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
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
		<h2 class="text-2xl font-bold text-gray-800 text-center mb-8 pb-2">휴가
			신청</h2>

		<form id="vacationForm" action="../approve/approve-form" method="POST"
			class="space-y-6" enctype="multipart/form-data">

			<input type="hidden" name="DocType" id="documentTypeInput" value="4">
			<input type="hidden" name="DocTitle" value="휴가 신청"> <input
				type="hidden" name="step1ManagerNo"
				value="${ loginVO.managerEmpNo }"> <input type="hidden"
				name="step2ManagerNo" value="${ loginVO.parentDeptNo }">

			<fieldset class="p-4 border border-gray-200 rounded-lg">
				<legend class="text-sm font-bold text-blue-600 px-2">신청자 정보
					(자동 입력)</legend>

				<div class="form-group-flex">
					<label for="employeeName"
						class="form-label text-sm font-medium text-gray-600">이름:</label> <input
						type="text" id="employeeName" name="empName"
						value="${sessionScope.login.empName}" readonly
						class="form-input auto-filled-input">
				</div>

				<div class="form-group-flex">
					<label for="employeeId"
						class="form-label text-sm font-medium text-gray-600">사번:</label> <input
						type="text" id="employeeId" name="empNo"
						value="${sessionScope.login.empNo}" readonly
						class="form-input auto-filled-input">
				</div>

				<div class="form-group-flex">
					<label for="department"
						class="form-label text-sm font-medium text-gray-600">부서:</label> <input
						type="text" id="department" name="deptName"
						value="${sessionScope.login.deptName}" readonly
						class="form-input auto-filled-input">
				</div>

			</fieldset>

			<div class="flex justify-end pt-2 mb-4">
				<button type="button" id="viewVacationInfoBtn"
					class="bg-blue-primary text-white text-sm font-medium py-2 px-4 rounded-lg shadow-md hover:bg-blue-700 transition duration-150">
					잔여 휴가 정보 조회</button>
			</div>

			<fieldset class="p-4 border border-gray-200 rounded-lg">
				<legend class="text-sm font-bold text-blue-600 px-2">휴가 정보
					입력</legend>

				<div class="form-group-flex">
					<label for="vacationType" class="form-label">휴가 종류:</label> <select
						id="vacationType" name="attStatus" required
						class="form-input focus:border-blue-500 focus:ring focus:ring-blue-200">
						<option value="" disabled selected>선택하세요</option>
						<option value="annual">연차</option>
						<option value="half_am">반차 (오전)</option>
						<option value="half_pm">반차 (오후)</option>
						<option value="sick">병가</option>
						<option value="compensatory">보상 휴가</option>						
					</select>
				</div>

				<div class="form-group-flex">
					<label for="startDate" id="startDateLabel" class="form-label">시작일:</label>
					<input type="date" id="startDate" name="startDate" required
						class="form-input focus:border-blue-500 focus:ring focus:ring-blue-200">
				</div>

				<div class="form-group-flex" id="endDateGroup">
					<label for="endDate" class="form-label">종료일:</label> <input
						type="date" id="endDate" name="endDate" required
						class="form-input focus:border-blue-500 focus:ring focus:ring-blue-200">
				</div>

				<div class="form-group-flex" id="totalDaysGroup">
					<label for="totalDays" class="form-label">신청 일수:</label> <input
						type="text" id="totalDays" name="totalDays" value="0 일" readonly
						class="form-input auto-filled-input">
				</div>

				<div class="flex flex-col mb-4">
					<label for="reason"
						class="text-sm font-semibold text-gray-700 mb-2">휴가 사유:</label>
					<textarea id="reason" name="docContent" rows="6"
						placeholder="휴가 사유를 상세히 입력해 주세요." required
						class="w-full p-2 border border-gray-300 rounded-md resize-none focus:border-blue-500 focus:ring focus:ring-blue-200"></textarea>
				</div>

				<div class="form-group-flex">
					<label for="emergencyContact" class="form-label">비상 연락처:</label> <input
						type="tel" id="emergencyContact" name="emergencyContact"
						placeholder="010-XXXX-XXXX"
						class="form-input focus:border-blue-500 focus:ring focus:ring-blue-200">
				</div>

				<div class="form-group-flex" id="proofUploadGroup"
					style="display: none;">
					<label for="proofFile" class="form-label">증빙 자료 제출:</label> <input
						type="file" id="proofFile" name="proofFile"
						accept=".pdf, .jpg, .png"
						class="flex-1 p-2 border border-gray-300 rounded-md focus:border-blue-500 focus:ring focus:ring-blue-200">
				</div>

			</fieldset>

			<div class="flex justify-center pt-4 space-x-4">
				<button type="submit"
					class="custom-btn bg-gray-light text-gray-800 hover:bg-primary hover:text-white">신청</button>
				<button type="button" id="cancelBtn"
					class="custom-btn bg-gray-light text-gray-800">취소</button>
			</div>
		</form>
	</div>

	<div id="vacationModal"
		class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden p-4">
		<div
			class="bg-white p-6 rounded-xl shadow-2xl w-full max-w-sm transform transition-all duration-300 scale-100 opacity-100">
			<div class="flex justify-between items-center border-b pb-3 mb-4">
				<h3 class="text-xl font-bold text-gray-800">잔여 휴가 정보</h3>
				<button id="closeModalBtn"
					class="text-gray-500 hover:text-gray-800 text-3xl leading-none">&times;</button>
			</div>

			<div id="vacationInfoDisplay" class="space-y-4 text-base">
				</div>

			<div class="mt-8 flex justify-center">
				<button type="button" id="okModalBtn"
					class="bg-primary text-white font-semibold py-2 px-6 rounded-lg hover:bg-orange-600 transition duration-150 shadow-md">
					확인</button>
			</div>
		</div>
	</div>

</body>
</html>