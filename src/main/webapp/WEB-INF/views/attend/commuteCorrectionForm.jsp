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
        // jQuery로 폼 제출 로직 구현
        $(function() {
            const $form = $('#correctionForm');
            const $newTimeInput = $('#newTime');
            const $existingTimeInput = $('#existingTime');

            // 폼 제출 이벤트 핸들러
            $form.on('submit', function(e) {
                e.preventDefault();
                console.log('출퇴근 정정 신청 제출됨!');
                
                // Note: FormData는 순수 JS 객체지만, 폼 요소를 jQuery로 가져와도 사용 가능
                const formData = new FormData(this); 
                
                // 폼 데이터 콘솔 출력 (실제 서버 통신 로직은 여기에 들어갑니다)
                for (let [key, value] of formData.entries()) {
                    console.log(key + ': ' + value);
                }
                
                // 제출 완료 메시지 (실제 앱에서는 커스텀 UI로 대체 권장)
                alert('정정 신청이 성공적으로 접수되었습니다.'); 
                // this.reset(); // 제출 후 폼 초기화
            });

            // 취소 버튼 클릭 시 동작 (예: 이전 페이지로 이동)
            $('#cancelBtn').on('click', function() {
                alert('정정 신청을 취소합니다. (실제로는 이전 페이지로 이동)');
                // window.history.back(); // 실제 환경에서는 이렇게 사용 가능
            });
            
            // (선택 사항) 정정할 시간 포커스 시 기존 시간 더미 데이터 설정
            $newTimeInput.on('focus', function() {
                 // jQuery의 .val()을 사용하여 값 설정
                 // 실제 앱에서는 선택된 날짜와 정정 구분에 따라 기존 시간을 서버에서 조회해야 합니다. 
                 // 24시간제 '09:02'를 설정 (기존과 동일)
                 $existingTimeInput.val('09:02'); 
            });
        });

        // Tailwind Config (이전 파일과 동일하게 설정)
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
    </script>
    <style>
        /* 버튼 스타일: 이전 휴가 폼과 동일한 둥근 모양 및 Tailwind 클래스 사용 */
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
        /* 폼 컨테이너 스타일 (휴가 신청 폼과 유사하게 중앙 배치) */
        .correction-form-container { 
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
    </style>
</head>
<body class="bg-gray-100 min-h-screen">

    <div class="correction-form-container">
        <h2 class="text-2xl font-bold text-gray-800 text-center mb-8 pb-2">출.퇴근 시간 정정 신청</h2>
        
        <form id="correctionForm" class="space-y-6">
            
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

            <fieldset class="p-4 border border-gray-200 rounded-lg">
                <legend class="text-sm font-bold text-blue-600 px-2">정정 정보 입력</legend>
                
                <div class="flex items-center mb-4">
                    <label for="correctionDate" class="w-28 text-sm font-semibold text-gray-700">정정일:</label>
                    <input type="date" id="correctionDate" name="correctionDate" required class="flex-1 p-2 border border-gray-300 rounded-md focus:border-blue-500 focus:ring focus:ring-blue-200">
                </div>
                
                <div class="flex items-center mb-4">
                    <label for="correctionType" class="w-28 text-sm font-semibold text-gray-700">정정 구분:</label>
                    <select id="correctionType" name="correctionType" required class="flex-1 p-2 border border-gray-300 rounded-md focus:border-blue-500 focus:ring focus:ring-blue-200">
                        <option value="" disabled selected>선택하세요</option>
                        <option value="in">출근 시간 정정</option>
                        <option value="out">퇴근 시간 정정</option>
                    </select>
                </div>

                <div class="flex items-center mb-4">
                    <label for="existingTime" class="w-28 text-sm font-semibold text-gray-700">기존 시간:</label>
                    <input type="time" id="existingTime" name="existingTime" placeholder="09:00" readonly class="flex-1 p-2 border rounded-md bg-gray-50 text-gray-600">
                </div>

                <div class="flex items-center mb-4">
                    <label for="newTime" class="w-28 text-sm font-semibold text-gray-700">정정할 시간:</label>
                    <input type="time" id="newTime" name="newTime" required class="flex-1 p-2 border border-gray-300 rounded-md focus:border-blue-500 focus:ring focus:ring-blue-200">
                </div>
                
                <div class="flex flex-col">
                    <label for="correctionReason" class="text-sm font-semibold text-gray-700 mb-2">정정 사유:</label>
                    <textarea id="correctionReason" name="correctionReason" rows="6" placeholder="지각 사유, 시스템 오류 등 정정 사유를 상세히 입력해 주세요." required class="w-full p-2 border border-gray-300 rounded-md resize-none focus:border-blue-500 focus:ring focus:ring-blue-200"></textarea>
                </div>
                
            </fieldset>

            <div class="flex justify-center pt-4 space-x-4">
                <button type="submit" class="custom-btn bg-gray-light text-gray-800 hover:bg-primary hover:text-white">신청</button>
                <button type="button" id="cancelBtn" class="custom-btn bg-gray-light text-gray-800">취소</button>
            </div>
        </form>
    </div>

</body>
</html>