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
						
						const message = data.content;
						let targetUrl = "";
						
						if (message.includes("새로운 결재")) {
							targetUrl = "/approve/receiveList"; 
						} else if (message.includes("최종 승인")) {
							targetUrl = "/approve/finishList"; 
						} else {
							targetUrl = "/approve/finishList"; 
						}
						
						toastr.success(message, '결재 알림', { 
							timeOut : 5000, 
							positionClass : 'toast-bottom-right', 
							toastClass : 'toast-success toast-custom-sere', 
							onclick : function(){
								if(targetUrl) window.location.href = targetUrl;
							} 
						});
						updateSidebarBadge();
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