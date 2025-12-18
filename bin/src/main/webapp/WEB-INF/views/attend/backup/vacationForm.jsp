<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    // Tailwind Config
    tailwind.config = {
        theme: {
            extend: {
                fontFamily: {
                    sans: ['Inter', 'Noto Sans KR', 'sans-serif'],
                },
                colors: {
                    primary: '#f69022', // 주황색
                    'gray-light': '#e5e5e5', 
                    'blue-primary': '#1d4ed8', // 강조색
                }
            }
        }
    }

    jQuery(document).ready(function($) {
        
        // =============================================================
        //                 1. 휴가 정보 조회 (내부 모달) 로직
        // =============================================================
        const remainingVacationData = [
            { name: "유급휴가", remaining: 4, total: 15 },
            { name: "포상휴가", remaining: 7, total: 7 },
            { name: "병가", remaining: "N/A", total: "N/A" }
        ];

        const $modal = $('#vacationModalInternal'); // ID 충돌 방지를 위해 이름 변경 권장 (여기서는 그대로 유지하되 로직 분리)
        const $viewButton = $('#viewVacationInfoBtn');
        const $closeButton = $('#closeModalBtn');
        const $okButton = $('#okModalBtn');
        const $infoDisplay = $('#vacationInfoDisplay');

        // 잔여 휴가 정보 HTML 생성
        function displayVacationInfo() {
            let htmlContent = '';
            remainingVacationData.forEach(item => {
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

        function showModal() {
            displayVacationInfo();
            $('#vacationInfoModal').removeClass('hidden').addClass('flex');
        }

        function closeModal() {
            $('#vacationInfoModal').removeClass('flex').addClass('hidden');
        }

        $viewButton.on('click', showModal);
        $closeButton.on('click', closeModal);
        $okButton.on('click', closeModal);

        $('#vacationInfoModal').on('click', function(e) {
            if (e.target === this) closeModal();
        });


        // =============================================================
        //                 2. 휴가 신청 폼 제출 (AJAX)
        // =============================================================
        $('#vacationForm').on('submit', function(e) {
            e.preventDefault();
            
            const $form = $(this);
            const actionUrl = $form.attr('action');
            const formData = new FormData(this);
            
            // 유효성 검사
            if ($('#vacationType').val() === "") {
                alert("휴가 종류를 선택해 주세요.");
                return; 
            }

            // '일' 텍스트 제거 후 숫자만 전송
            const totalDaysVal = $('#totalDays').val().replace(' 일', '').trim();
            formData.set('totalDays', totalDaysVal);
            
            console.log('휴가 신청 AJAX 제출 시작...');
        
            $.ajax({
                url: actionUrl,
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                
                success: function(response) {
                    console.log('AJAX 성공 응답:', response);
                    
                    if (response && response.success) {
                        alert('✅ 휴가 신청이 성공적으로 접수되었습니다.');
                        
                        // [핵심] attend.jsp에 정의된 닫기 함수 호출
                        if (typeof window.closeVacationModal === 'function') {
                            window.closeVacationModal();
                        } else {
                            // 함수가 없을 경우 fallback
                            $('#vacationModal', parent.document).hide();
                        }

                    } else if (response && response.message) {
                        alert('❌ 휴가 신청 실패: ' + response.message);
                    } else {
                        alert('✅ 휴가 신청이 접수되었습니다. (메시지 없음)');
                        if (typeof window.closeVacationModal === 'function') {
                            window.closeVacationModal();
                        }
                    }
                },
                error: function(xhr, status, error) {
                    console.error('AJAX 오류:', status, error);
                    alert('❌ 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.\n' + error);
                },
                complete: function() {
                    console.log('AJAX 요청 완료.');
                }
            });
        });

        // =============================================================
        //                 3. 폼 상태 제어 (반차/연차 등)
        // =============================================================
        
        // 초기 로드 시 실행
        handleVacationTypeChange();

        // 이벤트 리스너 등록
        $('#startDate, #endDate').on('change', calculateDays);
        $('#vacationType').on('change', handleVacationTypeChange);

        function handleVacationTypeChange() {
            const selectedType = $('#vacationType').val();
            const $docTitle = $('#docTitle');
            const selectedText = $('#vacationType option:selected').text();

            // 제목 자동 설정
            if (selectedType) {
                $docTitle.val(`[휴가신청] ${selectedText} 신청`);
            } else {
                $docTitle.val('[휴가신청]');
            }
        
            const $endDateGroup = $('#endDateGroup');
            const $totalDaysGroup = $('#totalDaysGroup');
            const $startDateLabel = $('#startDateLabel');
            const $proofUploadGroup = $('#proofUploadGroup');
            
            const $startDateInput = $('#startDate'); 
            const $endDateInput = $('#endDate'); 
            const startDateValue = $startDateInput.val(); 
            
            // 초기화: 모든 필드 표시
            $endDateGroup.show();
            $totalDaysGroup.show();
            $endDateInput.prop('disabled', false).prop('required', true);
            $startDateLabel.text('시작일:');
            $proofUploadGroup.hide();

            // 반차 로직
            if (selectedType === 'half_am' || selectedType === 'half_pm') {
                $endDateGroup.hide();
                $endDateInput.prop('disabled', true).prop('required', false);
                $totalDaysGroup.hide();
                
                if (startDateValue) {
                    $endDateInput.val(startDateValue);
                } else {
                    $endDateInput.val('');
                }
                
                $startDateLabel.text('신청일:');
                calculateDays();

            } else {
                // 일반 휴가 로직
                calculateDays();
                if (selectedType === 'sick') {
                    $proofUploadGroup.show();
                }
            }
        }

        function calculateDays() {
            const startValue = $('#startDate').val();
            const endValue = $('#endDate').val();
            const $totalDaysInput = $('#totalDays');
            const selectedType = $('#vacationType').val();

            // 반차는 0.5일 고정
            if (selectedType === 'half_am' || selectedType === 'half_pm') {
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
                alert('시작일은 종료일보다 늦을 수 없습니다.');
                $totalDaysInput.val('0 일');
                $('#endDate').val(startValue); 
                return;
            }

            const timeDifference = endDate.getTime() - startDate.getTime();
            const days = Math.round(timeDifference / (1000 * 3600 * 24)) + 1; 

            $totalDaysInput.val(days + ' 일');
        }
    });
</script>
<style>
    /* 공통 스타일 */
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
    .form-container {
        max-width: 500px;
        margin: 40px auto;
        padding: 30px;
        background-color: white;
        border-radius: 12px;
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
    }
    textarea { resize: none; }
    .form-group-flex {
        display: flex;
        align-items: center;
        margin-bottom: 1rem;
    }
    .form-label {
        width: 140px;
        font-size: 0.875rem;
        font-weight: 600;
        color: #4b5563;
        flex-shrink: 0;
    }
    .form-input {
        flex-grow: 1;
        padding: 0.5rem;
        border: 1px solid #d1d5db;
        border-radius: 0.375rem;
    }
    .auto-filled-input {
        background-color: #f9fafb;
        color: #4b5563;
    }
</style>
</head>
<body class="bg-gray-100 min-h-screen">

    <div class="form-container">
        <h2 class="text-2xl font-bold text-gray-800 text-center mb-8 pb-2">휴가 신청</h2>

       <form id="vacationForm" action="${pageContext.request.contextPath}/approve/approve-ajax" method="POST" class="space-y-6" enctype="multipart/form-data">

            <input type="hidden" name="DocType" id="documentTypeInput" value="4"> 
            <input type="hidden" name="DocTitle" id="docTitle" value="[휴가신청]"> 
            <input type="hidden" name="step1ManagerNo" value="${sessionScope.login.managerEmpNo }"> 
            <input type="hidden" name="step2ManagerNo" value="${sessionScope.login.parentDeptNo }">

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

            <div class="flex justify-end pt-2 mb-4">
                <button type="button" id="viewVacationInfoBtn" class="bg-blue-primary text-white text-sm font-medium py-2 px-4 rounded-lg shadow-md hover:bg-blue-700 transition duration-150">
                    잔여 휴가 정보 조회
                </button>
            </div>

            <fieldset class="p-4 border border-gray-200 rounded-lg">
                <legend class="text-sm font-bold text-blue-600 px-2">휴가 정보 입력</legend>

                <div class="form-group-flex">
                    <label for="vacationType" class="form-label">휴가 종류:</label> 
                    <select id="vacationType" name="attStatus" required class="form-input focus:border-blue-500 focus:ring focus:ring-blue-200">
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
                    <input type="date" id="startDate" name="startDate" required class="form-input focus:border-blue-500 focus:ring focus:ring-blue-200">
                </div>

                <div class="form-group-flex" id="endDateGroup">
                    <label for="endDate" class="form-label">종료일:</label> 
                    <input type="date" id="endDate" name="endDate" required class="form-input focus:border-blue-500 focus:ring focus:ring-blue-200">
                </div>

                <div class="form-group-flex" id="totalDaysGroup">
                    <label for="totalDays" class="form-label">신청 일수:</label> 
                    <input type="text" id="totalDays" name="totalDays" value="0 일" readonly class="form-input auto-filled-input">
                </div>

                <div class="flex flex-col mb-4">
                    <label for="reason" class="text-sm font-semibold text-gray-700 mb-2">휴가 사유:</label>
                    <textarea id="reason" name="docContent" rows="6" placeholder="휴가 사유를 상세히 입력해 주세요." required class="w-full p-2 border border-gray-300 rounded-md resize-none focus:border-blue-500 focus:ring focus:ring-blue-200"></textarea>
                </div>

                <div class="form-group-flex">
                    <label for="emergencyContact" class="form-label">비상 연락처:</label> 
                    <input type="tel" id="emergencyContact" name="emergencyContact" placeholder="010-XXXX-XXXX" class="form-input focus:border-blue-500 focus:ring focus:ring-blue-200">
                </div>

                <div class="form-group-flex" id="proofUploadGroup" style="display: none;">
                    <label for="proofFile" class="form-label">증빙 자료 제출:</label> 
                    <input type="file" id="proofFile" name="proofFile" accept=".pdf, .jpg, .png" class="flex-1 p-2 border border-gray-300 rounded-md focus:border-blue-500 focus:ring focus:ring-blue-200">
                </div>

            </fieldset>

            <div class="flex justify-center pt-4 space-x-4">
                <button type="submit" class="custom-btn bg-gray-light text-gray-800 hover:bg-primary hover:text-white">신청</button>
                <button type="button" id="cancelBtn" class="custom-btn bg-gray-light text-gray-800">취소</button>
            </div>
        </form>
    </div>

    <div id="vacationInfoModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden p-4">
        <div class="bg-white p-6 rounded-xl shadow-2xl w-full max-w-sm transform transition-all duration-300 scale-100 opacity-100">
            <div class="flex justify-between items-center border-b pb-3 mb-4">
                <h3 class="text-xl font-bold text-gray-800">잔여 휴가 정보</h3>
                <button id="closeModalBtn" class="text-gray-500 hover:text-gray-800 text-3xl leading-none">&times;</button>
            </div>

            <div id="vacationInfoDisplay" class="space-y-4 text-base"></div>

            <div class="mt-8 flex justify-center">
                <button type="button" id="okModalBtn" class="bg-primary text-white font-semibold py-2 px-6 rounded-lg hover:bg-orange-600 transition duration-150 shadow-md">확인</button>
            </div>
        </div>
    </div>

</body>
</html>