let stompClient = null; // ⭐ 전역에서 접근 가능하도록 선언

// 🚨 1. WebSocket 연결 및 구독 함수: 사번(empNo)을 인자로 받습니다.
function connectWebSocket(empNo) {

    // 🌟 1:1 알림의 표준 구독 경로로 복구: '/user/queue/notifications'
    const userQueue = '/user/queue/notifications';
    
    // ✨ (최종 보안) empNo가 유효한 문자열일 때만 연결 시도합니다. ✨
    if (empNo && empNo.trim() !== "" && empNo !== "null") {
		console.log(`WebSocket 연결 시도: 대상 사번=${empNo}`);
        
        const socket = new SockJS("/ws/stomp"); 
        stompClient = Stomp.over(socket); 

        stompClient.connect({}, function (frame) {
            console.log('STOMP 연결 성공!');

            // 🚨 표준 경로 구독 (Spring이 내부적으로 /user/{sessionId}/queue/notifications로 라우팅)
            stompClient.subscribe(userQueue, function (notification) {
				
				const rawBody = notification.body;
				const body = rawBody.trim(); 
				    
				console.log("★★★★ STOMP 메시지 수신 성공! 내용:", body);
                
				if (body) {
				        alert("[새 결재 알림] " + body); 
				       // updateSidebarBadge(); // 알림이 왔으니 뱃지 업데이트
				    } else {
				        console.warn("수신된 메시지 내용이 비어있습니다.");
				    }
            });
            
        }, function (error) {
            console.error('WebSocket 연결 실패:', error);
        });

    } else {
        console.log('인증 정보 미확인. WebSocket 연결 건너뜀.');
    }
}

// 🚨 2. 뱃지 업데이트 함수 정의 (JS 파일에 포함)
function updateSidebarBadge() {
    // ... (기존 updateSidebarBadge 함수 내용 그대로 유지)
    $.ajax({
        url: "/approve/getWaitingCount", 
        type: "GET",
        dataType: "json",
        success: function(response) {
            const waitingCount = response.waitingCount; 
            const badgeElement = $("#badgeId"); // ID는 실제 HTML ID로 변경 필요
            
            if (waitingCount > 0) {
                badgeElement.text(waitingCount);
                badgeElement.show();
            } else {
                badgeElement.hide();
            }
        },
        error: function(xhr, status, error) {
            console.error("뱃지 업데이트 실패:", error);
			console.error("오류 상세:", xhr.status, xhr.responseText);
        }
    });
}