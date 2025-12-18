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
    const details = getAlertDetails(alert.type); 
    
    // 시간 포맷팅
    let formattedTime = '방금 전';
    if (alert.sentTime) {
        try {
            const date = new Date(alert.sentTime);
            formattedTime = date.toLocaleTimeString('ko-KR', { hour: 'numeric', minute: '2-digit' }); 
        } catch (e) { formattedTime = alert.sentTime; }
    }
	
    let targetAction = '';
    let targetUrl = 'javascript:void(0);'; // 기본 클릭 동작 차단

    if (alert.linkType && alert.linkId) {
        switch (alert.linkType) {
            case 'APPROVAL':
                // ⭐ [핵심 수정] 결재 알림 클릭 시 동작 정의
                // 1. 문서 번호와 상태 확인
                const docNo = alert.linkId;
                const status = alert.alertStatus; // DTO에 alertStatus가 포함되어 있어야 함
                const contextPath = typeof CONTEXT_PATH !== 'undefined' ? CONTEXT_PATH : '';

                // 2. 상태에 따른 이동 로직 분기 (messageList.jsp와 유사하게 맞춤)
                if (status === 'REQUEST') {
                    // [결재 요청] -> 결재 대기 문서함으로 이동 (가장 안전)
                    // 또는 팝업을 띄우고 싶다면 아래 else if처럼 window.open 사용 가능
                    targetUrl = '/approve/receiveList';
                } else if (['FINAL_APPROVAL', 'REJECT', 'IN_PROGRESS'].includes(status)) {
                    // [결재 완료/진행] -> 상세 팝업 띄우기 (오류 없이 문서 확인 가능)
                    targetAction = `onclick="window.open('${contextPath}/approve/documentDetailPopup?docNo=${docNo}', 'detailPopup', 'width=800,height=900,scrollbars=yes'); return false;"`;
                } else {
                    // [기타] -> 팝업으로 기본 연결
                    targetAction = `onclick="window.open('${contextPath}/approve/documentDetailPopup?docNo=${docNo}', 'detailPopup', 'width=800,height=900,scrollbars=yes'); return false;"`;
                }
                break;
                
            case 'BOARD':
                // 공지사항: 리스트 이동 + 모달 자동 띄우기
                targetUrl = '/board/getNoticeBoardList?noticeNo=' + alert.linkId;
                break;
            
            case 'MESSAGE':
                // 쪽지
                targetUrl = '/message/messageList?otherEmpNo=' + alert.linkId;
                break;
                
            default:
                targetUrl = details.link || '#';
                break;
        }
    }

    // onclick 액션이 따로 지정되지 않았다면 href 이동 처리
    if (!targetAction) {
        targetAction = `href="${targetUrl}"`;
    } else {
        targetAction += ` href="#"`; // 팝업인 경우 href는 무시
    }

    // HTML 생성 (백틱 방식이 아닌 + 연결 방식 유지 요청 반영)
    let html = '<a class="list-group-item list-group-item-action" ' + targetAction + '>';
    html += '<div class="d-flex align-items-center">';
    html += '<div class="me-3" style="width: 40px; height: 40px;">';
    html += '<div class="icon-circle bg-light p-2 rounded-circle ' + details.iconClass + '">';
    html += '<i class="' + details.icon + '"></i>';
    html += '</div>';
    html += '</div>';
    html += '<div class="w-100">';
    html += '<div class="small text-gray-500 mb-1">' + (alert.senderName || '시스템') + ' · ' + formattedTime + '</div>';
    html += '<span class="fw-bold text-truncate" style="max-width: 250px; display: block;">';
    html += (alert.title || '알림');
    html += '</span>';
    html += '</div>';
    html += '</div>';
    html += '</a>';
    
    return html;
}

function updateHeaderAlerts() {
    
	console.log("ALERT: updateHeaderAlerts 함수 실행 시작!");
    // 1. 읽지 않은 알림 개수(뱃지 숫자) 갱신
    $.ajax({
        // 서버의 알림 개수 조회 API 엔드포인트 (AlertController에 정의되어 있음)
        url: '/alert/unreadCount', 
        type: 'GET',
        success: function(count) {
            // ★★★ HTML의 알림 숫자 뱃지를 감싸는 엘리먼트의 ID로 변경해야 합니다. ★★★
            const $badge = $('#alertBadge'); 
            
            // 텍스트 업데이트
            $badge.text(count);
            
            // 0개 이상일 때만 표시
            if (count > 0) {
                $badge.show();
            } else {
                $badge.hide();
            }
        },
        error: function(xhr, status, error) {
            console.error("Unread Alert Count 조회 실패:", error);
        }
    });

    // 2. 알림 드롭다운 목록 갱신
    $.ajax({
        // 서버의 알림 목록 조회 API 엔드포인트 (AlertController에 정의되어 있음)
        url: '/alert/latestView', 
        type: 'GET',
        success: function(alerts) {
            const $dropdownList = $('#headerAlertDropdownList');
            $dropdownList.empty();
            
            if (alerts.length === 0) {
                 $dropdownList.append('<a href="#" class="list-group-item list-group-item-action">새 알림이 없습니다.</a>');
                 return;
            }
            
            // 알림 목록을 순회하며 HTML을 동적으로 생성하여 추가
			alerts.forEach(function(alert) {
				const alertHtml = createAlertItemHtml(alert);
				$dropdownList.append(alertHtml);
			});
        },
        error: function(xhr, status, error) {
             console.error("Latest Alert View 조회 실패:", error);
        }
    });
}

