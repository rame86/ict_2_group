// 🚨 변수 정의 (STOMP 연결에 필수)
stompClient = null;

function connectSocket() {
    const socket = new SockJS('/ws/stomp'); 
    stompClient = Stomp.over(socket);
    
    stompClient.connect({}, function(frame) {
        console.log('STOMP: 연결 성공! (Header)');
        const myEmpNo = $('#sessionEmpNo').val();
        const personalTopic = '/topic/notifications/' + myEmpNo;
        
        // 개인 알림 채널 구독: 새 메시지 오면 목록/뱃지 갱신
        stompClient.subscribe(personalTopic, function(notificationOutput) {
            console.log("STOMP: [채팅] 개인 알림 도착. 목록 갱신 시작.");
            loadConversationList(myEmpNo); 
        });
        
        loadConversationList(myEmpNo); // 초기 로드
        
    }, function(error) {
        console.error('STOMP: 연결 실패 또는 오류:', error);
    });
}

$(document).ready(function(){
    const currentEmpNo = $('#sessionEmpNo').val();
    if (currentEmpNo) {
        connectSocket();
    }
	
	$(document).on('shown.bs.dropdown', '#messagesDropdown', function () {
		console.log("✅ 드롭다운 이벤트 발생! loadLatestMessages() 호출 시도.");
	    loadLatestMessages();
	});
});

// 🚨🚨 [핵심] 1. 전역 뱃지 업데이트 기능이 추가된 목록 로드 함수 🚨🚨
function loadConversationList(empNo) {
	$.ajax({
		url : '/api/message/conversationList',
		type : 'get',
		dataType : 'json',
		success: function(response) {
            
            // ------------------------------------------------
            // 🚩 전역 뱃지 카운트 계산 및 업데이트 🚩
            // ------------------------------------------------
            let totalUnreadCount = 0;
            if (response && response.length > 0) {
                response.forEach(conv => {
                    totalUnreadCount += conv.unreadCount || 0; 
                });
            }
            
            const badgeElement = $('#messageBadge');
            badgeElement.text(totalUnreadCount > 99 ? '99+' : totalUnreadCount); 
            
            if (totalUnreadCount > 0) {
                badgeElement.show(); // 뱃지 표시
            } else {
                badgeElement.hide(); // 뱃지 숨김
            }
            // ------------------------------------------------
            
            // 이 함수는 messageList.jsp에 있다면 왼쪽 목록도 렌더링합니다.
            if (typeof renderConversationList === 'function') {
			    renderConversationList(response); 
            }
		}, 
		error: function(xhr, status, error) {
            console.error("대화 목록 로드 실패:", status, error);
        }
	});
}

// =========================================================
// 🚨🚨 [핵심] 2. 상단 드롭다운 목록 로드 함수 (SB Admin 스타일) 🚨🚨
// =========================================================

// 단일 쪽지 항목 HTML 생성 함수 (SB Admin 2 스타일)
function createMessageItemHtml(msg) {
	
    let formattedTime = '시간 오류';
    if (msg.sendDate) {
        try {
            const date = new Date(msg.sendDate);
            formattedTime = date.toLocaleTimeString('ko-KR', { hour: 'numeric', minute: '2-digit' });
        } catch (e) {}
    }
	
	const otherEmpNo = msg.senderEmpNo;
    
    // HTML 구조: SB Admin 2 스타일
    return '<a class="list-group-item list-group-item-action d-flex align-items-start py-3" ' + 
        	'href="/message/messageList?otherEmpNo=' + otherEmpNo + '">' + 
            '<div class="me-3" style="width: 40px; height: 40px;">' +
                '<img class="rounded-circle w-100 h-100" src="/img/profile_placeholder.png" alt="프로필">' +
            '</div>' +
            '<div class="w-100">' +
                '<div class="small text-gray-500 mb-1">' + (msg.senderName || '알 수 없음') + ' · ' + formattedTime + '</div>' + 
                '<div class="fw-bold text-truncate content-message2" style="max-width: 250px;">' + (msg.msgContent || '내용 없음') + '</div>' +
            '</div>' +
        '</a>';
		
}

function loadLatestMessages() {
    const myEmpNo = $('#sessionEmpNo').val();
	console.log(myEmpNo);
    if (!myEmpNo) return;
    
    const container = $('#latestMessagesContainer');
    container.html('<a class="list-group-item text-center small text-gray-500 py-2" href="#">로딩 중...</a>');

    $.ajax({
        url: '/api/message/latestUnread', 
        type: 'GET',
        dataType: 'json',
        success: function(messages) {
            container.empty();
            
            if (messages && messages.length > 0) {
                messages.forEach(msg => {
                    container.append(createMessageItemHtml(msg));
                });
            } else {
                container.html('<a class="list-group-item text-center small text-gray-500 py-2" href="#">새로운 쪽지가 없습니다.</a>');
            }
        },
        error: function(xhr, status, error) {
            console.error("❌ 최신 쪽지 드롭다운 로드 실패:", error);
            container.html('<a class="list-group-item text-center small text-danger py-2" href="#">로드 실패</a>');
        }
    });
}

