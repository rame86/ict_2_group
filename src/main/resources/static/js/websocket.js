let stompClient = null;

function connectWebSocket(empNo) {

    if (empNo && empNo.trim() !== "" && empNo !== "null") {

        const socket = new SockJS("/ws/stomp"); 
        stompClient = Stomp.over(socket); 

        stompClient.connect({}, function (frame) {

			const globalTopic = '/topic/global-notifications';
			
            stompClient.subscribe(globalTopic, function (notification) {
				
				try {
					const data = JSON.parse(notification.body);
					if (data.targetEmpNo === empNo) {
						alert("[새 결재 알림] " + data.content);
						$("#approvalIcon").addClass("icon-notify");
					}
				} catch (e) {
					console.error("수신 메시지 파싱 오류:", e, notification.body);
				}
				
            });
            
        }, function (error) {
            console.error('WebSocket 연결 실패:', error);
        });

    } else {
        console.log('인증 정보 미확인. WebSocket 연결 건너뜀.');
    }
	
}

function updateSidebarBadge() {
	
    $.ajax({
        url: "/approve/getWaitingCount", 
        type: "GET",
        dataType: "json",
        success: function(response) {
			const waitingCount = response;
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
        },
        error: function(xhr, status, error) {
            console.error("뱃지 업데이트 실패:", error);
			console.error("오류 상세:", xhr.status, xhr.responseText);
        }
    });
	
}