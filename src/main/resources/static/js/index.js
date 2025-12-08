// 1. WebSocket 연결 및 구독 로직 (전역 변수 선언)
    let stompClient = null; // ⭐ 전역에서 접근 가능하도록 let으로 선언
    const currentEmpNo = "${ login.empNo }";
    
    // ✨ (최종 보안) currentEmpNo가 유효한 사번일 때만 연결 시도합니다. ✨
    if (currentEmpNo && currentEmpNo.trim() !== "" && currentEmpNo !== "null") {
        
        // 💡 1단계: SockJS 객체 생성
        const socket = new SockJS("/ws/stomp"); 
        
        // 💡 2단계: stompClient 변수에 STOMP 프로토콜 객체 할당
        stompClient = Stomp.over(socket); 

        // 💡 3단계: 연결 요청 (중첩 없이 한 번만 호출)
        stompClient.connect({}, function (frame) {
            console.log('STOMP 연결 성공!');

            const userQueue = '/queue/notifications';
			
            stompClient.subscribe(userQueue, function (notification) {
				
				const rawBody = notification.body;
				const body = rawBody.trim(); // 혹시 모를 공백 문자 제거
				    
				// ⭐ 2. 메시지가 수신되었다는 로그를 출력 (이 로그가 뜨면 100% 수신 성공) ⭐
				console.log("★★★★ 메시지 수신 성공! 내용:", body);
                
				if (body) {
				        // 팝업 등으로 사용자에게 알림 메시지 표시
				        alert("[새 결재 알림] " + body); 
				        
				        // 뱃지 업데이트는 지금은 무시하고 alert만 확인
				        // updateSidebarBadge(); 
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


    // 2. 💡 뱃지 업데이트 함수 정의 (같은 스크립트 블록 내부에 정의)
    function updateSidebarBadge() {
        $.ajax({
            url: "/approve/getWaitingCount", 
            type: "GET",
            dataType: "json",
            success: function(response) {
                // 서버 응답 구조에 따라 response.waitingCount 등을 사용
                const waitingCount = response.waitingCount; 
                const badgeElement = $("#badgeId"); // 뱃지 엘리먼트 ID로 변경 필요 (예: #notification-badge)
                
                if (waitingCount > 0) {
                    badgeElement.text(waitingCount);
                    badgeElement.show();
                } else {
                    badgeElement.hide();
                }
            },
            error: function(xhr, status, error) {
                console.error("뱃지 업데이트 실패:", error);
            }
        });
    }