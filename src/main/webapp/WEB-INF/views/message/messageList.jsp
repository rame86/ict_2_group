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
								    <!-- <a href="#" class="list-group-item list-group-item-action active py-3">
								        <div class="d-flex align-items-center">
								            <img src="https://via.placeholder.com/45" class="rounded-circle profile-img-small" alt="프로필">
								            
								            <div class="w-100">
								                <div class="d-flex justify-content-between align-items-start">
								                    <h6 class="mb-0 fw-bold d-flex align-items-center">
								                        김철수 사원
								                        <span class="badge bg-danger unread-count-badge ms-2">2</span>
								                    </h6>
								                    <small class="text-white">방금</small>
								                </div>
								                <p class="mb-0 text-truncate" style="max-width: 90%;">
								                    **[새 메시지]** 결재 서류 확인 부탁드립니다...
								                </p>
								            </div>
								        </div>
								    </a>
								    
								    <a href="#" class="list-group-item list-group-item-action py-3">
								        <div class="d-flex align-items-center">
								            <img src="https://via.placeholder.com/45" class="rounded-circle profile-img-small" alt="프로필">
								            
								            <div class="w-100">
								                <div class="d-flex justify-content-between align-items-start">
								                    <h6 class="mb-0">이영희 대리</h6>
								                    <small class="text-muted">어제</small>
								                </div>
								                <p class="mb-0 text-muted text-truncate" style="max-width: 90%;">
								                    재택 근무 관련 문의 드립니다.
								                </p>
								            </div>
								        </div>
								    </a> -->
								    
								</div>
				            </div>
				        </div>

				        <div class="col-xl-8 col-lg-7">
				            <div class="card shadow mb-4">
				                <div class="card-header py-3">
				                    <h6 class="m-0 font-weight-bold text-primary" id="chatWindowHeader">김철수 사원과의 대화</h6>
				                </div>
				                
				                <div class="card-body" style="height: 500px; overflow-y: auto;">
				                    
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
$(document).ready(function(){
	const currentEmpNo = $('#sessionEmpNo').val();
	if(currentEmpNo) loadConversationList(currentEmpNo);
	else $('#conversationListContainer').html('<div class="p-3 text-center text-danger">로그인 정보가 유효하지 않습니다.</div>');
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
            ? `<span class="badge bg-danger unread-count-badge ms-2">${unreadCount}</span>`
            : '';
            
        // 2. 항목 디자인 클래스 처리 (읽지 않은 메시지가 있으면 배경 강조)
        const unreadClass = unreadCount > 0 ? 'unread' : '';
        
        // 3. 시간 형식 변환 (Date 객체 -> 사람이 읽을 수 있는 형식)
        // ISO 8601 문자열을 Date 객체로 변환하여 로컬 시간으로 표시
        const date = new Date(conv.latestMessageTime); 
        const timeString = date.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
        
        // 4. HTML 항목 생성 (이전에 디자인했던 구조 사용)
        const itemHtml = `
            <a href="javascript:void(0);" 
               class="list-group-item list-group-item-action py-3 ${unreadClass}" 
               data-other-id="${conv.otherUserId}"
               onclick="loadChatWindow('${conv.otherUserId}', '${conv.otherUserName}')">
                
                <div class="d-flex align-items-center">
                    <img src="/img/profile_placeholder.png" class="rounded-circle profile-img-small" alt="프로필">
                    
                    <div class="w-100">
                        <div class="d-flex justify-content-between align-items-start">
                            <h6 class="mb-0 fw-bold d-flex align-items-center">
                                ${conv.otherUserName} (${conv.otherUserPosition}) ${unreadBadge}
                            </h6>
                            <small class="text-muted">${timeString}</small>
                        </div>
                        <p class="mb-0 text-muted text-truncate" style="max-width: 90%;">
                            ${conv.latestMessageContent}
                        </p>
                    </div>
                </div>
            </a>
        `;
        container.append(itemHtml);
    });
    
}

let currentReceiverEmpNo = null;

function loadChatWindow(otherUserId, otherUserName) {
	
	console.log("선택된 상대방:", otherUserName, otherUserId);
	
	currentReceiverEmpNo = otherUserId;
	$('.list-group-item').removeClass('active'); 
	$(`.list-group-item[data-other-id='${otherUserId}']`).addClass('active');
	$('#chatWindowHeader').text(`${otherUserName}과의 대화`);
	
	// TODO: 여기에 해당 사원과의 대화 기록을 가져오는 AJAX 코드가 들어갑니다.
}

function sendMessage(){
	
	const senderEmpNo = $('#sessionEmpNo').val();
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
    
    $.ajax({
        url: '/api/message/send',
        type: 'POST',
        // Spring이 @RequestBody로 받도록 content-type과 JSON.stringify를 사용
        contentType: 'application/json',
        data: JSON.stringify(messageData),
        dataType: 'json', // 서버가 'success' 문자열을 JSON으로 보내든 String으로 보내든 처리
        success: function(response) {
            if (response === 'success') {
                // 전송 성공 후 처리
                console.log("쪽지 전송 성공!");
                
                // 1) 입력창 비우기
                $('#messageInput').val(''); 
                
                // 2) [핵심] 채팅창 및 목록 업데이트 (추가 구현 필요)
                // - loadChatWindow(receiverEmpNo)를 다시 호출하여 새로운 메시지를 화면에 반영
                // - loadConversationList()를 다시 호출하여 왼쪽 목록의 최신 메시지/시간을 업데이트
                
            } else {
                alert("쪽지 전송에 실패했습니다.");
            }
        },
        error: function(xhr, status, error) {
            console.error("전송 오류:", status, error);
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    });
}

</script>
</html>