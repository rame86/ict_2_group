function updateSidebarBadge() {
	getApprovalCount(function(waitingCount) {	
		const badgeElement = $("#badgeId");
		if (waitingCount > 0) {
			badgeElement.text(waitingCount);
			badgeElement.show();
			$("#approvalIcon").addClass("icon-notify");
		} else {
			badgeElement.text("");
			badgeElement.hide();
			$("#approvalIcon").removeClass("icon-notify");
		}
	});
}

function getApprovalCount(successCallback) {
    $.ajax({
        url: "/approve/getWaitingCount", 
        type: "GET",
        dataType: "json",
        success: function(response) {
            const waitingCount = response || 0;
            if (typeof successCallback === 'function') {
                successCallback(waitingCount);
            }
        },
        error: function(xhr, status, error) {
            console.error("결재 카운트 로드 실패:", error);
            console.error("오류 상세:", xhr.status, xhr.responseText);
            if (typeof successCallback === 'function') {
                successCallback(0); // 실패 시 0으로 처리
            }
		}
	});
}

function updateHeaderAlertsBadge() {
	$.ajax({
		url: '/alert/unreadCount',
		type: 'GET',
		success: function(totalCount) { // 통합 알림 개수를 받습니다.
			const badgeElement = $('#alertBadge'); // 헤더 뱃지 ID
			badgeElement.text(totalCount > 99 ? '99+' : totalCount);
			if (totalCount > 0) {
				badgeElement.show(); 
			} else {
				badgeElement.hide(); 
			}
			console.log("✅ 헤더 통합 알림 뱃지 업데이트 완료:", totalCount);
		},
		error: function(xhr, status, error) {
			console.error("❌ 헤더 통합 알림 카운트 조회 실패:", status, error);
			$('#alertBadge').hide(); // 에러 시 숨김
		}
	});
}

// 알람유형에 맞는 아이콘
function getAlertDetails(type) {
	switch (type) {
        case '결재':
            // 결재 알림 (문서 아이콘)
            return { 
                icon: 'fas fa-file-signature', // 문서/사인 아이콘
                iconClass: 'text-primary',
                link: '/approve/receiveList' 
            };
        case 'NOTICE':
            // 공지사항 알림 (메가폰 아이콘)
            return { 
                icon: 'fas fa-bullhorn', // 공지/메가폰 아이콘
                iconClass: 'text-info',
                link: '/notice/list' 
            };
        default:
            // 기타 알림
            return { 
                icon: 'fas fa-info-circle',
                iconClass: 'text-secondary',
                link: '#' 
            };
    }
}

// 알림 드롭다운 아래 목록
function createAlertItemHtml(alert) {
    const details = getAlertDetails(alert.type); // 알림 유형에 따른 정보 가져오기
    console.log(alert);
    // 시간 포맷팅 (예: 58m 전, 10:30 AM)
    let formattedTime = '시간 오류';
    if (alert.sentTime) {
        try {
            const date = new Date(alert.sentTime);
            // 한국 시간 기준 포맷팅 (예시)
            formattedTime = date.toLocaleTimeString('ko-KR', { hour: 'numeric', minute: '2-digit' }); 
        } catch (e) {
			formattedTime = alert.sentTime;
		}
    }

	let html = '<a class="list-group-item list-group-item-action" href="' + alert.linkId + '">';
	    html += '<div class="d-flex align-items-center">'; // ⭐ py-2 클래스 유지

	    // 1. 아이콘 영역 (40x40)
	    html += '<div class="me-3" style="width: 40px; height: 40px;">'; // ⭐ width/height 스타일 유지
	    
	    // 아이콘 설정: icon-circle bg-light p-2 rounded-circle text-primary (text-primary 대신 details.iconClass 사용)
	    html += '<div class="icon-circle bg-light p-2 rounded-circle ' + details.iconClass + '">';
	    html += '<i class="' + details.icon + '"></i>'; // ⭐ 아이콘 클래스 사용
	    html += '</div>';
	    
	    html += '</div>';
	    
	    // 2. 내용 영역
	    html += '<div class="w-100">'; // ⭐ w-100 클래스 유지
	    
	    // 시간 및 발신자
	    html += '<div class="small text-gray-500 mb-1">' + (alert.senderName || '시스템') + ' · ' + formattedTime + '</div>'; // ⭐ mb-1 클래스 유지
	    
	    // 제목
	    html += '<span class="fw-bold text-truncate" style="max-width: 250px;">'; // ⭐ fw-bold 및 max-width 스타일 유지
	    html += alert.title;
	    html += '</span>';
	    
	    html += '</div>';
	    html += '</div>';
	    html += '</a>';
	    
	    return html;
}

