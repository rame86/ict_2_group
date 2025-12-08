<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>출퇴근 시간 정정 신청</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script>
    // 폼 요소 변수를 전역/스크립트 스코프에 선언만 해둡니다.
    let $form, $existingTimeInput, $correctionDateInput, $correctionTypeSelect;


    // 기존 시간 업데이트 함수 (수정됨)
    function updateExistingTime() {
        if (typeof appendEvents === 'undefined' || !Array.isArray(appendEvents)) {
            console.error("근무 기록 데이터 (appendEvents)를 찾을 수 없습니다.");
            $existingTimeInput.val('');
            return;
        }
        
        const dateValue = $correctionDateInput.val();
        const typeValue = $correctionTypeSelect.val();

        if (!dateValue || !typeValue) {
            $existingTimeInput.val('');
            return;
        }

        // [attend.jsp의 appendEvents 배열 사용]
        const record = appendEvents.find(r => r.date === dateValue);

        if (!record) {
            $existingTimeInput.val('');
            return;
        }

        let timeToDisplay = '';
        
        // ⭐ 이 부분을 'inTime'과 'outTime'으로 수정합니다.
        if (typeValue === 'inTime') {
            // HH:MM:SS -> HH:MM 변환
            timeToDisplay = record.inTime ? record.inTime.substring(0, 5) : ''; 
        } else if (typeValue === 'outTime') {
            // HH:MM:SS -> HH:MM 변환
            timeToDisplay = record.outTime ? record.outTime.substring(0, 5) : '';
        } else {
            // 선택된 값이 'inTime' 또는 'outTime'이 아닌 경우
            timeToDisplay = '';
        }
        
        $existingTimeInput.val(timeToDisplay);
        
        if (timeToDisplay === '' && typeValue !== '') {
            const typeText = (typeValue === 'inTime' ? '출근' : '퇴근');
            alert(`선택하신 ${typeText} 기록이 존재하지 않습니다. (예: 연차, 결근, 기록 누락)`);
        }
    }
    
    // 폼 초기화 및 이벤트 연결 함수
    function initializeCorrectionForm() {
        // 이 함수가 호출될 때 DOM 요소들을 찾아서 변수에 할당합니다.
        $form = $('#correctionForm');
        $existingTimeInput = $('#existingTime');
        $correctionDateInput = $('#correctionDate');
        $correctionTypeSelect = $('#correctionType');
        
        // 이벤트 핸들러 등록
        $correctionDateInput.on('change', updateExistingTime);
        $correctionTypeSelect.on('change', updateExistingTime);
        
        // 폼 제출 이벤트 (AJAX 사용)
        $('#correctionForm').on('submit', function(e) {
			    e.preventDefault(); 
			    
			    const $form = $(this);
			    const actionUrl = $form.attr('action');
			    
			    const formData = new FormData(this);
			    
			    // 폼 유효성 검사 (필요에 따라 추가)
			 
			    
			    console.log('출퇴근 정정 신청 AJAX 제출 시작...');
			
			    $.ajax({
			        url: actionUrl,
			        type: 'POST',
			        data: formData,
			        processData: false, 
			        contentType: false, 
			        
			        success: function(response) {
			            console.log('AJAX 성공 응답:', response);
			            
			            if (response && response.success) { 
			                alert('✅ 출퇴근 정정 신청이 성공적으로 접수되었습니다.');
			                $form[0].reset(); 
			            } else if (response && response.message) {
			                alert('❌ 출퇴근 정정 신청 실패: ' + response.message);
			            } else {
			                alert('✅ 출퇴근 정정 신청이 성공적으로 접수되었습니다. (응답 메시지 없음)');
			                $form[0].reset();
			            }
			        },
			        error: function(xhr, status, error) {
			            console.error('AJAX 오류 발생:', status, error, xhr.responseText);
			            alert('❌ 출퇴근 정정 신청 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요. \n\n' + error);
			        },
			        complete: function() {
			            console.log('AJAX 요청 완료.');
			        }
			    });
			});

        // 취소 버튼 이벤트
        $('#cancelBtn').on('click', function() {
            alert('정정 신청을 취소합니다. (실제로는 이전 페이지로 이동)');
        });
    }

    // DOMContentLoaded 완료 후 실행 (jQuery 단축 문법)
    $(function() {
        // appendEvents 데이터 로드 대기 로직
        if (typeof appendEvents === 'undefined') {
             setTimeout(function() {
                 if (typeof appendEvents !== 'undefined') {
                     initializeCorrectionForm();
                 } else {
                     console.error("재시도 후에도 appendEvents를 찾을 수 없어 폼 로직을 초기화할 수 없습니다.");
                 }
             }, 50); 
        } else {
            // 이미 정의되었다면 즉시 초기화
            initializeCorrectionForm();
        }

        // Tailwind Config (기존 로직 유지)
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'Noto Sans KR', 'sans-serif'],
                    },
                    colors: {
                        primary: '#f69022', 
                        'gray-light': '#e5e5e5', 
                    }
                }
            }
        }
    });
</script>
<style>
/* CSS 부분은 변경 없음 */
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

.correction-form-container {
	max-width: 500px;
	margin: 40px auto;
	padding: 30px;
	background-color: white;
	border-radius: 12px;
	box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
}

textarea {
	resize: none;
}
</style>
</head>
<body class="bg-gray-100 min-h-screen">

	<div class="correction-form-container">
		<h2 class="text-2xl font-bold text-gray-800 text-center mb-8 pb-2">출.퇴근
			시간 정정 신청</h2>

		<form id="correctionForm" action="../approve/approve-form"
			method="POST" class="space-y-6">

			<input type="hidden" name="DocType" id="documentTypeInput" value="5">
			<input type="hidden" name="DocTitle" value="출퇴근 정정 신청"> <input
				type="hidden" name="step1ManagerNo"
				value="${ loginVO.managerEmpNo }"> <input type="hidden"
				name="step2ManagerNo" value="${ loginVO.parentDeptNo }">

			<!-- 1. 신청자 정보 (자동 입력) -->
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

			<fieldset class="p-4 border border-gray-200 rounded-lg">
				<legend class="text-sm font-bold text-blue-600 px-2">정정 정보
					입력</legend>

				<div class="flex items-center mb-4">
					<label for="correctionDate"
						class="w-28 text-sm font-semibold text-gray-700">정정일:</label> <input
						type="date" id="correctionDate" name="startDate" required
						class="flex-1 p-2 border border-gray-300 rounded-md focus:border-blue-500 focus:ring focus:ring-blue-200">
				</div>

				<div class="flex items-center mb-4">
					<label for="correctionType"
						class="w-28 text-sm font-semibold text-gray-700">정정 구분:</label> <select
						id="correctionType" name="memo" required
						class="flex-1 p-2 border border-gray-300 rounded-md focus:border-blue-500 focus:ring focus:ring-blue-200">
						<option value="" disabled selected>선택하세요</option>
						<option value="inTime">출근 시간 정정</option>
						<option value="outTime">퇴근 시간 정정</option>
					</select>
				</div>

				<div class="flex items-center mb-4">
					<label for="existingTime"
						class="w-28 text-sm font-semibold text-gray-700">기존 시간:</label> <input
						type="time" id="existingTime" name="existingTime"
						placeholder="09:00" readonly
						class="flex-1 p-2 border rounded-md bg-gray-50 text-gray-600">
				</div>

				<div class="flex items-center mb-4">
					<label for="modifyTime"
						class="w-28 text-sm font-semibold text-gray-700">정정할 시간:</label> <input
						type="time" id="newTime" name="newmodifyTime" required
						class="flex-1 p-2 border border-gray-300 rounded-md focus:border-blue-500 focus:ring focus:ring-blue-200">
				</div>

				<div class="flex flex-col">
					<label for="correctionReason"
						class="text-sm font-semibold text-gray-700 mb-2">정정 사유:</label>
					<textarea id="correctionReason" name="docContent" rows="6"
						placeholder="지각 사유, 시스템 오류 등 정정 사유를 상세히 입력해 주세요." required
						class="w-full p-2 border border-gray-300 rounded-md resize-none focus:border-blue-500 focus:ring focus:ring-blue-200"></textarea>
				</div>
				<!-- 비상 연락처 -->
				<div class="form-group-flex">
					<label for="emergencyContact" class="form-label">비상 연락처:</label> <input
						type="tel" id="emergencyContact" name="emergencyContact"
						placeholder="010-XXXX-XXXX"
						class="form-input focus:border-blue-500 focus:ring focus:ring-blue-200">
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

</body>
</html>