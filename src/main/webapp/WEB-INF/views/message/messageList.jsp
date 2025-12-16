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
						<div class="col-xl-3 col-lg-4">
								
						 	<div id="notificationListContainer">
						        <div class="card shadow-sm mb-3 mx-2 border-left-danger" data-noti-id="1">
	    							
									    <div class="card-header py-2 bg-primary d-flex justify-content-between align-items-center">
									        <h6 class="m-0 small fw-bold text-white">
									            <i class="fas fa-exclamation-triangle me-1 text-white"></i> 미확인 알림
									        </h6>
									        <small class="m-0 text-white">방금 전</small>
									    </div>
								    
								    
								    <a href="#" class="card-body p-3 text-decoration-none" onclick="markOneNotificationAsRead(this, event)">
								        <p class="mb-0 small text-dark">홍길동 사원의 휴가 신청 결재 요청이 도착했습니다. 확인 부탁드립니다.</p>
								    </a>
								    
								</div>
							</div>
											
					    </div>
    
				        <div class="col-xl-3 col-lg-4">
						    <div class="card shadow mb-4" style="height: 700px;">
						        <div class="card-header py-3 d-flex justify-content-between align-items-center">
						            
						            <h6 class="m-0 font-weight-bold text-primary">대화 목록</h6>
						            
						            <button class="btn btn-sm btn-outline-primary" 
						                    data-bs-toggle="modal" data-bs-target="#newChatModal">
						                <i class="fas fa-plus fa-fw"></i> 새 대화
						            </button>
						            
						        </div>
						        
						        <div class="list-group list-group-flush" id="conversationListContainer" style="max-height: 700px; overflow-y: auto;">
						            <div class="p-3 text-center text-muted">대화 목록을 불러오는 중...</div>
						        </div>
						    </div>
						</div>

				        <div class="col-xl-6 col-lg-4">
				            <div class="card shadow mb-4" style="height: 700px;">
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
				<div class="modal fade" id="newChatModal" tabindex="-1" role="dialog" aria-labelledby="newChatModalLabel" aria-hidden="true">
				    <div class="modal-dialog" role="document">
				        <div class="modal-content">
				            <div class="modal-header">
				                <h5 class="modal-title" id="newChatModalLabel">새로운 대화 상대 찾기</h5>
				                <button class="close btn" type="button" data-bs-dismiss="modal" aria-label="Close">
				                    <span aria-hidden="true">×</span>
				                </button>
				            </div>
				            <div class="modal-body">
				                
				                <div class="input-group mb-3">
				                    <input type="text" class="form-control" id="employeeSearchInput" placeholder="이름 또는 사번으로 검색">
				                    <button class="btn btn-primary" type="button" id="searchEmployeeBtn">검색</button>
				                </div>
				                
				                <div id="employeeSearchResults" class="list-group" style="max-height: 300px; overflow-y: auto;">
				                    <div class="p-3 text-muted text-center">검색을 시작하세요.</div>
				                </div>
				
				            </div>
				            <div class="modal-footer">
				                <button class="btn btn-secondary" type="button" data-bs-dismiss="modal">닫기</button>
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

let currentSubscription = null; // 현재 구독 중인 채널을 관리하기 위한 변수
let currentReceiverEmpNo = null; // 현재 대화 상대 ID

//------------------------------------
//💡 유틸리티 및 채팅방 로직 (유지)
//------------------------------------

//STOMP 기반 (유지)
function getChatRoomId(id1, id2) {
 if (id1.localeCompare(id2) < 0) {
     return id1 + "_" + id2;
 } else {
     return id2 + "_" + id1;
 }
}

//대화 목록 렌더링 (유지: 왼쪽 목록 UI 구성)
function renderConversationList(list) {
	
	console.log(list);
	const container = $('#conversationListContainer');
 	container.empty();
 
	list.forEach(conv => {
     
     // 1. 읽지 않은 메시지 뱃지 처리 (뱃지 위치를 우측으로 옮기기 위해 ms-2 클래스는 제거)
     const unreadCount = conv.unreadCount || 0;
     const unreadBadge = unreadCount > 0 
         ? '<span class="badge bg-danger unread-count-badge">' + unreadCount + '</span>'
         : '';
         
     // 2. 항목 디자인 클래스 처리
     const unreadClass = unreadCount > 0 ? 'unread' : '';
     
     // 3. 시간 형식 변환 (유지)
     let timeString = '';
     if (conv.latestMessageTime) {
         try {
             const date = new Date(conv.latestMessageTime); 
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
     // 직책을 이름과 분리하여 작게 표시하기 위해 괄호를 제거합니다.
     const positionHtml = positionText ? '<span class="text-muted fw-normal ms-1 conversation-position">' + positionText + '</span>' : '';


     // 4. HTML 항목 생성 (가독성 개선)
     const itemHtml = 
         '<a href="javascript:void(0);" ' + 
         'class="list-group-item list-group-item-action py-3 ' + unreadClass + '" ' + 
         'data-other-name="' + conv.otherUserName + '" ' +
         'data-other-id="' + conv.otherUserId + '" ' + // 활성화 스타일을 위해 추가 권장
         'onclick="loadChatWindow(\'' + conv.otherUserId + '\', \'' + conv.otherUserName + '\')">' + 
             
             '<div class="d-flex align-items-center">' +
                 '<img src="/img/profile_placeholder.png" class="rounded-circle profile-img-small" alt="프로필">' +
                 
                 '<div class="w-100">' +
                     
                     // 1. 이름/직책/시간 (상단 라인)
                     '<div class="d-flex justify-content-between align-items-center">' +
                         '<h6 class="mb-1 fw-bold d-flex align-items-center conversation-name">' + // mb-0 -> mb-1로 변경
                             conv.otherUserName + positionHtml + 
                         '</h6>' +
                         '<small class="text-muted text-nowrap conversation-time">' + timeString + '</small>' +
                     '</div>' +
                     
                     // 2. 메시지 내용 / 뱃지 (하단 라인)
                     '<div class="d-flex justify-content-between align-items-center">' +
                         '<p class="mb-0 text-muted text-truncate conversation-message" style="max-width: 90%;">' +
                             conv.latestMessageContent +
                         '</p>' +
                         // 뱃지를 오른쪽 끝에 별도로 배치
                         (unreadCount > 0 ? unreadBadge : '') +
                     '</div>' +

                 '</div>' +
			'</div>' +
		'</a>';
			
		container.append(itemHtml);
		
 	});
 
}

//메세지로드 + STOMP 구독/해제 (유지)
function loadChatWindow(otherUserId, otherUserName) {
	
	if (!stompClient || stompClient.ws.readyState !== WebSocket.OPEN) { 
		console.warn("STOMP 연결이 아직 준비되지 않아 채팅방 구독이 지연됩니다.");
        
        setTimeout(() => loadChatWindow(otherUserId, otherUserName), 200);
        return; 
    }
	
	console.log("선택된 상대방:", otherUserName, otherUserId);
	
	// 메세지 읽음 처리
	$.ajax({
     url: '/chat/markAsRead',
     type: 'POST',
     xhrFields: {
         withCredentials: true 
     },
     data: { otherUserId: otherUserId },
     success: function(response) {
         if (response === "success") {
             console.log("읽음 처리 성공: 뱃지 및 스타일 갱신 필요");
             // 💡 loadConversationList 호출 (헤더 파일의 전역 함수 사용)
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
	if (stompClient && stompClient.connected && currentSubscription) {
	    currentSubscription.unsubscribe();
	    currentSubscription = null;
	    console.log("STOMP: 이전 채팅방 구독 해제");
	} else if (currentSubscription) {
	    currentSubscription = null; 
	}
 
	// 2. 새로운 채팅방 ID 생성 및 주제(Topic) 설정
 	const myEmpNo = $('#sessionEmpNo').val(); 
 	const chatRoomId = getChatRoomId(myEmpNo, otherUserId);
 	const roomTopic = '/topic/chat/room/' + chatRoomId;
 
	// 3. 새로운 채팅방 구독 설정
 	// 💡 stompClient는 header-notifications.js에 정의된 전역 변수를 사용합니다.
 	if (stompClient && stompClient.connected) { // 조건 변경: .connected 사용
	    currentSubscription = stompClient.subscribe(roomTopic, function(messageOutput) {
	        const messageVO = JSON.parse(messageOutput.body);
	        appendNewMessageToChat(messageVO, myEmpNo);
	    });
	    console.log("STOMP: 새로운 주제 구독 완료:", roomTopic);
	} else {
	    console.error("STOMP 연결이 순간적으로 끊겼거나 초기화에 문제가 있습니다. 구독 실패.");
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

//대화 내용 렌더링 (유지)
function renderChatMessages(messages, currentOtherUserId) {
 // ... (기존 renderChatMessages 로직 유지) ...
 // 이 함수는 header-notifications.js로 옮길 필요 없습니다.
 
	const chatContainer = $('#messageArea');
 chatContainer.empty(); 
 
 const myUserId = '${login.empNo}';

 if (!messages || messages.length === 0) {
     chatContainer.html('<div class="p-5 text-center text-muted">아직 대화가 없습니다. 새로운 메시지를 보내보세요!</div>');
     return;
 }
 
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

//메시지 전송 (유지)
function sendMessage(){
	
	const content = $('#messageInput').val().trim();
	const receiverEmpNo = currentReceiverEmpNo;
	const myEmpNo = $('#sessionEmpNo').val();
		
	if (!stompClient || stompClient.ws.readyState !== WebSocket.OPEN) { 
		console.error("STOMP 연결이 아직 준비되지 않았습니다. 잠시 후 다시 시도하세요.");
		alert("메시지 시스템이 아직 연결 중입니다. 1~2초 후 다시 시도해 주세요.");
		return; 
	}
	 
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
	 
	stompClient.send("/app/chat/send", {}, JSON.stringify(messageData));
	$('#messageInput').val('');
	
	setTimeout(function() {
	     console.log("메시지 전송 지연 후 목록 갱신 요청");
	     loadConversationList(myEmpNo); 
	 }, 200);

}

//새 메시지 추가 및 실시간 읽음 처리 (유지)
function appendNewMessageToChat(messageVO, myEmpNo) {
 const chatContainer = $('#messageArea');
 
 // ... (기존 HTML 생성 로직 유지) ...
 
 const isMyMessage = messageVO.senderEmpNo === myEmpNo;
 
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
                     // 💡 loadConversationList 호출 (헤더 파일의 전역 함수 사용)
                     loadConversationList(myEmpNo); 
                 }
             }
         });
     }
 }
 
}

//검색 실행 및 결과 렌더링 함수
function searchAndRenderEmployees(keyword) {
	keyword = keyword === undefined ? $('#employeeSearchInput').val().trim() : keyword;
    const resultsContainer = $('#employeeSearchResults');
    resultsContainer.empty();
    
    resultsContainer.html('<div class="p-3 text-primary text-center">직원 검색 중...</div>');

    $.ajax({
        url: '/api/message/emp', 
        type: 'GET',
        dataType: 'json',
        data: { keyword: keyword },
        success: function(response) {
            renderSearchResults(response, resultsContainer);
        },
        error: function(xhr, status, error) {
            console.error("직원 검색 실패:", error);
            resultsContainer.html('<div class="p-3 text-danger text-center">검색 중 오류가 발생했습니다.</div>');
        }
    });
}

// 검색 결과 HTML 렌더링 함수
function renderSearchResults(employees, container) {
	
    container.empty();
    
    if (!employees || employees.length === 0) {
        container.html('<div class="p-3 text-muted text-center">검색 결과가 없습니다.</div>');
        return;
    }
    
    // 현재 로그인 사용자 ID (본인 제외를 위해 사용)
    const myEmpNo = $('#sessionEmpNo').val();
    
    employees.forEach(emp => {
    	console.log(emp);
        const empNo = emp.empNo;
        const empName = emp.name;
        const positionDept = (emp.position || '') + (emp.dept ? ' (' + emp.dept + ')' : '');

        // 🚨 검색 결과에서 자기 자신 제외 (선택 사항)
        if (empNo === myEmpNo) {
            return; 
        }
        
        // 클릭 시 바로 대화 시작 함수 호출
        const itemHtml = 
        	'<a href="javascript:void(0);" ' + 
            'class="list-group-item list-group-item-action py-3 pe-3" ' + 
            'onclick="selectAndStartChat(\'' + emp.empNo + '\', \'' + emp.empName + '\')">' + 
            
                '<div class="d-flex align-items-center justify-content-between">' + 
                    '<div class="d-flex align-items-center me-2" style="width: 50%; min-width: 50%; flex-shrink: 0;">' + 
                        '<img src="/images/sorry.gif" class="rounded-circle" style="width: 35px; height: 35px; margin-right: 10px;" alt="프로필">' +
                        
                        '<div class="d-flex flex-column gap-2">' + 
                            '<h6 class="mb-0 fw-bold text-dark text-truncate" style="font-size: 0.95rem; line-height: 1.2;">' + emp.empName  + ' ( ' + emp.empNo + ' ) ' + '</h6>' +
                            '<small class="text-muted text-truncate" style="font-size: 0.8rem; line-height: 1.2;">' + emp.deptName + '</small>' +
                        '</div>' +
                    '</div>' +

                    '<div class="text-end d-flex flex-column justify-content-center gap-2" style="width: 50%; min-width: 50%; flex-shrink: 0; padding-right: 10px;">' + 
                        '<div class="fw-semibold text-secondary" style="font-size: 0.85rem; line-height: 1.2;">' + emp.gradeName + '</div>' +
                        '<small class="text-muted text-truncate" style="font-size: 0.75rem; line-height: 1.2;">' + emp.empEmail + '</small>' +
                    '</div>' +

                '</div>' +
            '</a>';
        
        container.append(itemHtml);
    });
    
}

// 선택된 직원과 대화 시작 및 모달 닫기
function selectAndStartChat(empNo, empName) {
	
    // 1. 기존 함수를 호출하여 채팅창 로드, 대화 목록 갱신, STOMP 구독 설정 모두 처리
    loadChatWindow(empNo, empName);
    
    // 2. 모달 닫기 (Bootstrap 5 방식)
    const newChatModal = bootstrap.Modal.getInstance(document.getElementById('newChatModal'));
    if (newChatModal) {
        newChatModal.hide();
    } else {
        $('#newChatModal').modal('hide');
    }
    
}


//모달창
$(document).ready(function() {

	$('#newChatModal').on('shown.bs.modal', function () {
        console.log("👉 모달 열림 이벤트 발생: 직원 검색 시작");
        searchAndRenderEmployees(''); 
        $('#employeeSearchInput').val('');
    });
	
    // 1. 검색 버튼 클릭 이벤트
    $('#searchEmployeeBtn').on('click', function() {
        searchAndRenderEmployees();
    });

    // 2. 검색 입력창에서 Enter 키 입력 이벤트
    $('#employeeSearchInput').on('input', function() {
        const keyword = $(this).val();
        searchAndRenderEmployees(keyword); 
    });

    // 3. 메시지 입력창에서 Enter 키 입력 이벤트
    $('#messageInput').on('keypress', function(e) {
        if (e.which === 13) { // Enter 키 코드
            e.preventDefault(); // 기본 submit 동작 방지
            sendMessage();
        }
    });
    
    // 알람창!
    if (typeof loadNotificationList === 'function') {
        console.log("🚀 [READY] 페이지 로드 완료. 알림 목록 로드 시작.");
        loadNotificationList();
    } else {
        console.error("❌ [ERROR] loadNotificationList 함수가 정의되지 않았습니다.");
    }
    
});

// 알람창
function renderNotifications(notifications) {
    
    console.log("🎨 [RENDER] renderNotifications 함수 실행. 데이터:", notifications); 
    
    const container = $('#notificationListContainer');
    container.empty();
    
    if (!notifications || notifications.length === 0) {
        container.html('<div class="p-3 text-center text-muted">새로운 알림이 없습니다.</div>');
        console.log("🎨 [RENDER] 알림 데이터가 없어 '새로운 알림 없음' 표시");
        return;
    }

    notifications.forEach(noti => {
        // ⭐ [중요] 서버의 AlertVO와 isRead 필드가 'Y' 또는 'N' 형태인지 확인합니다.
        const isRead = noti.isRead === 'Y'; 
        
        // 카드 스타일 설정: 읽음 상태에 따라 다르게 설정
        const cardBorderClass = isRead ? 'border-left-danger' : 'border-left-danger';
        const headerBgClass = isRead ? 'bg-light' : 'bg-primary'; 
        const headerTextColor = isRead ? 'text-muted' : 'text-white';
        const bodyTextColor = isRead ? 'text-muted' : 'text-dark';
        
        // 아이콘 및 텍스트 설정
        const headerText = isRead ? '확인됨' : '미확인 알림';
        const iconColor = isRead ? 'text-dark' : 'text-white';
        const iconClass = noti.type === 'APPROVAL' ? 'fas fa-exclamation-triangle' : 
                          noti.type === 'HR' ? 'fas fa-user-tie' : 
                          'fas fa-info-circle';
        
        
        // 알림 항목 HTML 생성
        const itemHtml = 
            // 1. 알림 카드 전체 (읽지 않은 알림에만 border-left 강조)
            '<div class="card shadow-sm mb-3 mx-2 ' + cardBorderClass + '" ' + 
            'data-noti-id="' + noti.id + '">' +
                
                // 2. 카드 헤더 (제목 영역)
                '<div class="card-header py-2 ' + headerBgClass + ' d-flex justify-content-between align-items-center">' +
                    '<h6 class="m-0 small fw-bold ' + headerTextColor + '">' +
                        '<i class="' + iconClass + ' me-1 ' + iconColor + '"></i>' + // 헤더 아이콘 색상 설정
                        headerText +
                    '</h6>' +
                    '<small class="m-0 ' + headerTextColor + '">' + formatTime(noti.createdDate) + '</small>' +
                '</div>' +
                
                // 3. 카드 본문 (내용 영역, 클릭 시 이동 및 읽음 처리)
                '<a href="' + (noti.linkId || 'javascript:void(0);') + '" ' + 
                'class="card-body p-3 text-decoration-none" ' + 
                'onclick="markOneNotificationAsRead(this, event)">' +
                '<div>' + 
	                // 보낸 사람 이름 (작은 텍스트)
	                '<div class="small text-muted mb-1">' + noti.senderName + '</div>' + 
	                
	                // 알림 제목/간략 내용 (굵은 텍스트)
	                '<p class="mb-0 fw-bold small ' + bodyTextColor + '">' + noti.title + '</p>' +
	                
	                // (선택 사항: 긴 내용이 있다면 주석 처리된 부분처럼 추가 가능)
	                // '<p class="mb-0 small text-truncate" style="max-width: 100%;">' + noti.content + '</p>' +
	                
	            '</div>' +
                '</a>' +
                
            '</div>';
            
        container.append(itemHtml);
    });
}

// 알림창 시간 포맷팅 함수 (예: '방금 전', '1일 전')
function formatTime(sendDate) {
    if (!sendDate) return '';
    
    try {
        const now = new Date();
        const sent = new Date(sendDate);
        const diffInSeconds = Math.floor((now - sent) / 1000);

        if (diffInSeconds < 60) {
            return '방금 전';
        } else if (diffInSeconds < 3600) { // 1시간 미만
            return Math.floor(diffInSeconds / 60) + '분 전';
        } else if (diffInSeconds < 86400) { // 24시간 미만
            return Math.floor(diffInSeconds / 3600) + '시간 전';
        } else if (diffInSeconds < 604800) { // 7일 미만
             return Math.floor(diffInSeconds / 86400) + '일 전';
        } else {
            // 7일 이상은 날짜 표시
            return sent.toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' }).replace(/\./g, '.');
        }
    } catch (e) {
        return sendDate;
    }
}

//알림 상세 페이지 이동 시 읽음 처리하는 함수
function markOneNotificationAsRead(element, event) {
    // <a> 태그의 부모인 .card 엘리먼트에서 data-noti-id를 가져옵니다.
    const $card = $(element).closest('.card');
    const notiId = $card.data('noti-id');
    
    // 1. 알림 ID가 유효한 경우에만 읽음 처리 요청
    if (notiId) {
        // 비동기 요청 (AJAX)으로 읽음 상태 업데이트
        $.ajax({
            url: '/notification/markAsRead', // 서버 알림 읽음 처리 API
            type: 'POST',
            data: { notificationId: notiId }, // 서버에 알림 ID 전송
            success: function(response) {
                console.log("✅ 알림 ID " + notiId + " 읽음 처리 완료.");
                
                // UI 갱신: card 스타일 변경 (읽음 상태로 변경)
                $card.removeClass('border-left-danger');
                $card.find('.card-header').removeClass('bg-primary').addClass('bg-light');
                $card.find('.card-header h6').removeClass('text-white').addClass('text-muted');
                $card.find('.card-header i').removeClass('text-white').addClass('text-dark');
                $card.find('.card-header small').removeClass('text-white').addClass('text-muted');
                $card.find('.card-body p').removeClass('text-dark').addClass('text-muted');
                $card.find('.card-header h6').html('<i class="fas fa-info-circle me-1 text-dark"></i> 확인됨');
                
                // 헤더 뱃지 갱신이 필요한 경우 호출
                if (typeof updateHeaderAlertsBadge === 'function') {
                    updateHeaderAlertsBadge(); 
                }
                
            },
            error: function(xhr, status, error) {
                console.error("❌ 알림 ID " + notiId + " 읽음 처리 실패:", error);
            }
        });
    }
}

//알림 탭 (쪽지함 왼쪽)의 알림 목록을 로드하는 함수
function loadNotificationList() {
    
    // [중요] JSP 코드의 알림 탭 영역에 id="notificationListContainer"가 있다고 가정합니다.
    const $listContainer = $('#notificationListContainer'); 
    
    // 로딩 상태 표시
    $listContainer.html('<div class="p-3 text-center text-primary">알림 목록을 불러오는 중...</div>');

    $.ajax({
        url: '/alert/allLatestView', // ⭐ 기존 AlertController의 엔드포인트 사용
        type: 'GET',
        dataType: 'json',
        success: function(notifications) {
            console.log("✅ 알림 목록 로드 성공:", notifications);
            
            // 기존에 정의된 renderNotifications 함수를 호출하여 목록 렌더링
            if (typeof renderNotifications === 'function') {
                renderNotifications(notifications);
            } else {
                 console.error("renderNotifications 함수가 정의되지 않았습니다.");
                 $listContainer.html('<div class="p-3 text-center text-danger">렌더링 오류 발생</div>');
            }
        },
        error: function(xhr, status, error) {
            console.error("❌ 알림 목록 로드 실패:", status, error);
            $listContainer.html('<div class="p-3 text-center text-danger">알림 목록 로드 실패: 서버 연결 확인 필요</div>');
        }
    });
}

</script>
</html>