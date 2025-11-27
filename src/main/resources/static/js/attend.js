// /js/attend.js 파일 내용 (jQuery)
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
});