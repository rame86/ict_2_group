// ==========================================
// [수정완성본] 알림 및 소켓 연결 JS
// ==========================================

// 1. 알람 권한 요청
function requestNotificationPermission() {
	if (!('Notification' in window)) {
		return;
	}

	if (Notification.permission !== 'granted' && Notification.permission !== 'denied') {
		Notification.requestPermission().then(permission => {
			if (permission === 'granted') {
				console.log('✅ 알림 권한 승인됨');
			}
		});
	}
}

// 전역 변수
let stompClient = null;

// 2. 소켓 연결 함수 (핵심 수정: 진입 시점 방어 로직 추가)
function connectSocket() {

    // [중요] 함수 시작하자마자 값 확인. 없으면 즉시 종료.
    // SockJS 객체를 생성하기 전에 막아야 서버로 요청이 안 날아갑니다.
    const checkEmpNo = $('#sessionEmpNo').val();
    if (!checkEmpNo || checkEmpNo.trim() === "" || checkEmpNo === "null") {
        console.log("⛔ [connectSocket] 로그인 정보 없음. 소켓 연결을 중단합니다.");
        return; 
    }

    // --- 로그인 정보가 있을 때만 아래 로직 실행 ---

	const socket = new SockJS('/ws/stomp');
	stompClient = Stomp.over(socket);
    
    // 디버그 로그 끄기 (선택사항: 콘솔 지저분하면 주석 해제)
    // stompClient.debug = null; 

	stompClient.connect({}, function(frame) {

		console.log('STOMP: 연결 성공!');
		const myEmpNo = $('#sessionEmpNo').val();

		// 1-1. 대화 목록 로드
		loadConversationList(myEmpNo);

		// 1-2. 채팅방 자동 로드 (파라미터 체크)
		const urlParams = new URLSearchParams(window.location.search);
		const initialEmpNo = urlParams.get('otherEmpNo');
		const initialEmpNameParam = urlParams.get('otherEmpName');

		if (initialEmpNo && typeof loadChatWindow === 'function') {
			const initialEmpName = initialEmpNameParam ? decodeURIComponent(initialEmpNameParam) : '이름 없음';
			loadChatWindow(initialEmpNo, initialEmpName);
		}

		// 2-1. 개인 알림 구독
		const personalTopic = '/topic/notifications/' + myEmpNo;
		stompClient.subscribe(personalTopic, function(notificationOutput) {
			console.log("STOMP: 개인 알림 도착");

			if ('Notification' in window && Notification.permission === 'granted') {
				try {
					const notificationData = JSON.parse(notificationOutput.body);
					const senderName = notificationData.senderName || '알 수 없는 발신자';
					const messageContent = notificationData.msgContent || '메시지 내용을 확인해주세요.';

					new Notification(senderName + '님의 쪽지', {
						body: messageContent,
						icon: '/img/profile_placeholder.png'
					});
				} catch (e) {
					console.error("파싱 오류:", e);
				}
			}
			loadConversationList(myEmpNo);
		});

		// 2-2. 전체(결재) 알림 구독
		const globalTopic = '/topic/global-notifications';
		stompClient.subscribe(globalTopic, function(notification) {
			try {
				const data = JSON.parse(notification.body);
				if (data.targetEmpNo === myEmpNo) {

					const message = data.content;
					let targetUrl = "/approve/finishList"; // 기본값

					if (message.includes("새로운 결재")) {
						targetUrl = "/approve/receiveList";
					}

					// 토스터 알림
					toastr.success(message, '결재 알림', {
						timeOut: 5000,
						positionClass: 'toast-bottom-right',
						onclick: function() {
							if (targetUrl) window.location.href = targetUrl;
						}
					});

					// 뱃지 업데이트
					if (typeof updateSidebarBadge === 'function') {
                        updateSidebarBadge();
                    }
				}
			} catch (e) {
				console.error("결재 알림 오류:", e);
			}
		});

	}, function(error) {
		console.error('STOMP: 연결 끊김/오류:', error);
        // [중요] 에러 발생 시 리다이렉트 금지.
		if (stompClient) {
			try { stompClient.disconnect(); } catch (e) {}
		}
		stompClient = null;
	});
}

// 3. 페이지 로드 시 실행
$(document).ready(function() {

	const currentEmpNo = $('#sessionEmpNo').val();

	// [중요] 페이지 로드 시점 1차 방어
    // 값이 없으면 아예 리턴시켜서 아무것도 실행하지 않음
	if (!currentEmpNo || currentEmpNo.trim() === "" || currentEmpNo === "null") {
		console.log("❌ [Ready] 비로그인 상태. 스크립트 실행 중단.");
		return; 
	}

	// --- 아래는 로그인 된 경우에만 실행됨 ---
	console.log("✅ [Ready] 로그인 확인됨: " + currentEmpNo);

	requestNotificationPermission();

	if (stompClient === null) {
		connectSocket();
	}

	if (typeof updateHeaderAlertsBadge === 'function') {
        updateHeaderAlertsBadge();
    }

    // 드롭다운 이벤트 리스너
	$(document).on('shown.bs.dropdown', '#messagesDropdown', function() {
		loadLatestMessages();
	});

	$(document).on('shown.bs.dropdown', '#alertsDropdown', function() {
		loadLatestAlerts();
		markAllAlertsAsReadAPI();
	});
});

// 4. API 관련 함수들
function markAllAlertsAsReadAPI() {
	$.ajax({
		url: '/alert/markAllAsRead',
		type: 'POST',
		success: function() {
			$('#alertBadge').text('').hide();
		},
		error: function(e) { console.error(e); }
	});
}

function loadConversationList(empNo) {
	$.ajax({
		url: '/api/message/conversationList',
		type: 'get',
		dataType: 'json',
		success: function(response) {
			let totalUnreadCount = 0;
			if (response && response.length > 0) {
				response.forEach(conv => totalUnreadCount += (conv.unreadCount || 0));
			}

			const badgeElement = $('#messageBadge');
			badgeElement.text(totalUnreadCount > 99 ? '99+' : totalUnreadCount);
			
            if (totalUnreadCount > 0) badgeElement.show();
            else badgeElement.hide();

			if (typeof renderConversationList === 'function') {
				renderConversationList(response);
			}
		},
		error: function(e) { console.error("대화목록 로드 실패", e); }
	});
}

function createMessageItemHtml(msg) {
	let formattedTime = '';
	if (msg.sendDate) {
		try {
			formattedTime = new Date(msg.sendDate).toLocaleTimeString('ko-KR', { hour: 'numeric', minute: '2-digit' });
		} catch (e) {}
	}

	return `<a class="list-group-item list-group-item-action d-flex align-items-start py-3" 
            href="/message/messageList?otherEmpNo=${msg.senderEmpNo}&otherEmpName=${encodeURIComponent(msg.senderName)}">
            <div class="me-3" style="width: 40px; height: 40px;">
                <img class="rounded-circle w-100 h-100" src="/img/profile_placeholder.png" alt="프로필">
            </div>
            <div class="w-100">
                <div class="small text-gray-500 mb-1">${msg.senderName || '알 수 없음'} · ${formattedTime}</div>
                <div class="fw-bold text-truncate" style="max-width: 250px;">${msg.msgContent || '내용 없음'}</div>
            </div>
        </a>`;
}

function loadLatestMessages() {
	const myEmpNo = $('#sessionEmpNo').val();
	if (!myEmpNo) return;

	const container = $('#latestMessagesContainer');
	container.html('<a class="list-group-item text-center small text-gray-500 py-2">로딩 중...</a>');

	$.ajax({
		url: '/api/message/latestUnread',
		type: 'GET',
		dataType: 'json',
		success: function(messages) {
			container.empty();
			if (messages && messages.length > 0) {
				messages.forEach(msg => container.append(createMessageItemHtml(msg)));
			} else {
				container.html('<a class="list-group-item text-center small text-gray-500 py-2">새로운 쪽지가 없습니다.</a>');
			}
		},
		error: function() {
            container.html('<a class="list-group-item text-center small text-danger py-2">로드 실패</a>');
        }
	});
}

function loadLatestAlerts() {
	const container = $('#latestAlertsContainer');
	container.html('<a class="list-group-item text-center small text-gray-500 py-2">로딩 중...</a>');

	$.ajax({
		url: '/alert/latestView',
		type: 'GET',
		dataType: 'json',
		success: function(alerts) {
			container.empty();
			if (alerts && alerts.length > 0) {
				alerts.slice(0, 5).forEach(alert => container.append(createAlertItemHtml(alert)));
			} else {
				container.append('<a class="list-group-item text-center small text-gray-500 py-2">알림 없음</a>');
			}
		},
		error: function() {
            container.empty();
            container.append('<a class="list-group-item text-center small text-danger py-2">로드 실패</a>');
        }
	});
}