<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>message - message</title>
</head>
<style>
.card-body, .list-group-item {
    font-size: 0.9rem;
}

.list-group-item h6 {
    font-size: 1rem;
}

.list-group-item p {
    font-size: 0.85rem;
}

.card-body .p-2 {
    font-size: 0.9rem;
}

small {
    font-size: 0.75rem;
}

.profile-img-small {
    width: 45px;
    height: 45px;
    object-fit: cover;
    margin-right: 10px;
}
</style>
<body class="sb-nav-fixed">
	<!-- 헤더 -->
	<jsp:include page="../common/header.jsp" flush="true"/>
	
	<div id="layoutSidenav">
	
		<!-- 사이드 -->
		<jsp:include page="../common/sidebar.jsp" flush="true"/>
		
		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid px-4">
					<h3 class="mt-4">쪽지함</h3><br>
					
					<div class="row">
    
				        <div class="col-xl-4 col-lg-5">
				            <div class="card shadow mb-4">
				                <div class="card-header py-3">
				                    <h6 class="m-0 font-weight-bold text-primary">대화 상대 목록</h6>
				                </div>
				                
				                <div class="list-group list-group-flush" id="conversationListContainer" style="max-height: 700px; overflow-y: auto;">
    								<div class="p-3 text-center text-muted">대화 목록을 불러오는 중...</div>
								</div>
				            </div>
				        </div>

				        <div class="col-xl-8 col-lg-7">
				            <div class="card shadow mb-4">
				                <div class="card-header py-3">
				                    <h6 class="m-0 font-weight-bold text-primary" id="chatWindowHeader">김철수 사원과의 대화</h6>
				                </div>
				                
				                <div class="card-body" style="height: 500px; overflow-y: auto;" id="messageArea">
				                    
				                    <div class="d-flex justify-content-start mb-3">
				                        <div class="p-2 border rounded" style="max-width: 60%;">
				                            안녕하세요, 김철수입니다. 결재 서류를 올렸는데 확인 부탁드립니다!
				                            <div class="text-right text-muted small mt-1">오전 10:00</div>
				                        </div>
				                    </div>
				                    
				                    <div class="d-flex justify-content-end mb-3">
				                        <div class="p-2 rounded bg-primary text-white" style="max-width: 60%;">
				                            네, 지금 바로 확인하겠습니다.
				                            <div class="text-left small mt-1" style="color: rgba(255, 255, 255, 0.7);">오전 10:01</div>
				                        </div>
				                    </div>
				
								</div>
				
				                <div class="card-footer">
				                    <div class="input-group">
				                        <input type="text" class="form-control" id="messageInput" placeholder="메시지를 입력하세요">
				                        <button class="btn btn-primary" type="button" id="sendMessageBtn" onclick="sendMessage()">전송</button>
				                    </div>
				                </div>
				            </div>
				        </div>
				    </div>
				</div>
				<input type="hidden" id="sessionEmpNo" value="${login.empNo}">
			</main>

			<!-- 푸터 -->
			<jsp:include page="../common/footer.jsp" flush="true"/>
		</div>
	</div>
</body>
<script>
//STOMP 기반
function getChatRoomId(id1, id2) {
    if (id1.localeCompare(id2) < 0) {
        return id1 + "_" + id2;
    } else {
        return id2 + "_" + id1;
    }
}

stompClient = null;
let currentSubscription = null; // 현재 구독 중인 채널을 관리하기 위한 변수
let currentReceiverEmpNo = null; // 현재 대화 상대 ID

function connectSocket() {
    // WebSocketConfig의 /ws/stomp 엔드포인트로 연결
    const socket = new SockJS('/ws/stomp'); 
    stompClient = Stomp.over(socket);
    
    stompClient.connect({}, function(frame) {
        console.log('STOMP: 연결 성공!★★♡♡♡♡♡♡');
        
        // 연결 성공 후 필요한 초기 작업 (예: 개인 알림 채널 구독 등)을 여기에 넣을 수 있습니다.
        const myEmpNo = $('#sessionEmpNo').val(); // 나의 사번
        console.log("DEBUG: 연결된 사용자 사번:", myEmpNo);
        
        const personalTopic = '/topic/notifications/' + myEmpNo;
        
        stompClient.subscribe(personalTopic, function(notificationOutput) {
            console.log("STOMP: [채팅] 개인 알림 채널(" + personalTopic + ")에 새 메시지 도착. 목록 갱신 시작.");
            loadConversationList(myEmpNo); 
        });
        
        // 🚨 2. 초기 대화 목록 로드 (연결 성공 후 한 번 호출) 🚨
        loadConversationList(myEmpNo);
        
    }, function(error) {
        console.error('STOMP: 연결 실패 또는 오류:', error);
        // 연결 실패 시 재시도 로직 등을 구현할 수 있습니다.
    });
    
}

$(document).ready(function(){
    const currentEmpNo = $('#sessionEmpNo').val();
    if (currentEmpNo) {
        connectSocket();
    } else {
        $('#conversationListContainer').html('<div class="p-3 text-center text-danger">로그인 정보가 유효하지 않습니다.</div>');
    }
});

function loadConversationList(empNo) {
	$.ajax({
		url : '/api/message/conversationList',
		type : 'get',
		dataType : 'json',
		success: function(response) {
			renderConversationList(response);
		}, 
		error: function(xhr, status, error) {
            console.error("대화 목록 로드 실패:", status, error);
            $('#conversationListContainer').html('<div class="p-3 text-center text-muted">목록을 불러오는 데 실패했습니다. 서버 상태를 확인해주세요.</div>');
        }
	});
}

function renderConversationList(list) {
	
	console.log(list);
	const container = $('#conversationListContainer');
    container.empty();
    
    if(!list || list.length === 0) {
    	container.html('<div class="p-3 text-center text-muted">대화 내역이 없습니다.</div>');
        return;
    }
    
 	// conv는 MessageVO 객체 하나에 해당함
	list.forEach(conv => {
        
        // 1. 읽지 않은 메시지 뱃지 처리
        const unreadCount = conv.unreadCount || 0;
        const unreadBadge = unreadCount > 0 
            ? '<span class="badge bg-danger unread-count-badge ms-2">' + unreadCount + '</span>'
            : '';
            
        // 2. 항목 디자인 클래스 처리
        const unreadClass = unreadCount > 0 ? 'unread' : '';
        
        // 3. 시간 형식 변환 (Invalid Date 방어 로직 적용)
        let timeString = '';
        if (conv.latestMessageTime) {
            try {
                const date = new Date(conv.latestMessageTime); 
                // 유효한 날짜 검사
                if (!isNaN(date.getTime())) { 
                    timeString = date.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
                } else {
                    timeString = '시간 정보 오류';
                }
            } catch (error) {
                timeString = '파싱 오류';
            }
        }
        
        // 부서/직책 값이 없을 경우 괄호 자체를 제거하기 위한 변수
        const positionText = conv.otherUserPosition || ''; 
        const positionHtml = positionText ? ' (' + positionText + ')' : '';


        // 4. HTML 항목 생성 (순수 문자열 결합 방식으로 변수 삽입 오류 원천 차단)
        const itemHtml = 
            // <a> 태그 시작 및 속성 정의
            '<a href="javascript:void(0);" ' + 
            'class="list-group-item list-group-item-action py-3 ' + unreadClass + '" ' + 
            'data-other-name="' + conv.otherUserName + '" ' +
            // onclick 속성: 인자들은 작은따옴표로 감싸서 문자열로 전달
            'onclick="loadChatWindow(\'' + conv.otherUserId + '\', \'' + conv.otherUserName + '\')">' + 
                
                '<div class="d-flex align-items-center">' +
                    '<img src="/img/profile_placeholder.png" class="rounded-circle profile-img-small" alt="프로필">' +
                    
                    '<div class="w-100">' +
                        '<div class="d-flex justify-content-between align-items-start">' +
                            '<h6 class="mb-0 fw-bold d-flex align-items-center">' +
                                // 이름, 직책/부서 (괄호 포함), 뱃지 삽입
                                conv.otherUserName + positionHtml + ' ' + unreadBadge +
                            '</h6>' +
                            // 시간 삽입
                            '<small class="text-muted">' + timeString + '</small>' +
                        '</div>' +
                        '<p class="mb-0 text-muted text-truncate" style="max-width: 90%;">' +
                            // 메시지 내용 삽입
                            conv.latestMessageContent +
                        '</p>' +
                    '</div>' +
				'</div>' +
			'</a>';
			
		container.append(itemHtml);
		
    });
 
	console.log("렌더링 루프 완료. 컨테이너 항목 개수:", container.children().length);
	
}

// 메세지로드 + STOMP 구독/해제
function loadChatWindow(otherUserId, otherUserName) {
	
	console.log("선택된 상대방:", otherUserName, otherUserId);
	
	// 메세지 읽음 처리
	$.ajax({
        url: '/chat/markAsRead', // ChatController에 정의한 POST 엔드포인트
        type: 'POST',
        xhrFields: {
            withCredentials: true 
        },
        data: { otherUserId: otherUserId }, // 상대방 ID만 서버로 전송
        success: function(response) {
            if (response === "success") {
                console.log("읽음 처리 성공: 뱃지 및 스타일 갱신 필요");
                loadConversationList($('#sessionEmpNo').val());
            } else {
                console.error("읽음 처리 서버 응답 오류:", response);
            }
        },
        error: function(xhr, status, error) {
            console.error("읽음 처리 통신 실패:", error);
        }
    });
	
	
	$('#chatWindowHeader').text(otherUserName + '님과의 대화');
	
	currentReceiverEmpNo = otherUserId;
	
	$('.list-group-item').removeClass('active'); 
	$(`.list-group-item[data-other-id="${otherUserId}"]`).addClass('active');
	
    const chatContainer = $('#messageArea');
    chatContainer.empty();
    chatContainer.html('<div class="p-5 text-center text-muted">메시지 로딩 중...</div>');
	
    // STOMP 구독/해제
    // 1. 기존 구독 해제: 다른 채팅방을 열 때 이전 방의 구독을 끊습니다.
    if (currentSubscription) {
        currentSubscription.unsubscribe();
        currentSubscription = null;
        console.log("STOMP: 이전 채팅방 구독 해제");
    }
    
 	// 2. 새로운 채팅방 ID 생성 및 주제(Topic) 설정
    const myEmpNo = $('#sessionEmpNo').val(); // 💡 세션 ID를 여기서 다시 가져와야 합니다.
    const chatRoomId = getChatRoomId(myEmpNo, otherUserId); // helper 함수 사용
    const roomTopic = '/topic/chat/room/' + chatRoomId;
    
 	// 3. 새로운 채팅방 구독 설정
    if (stompClient && stompClient.connected) {
        currentSubscription = stompClient.subscribe(roomTopic, function(messageOutput) {
        	
            // 메시지가 실시간으로 도착하면 이 콜백 함수가 실행됩니다.
            const messageVO = JSON.parse(messageOutput.body);
            
            // 새 메시지를 화면에 추가
            appendNewMessageToChat(messageVO, myEmpNo);
            
        });
        console.log("STOMP: 새로운 주제 구독 완료:", roomTopic);
    }
    
    // 기존 AJAX요청 (메세지 로드)
	$.ajax({
        url: '/api/message/chat/' + otherUserId, 
        type: 'GET',
        dataType: 'json',
        success: function(response) {
        	renderChatMessages(response.messages, otherUserId);
        	chatContainer.scrollTop(chatContainer[0].scrollHeight);
        },
        error: function(xhr, status, error) {
            console.error("대화 내용 로드 실패");
            chatContainer.html('<div class="p-5 text-center text-danger">대화 내용을 불러오는데 실패했습니다.</div>');
        }
    });
	
}

function renderChatMessages(messages, currentOtherUserId) {
	const chatContainer = $('#messageArea');
    chatContainer.empty(); // 이전 로딩 메시지 삭제
    
    const myUserId = '${login.empNo}';

    if (!messages || messages.length === 0) {
        chatContainer.html('<div class="p-5 text-center text-muted">아직 대화가 없습니다. 새로운 메시지를 보내보세요!</div>');
        return;
    }
    
 // 💡 1단계 디버깅: 메시지 배열 확인
    console.log("렌더링할 메시지 수:", messages.length);
    console.log("첫 번째 메시지 데이터:", messages[0]);
    
    messages.forEach(message => {
    	
    	console.log("처리 중인 메시지 내용:", message.msgContent);
    	
		// 메시지 발신자가 '나'인지 '상대방'인지 판단
        const isMyMessage = (message.senderEmpNo === myUserId);
        
        // CSS 클래스 설정
        const alignmentClass = isMyMessage ? 'justify-content-end' : 'justify-content-start';
        const bubbleClass = isMyMessage ? 'bg-primary text-white' : 'bg-light';
        
        // 시간 형식 변환
        let timeString = '';
        if (message.sendDate) {
            const date = new Date(message.sendDate);
            if (!isNaN(date.getTime())) {
                timeString = date.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
            }
        }
        
     	// 메시지 HTML 생성
        const messageHtml =
        	'<div class="d-flex ' + alignmentClass + ' mb-3">' +
	            '<div class="message-bubble-container" style="display: inline-block; max-width: 70%;">' + 
	                '<div class="message-bubble p-2 rounded ' + bubbleClass + '">' +
	                    message.msgContent + 
	                '</div>' +
	                '<div class="text-end text-muted small mt-1">' + timeString +
	                '</div>' +
	            '</div>' +
	        '</div>';
			
		chatContainer.append(messageHtml);
    });
    
}

// STOMP client.send()
function sendMessage(){
	
//	const senderEmpNo = $('#sessionEmpNo').val();
	const content = $('#messageInput').val().trim();
	const receiverEmpNo = currentReceiverEmpNo;
	
	if (!content) {
        alert("메시지 내용을 입력해 주세요.");
        return;
    }
	
	if (!receiverEmpNo) {
        alert("대화 상대를 먼저 선택해 주세요.");
        return;
    }
	
    const messageData = {
        receiverEmpNo: receiverEmpNo,
        msgContent: content
    };
    
    // STOMP send로 변경
    // /app/chat/send 주소로 메시지 발행 (ChatController의 @MessageMapping으로 전달)
    stompClient.send("/app/chat/send", {}, JSON.stringify(messageData));
    $('#messageInput').val('');
    
}

// 분리된 메세지(추가)
function appendNewMessageToChat(messageVO, myEmpNo) {
    const chatContainer = $('#messageArea');
    
    const isMyMessage = messageVO.senderEmpNo === myEmpNo;
    
    // CSS 및 시간 포맷팅 로직 (renderChatMessages의 내용 재사용)
    const alignmentClass = isMyMessage ? 'justify-content-end' : 'justify-content-start';
    const bubbleClass = isMyMessage ? 'bg-primary text-white' : 'bg-light';
    
    let timeString = '';
    if (messageVO.sendDate) { 
        try {
            const date = new Date(messageVO.sendDate);
            if (!isNaN(date.getTime())) {
                timeString = date.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
            }
        } catch (e) {
            timeString = '시간 오류';
        }
    }
    
    const messageHtml =
        '<div class="d-flex ' + alignmentClass + ' mb-3">' +
            '<div class="message-bubble-container" style="display: inline-block; max-width: 70%;">' + 
                '<div class="message-bubble p-2 rounded ' + bubbleClass + '">' + 
                    messageVO.msgContent + 
                '</div>' +
                '<div class="text-end text-muted small mt-1">' + timeString +
                '</div>' +
            '</div>' +
        '</div>';
        
    chatContainer.append(messageHtml);
    chatContainer.scrollTop(chatContainer[0].scrollHeight);
    
    if (!isMyMessage) {
        if (currentReceiverEmpNo) {
            $.ajax({
                url: '/chat/markAsRead',
                type: 'POST',
                data: { otherUserId: currentReceiverEmpNo },
                success: function(response) {
                    if (response === "success") {
                        console.log("✅ 채팅 중 실시간 읽음 처리 성공.");
                        loadConversationList(myEmpNo); 
                    }
                }

            });
        }
    }
    
}

</script>
</html>