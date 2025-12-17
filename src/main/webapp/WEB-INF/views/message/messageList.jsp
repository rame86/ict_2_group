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
    <jsp:include page="../common/header.jsp" flush="true"/>
    
    <div id="layoutSidenav">
    
        <jsp:include page="../common/sidebar.jsp" flush="true"/>
        
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h3 class="mt-4">쪽지함</h3><br>
                    
                    <div class="row">
                        <div class="col-xl-3 col-lg-4">
                                
                            <div id="notificationListContainer">
                                <div class="card shadow-sm mb-3 mx-2 border-left-danger">
                                    <div class="card-header py-2 bg-primary d-flex justify-content-between align-items-center">
                                        <h6 class="m-0 small fw-bold text-white">
                                            <i class="fas fa-exclamation-triangle me-1 text-white"></i> 알림 로딩 중...
                                        </h6>
                                    </div>
                                    <div class="card-body p-3">
                                        <p class="mb-0 small text-dark">잠시만 기다려주세요.</p>
                                    </div>
                                </div>
                            </div>
                                            
                        </div>
    
                        <div class="col-xl-3 col-lg-4">
                            <div class="card shadow mb-4" style="height: 700px;">
                                <div class="card-header py-3 d-flex justify-content-between align-items-center table-Header">
                                    
                                    <h6 class="m-0 font-weight-bold">대화 목록</h6>
                                    
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
                                <div class="card-header py-3 table-Header">
                                    <h6 class="m-0 font-weight-bold" id="chatWindowHeader">대화 상대 선택</h6>
                                </div>
                                
                                <div class="card-body" style="height: 500px; overflow-y: auto;" id="messageArea">
                                    <div class="d-flex justify-content-center align-items-center h-100 text-muted">
                                        좌측 목록에서 대화 상대를 선택해주세요.
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
                        
                            <div class="modal-header table-Header">
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
                                <div></div>
                            </div>
                        </div>
                    </div>
                </div>
                <input type="hidden" id="sessionEmpNo" value="${login.empNo}">
            </main>

            <jsp:include page="../common/footer.jsp" flush="true"/>
        </div>
    </div>
</body>
<script>

let currentSubscription = null; 
let currentReceiverEmpNo = null; 

// ==========================================================
// [신규 기능] 알림 클릭 시 화면 깨짐 방지를 위한 AJAX 로드 함수
// ==========================================================
function loadDocumentDetailAjax(docNo) {
    console.log("📄 문서 상세 AJAX 로드 요청: " + docNo);
    
    // 로딩 표시 (선택사항)
    // $("#layoutSidenav_content").html('<div class="text-center mt-5"><div class="spinner-border text-primary" role="status"></div></div>');
    
    $.ajax({
        url: '/approve/documentDetail', // 조각 페이지를 반환하는 컨트롤러
        data: { docNo: docNo },
        type: "get",
        success: function(html) {
            // 전체 페이지 이동 없이 본문 영역만 교체
            $("#layoutSidenav_content").html(html);
            window.scrollTo(0, 0); // 스크롤 맨 위로
        },
        error: function(xhr, status, error) {
            console.error("문서 상세 로드 실패:", error);
            alert("문서 내용을 불러오는 데 실패했습니다.");
        }
    });
}

function createDateSeparatorHtml(dateString) {
    const date = new Date(dateString);
    const dateText = date.toLocaleDateString('ko-KR', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric', 
        weekday: 'short' 
    });
    return '<div class="text-center my-3 small text-muted">--- ' + dateText + ' ---</div>';
}

//------------------------------------
// 유틸리티 및 채팅방 로직
//------------------------------------

function getChatRoomId(id1, id2) {
    if (id1.localeCompare(id2) < 0) {
        return id1 + "_" + id2;
    } else {
        return id2 + "_" + id1;
    }
}

function renderConversationList(list) {
    console.log(list);
    const container = $('#conversationListContainer');
    container.empty();
    list.forEach(conv => {
        const unreadCount = conv.unreadCount || 0;
        const unreadBadge = unreadCount > 0 
            ? '<span class="badge bg-danger unread-count-badge">' + unreadCount + '</span>' : '';
        const unreadClass = unreadCount > 0 ? 'unread' : '';
        
        let timeString = '';
        if (conv.latestMessageTime) {
            try {
                const date = new Date(conv.latestMessageTime); 
                if (!isNaN(date.getTime())) { 
                    timeString = date.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
                } else {
                    timeString = '오류';
                }
            } catch (error) { timeString = '오류'; }
        }
      
        const positionText = conv.otherUserPosition || ''; 
        const positionHtml = positionText ? '<span class="text-muted fw-normal ms-1 conversation-position">' + positionText + '</span>' : '';
        const otherUserImagePath = CONTEXT_PATH + '/upload/emp/' + (conv.otherUserImage || 'profile_placeholder.png');
   
        const itemHtml = 
            '<a href="javascript:void(0);" ' + 
            'class="list-group-item list-group-item-action py-3 ' + unreadClass + '" ' + 
            'data-other-name="' + conv.otherUserName + '" ' +
            'data-other-id="' + conv.otherUserId + '" ' + 
            'onclick="loadChatWindow(\'' + conv.otherUserId + '\', \'' + conv.otherUserName + '\')">' + 
                '<div class="d-flex align-items-center">' +
                    '<img src="'+ otherUserImagePath +'" class="rounded-circle profile-img-small" alt="프로필">' +
                    '<div class="w-100">' +
                        '<div class="d-flex justify-content-between align-items-center">' +
                            '<h6 class="mb-1 fw-bold d-flex align-items-center conversation-name">' + 
                              conv.otherUserName + positionHtml + 
                            '</h6>' +
                            '<small class="text-muted text-nowrap conversation-time">' + timeString + '</small>' +
                        '</div>' +
                        '<div class="d-flex justify-content-between align-items-center">' +
                            '<p class="mb-0 text-muted text-truncate conversation-message" style="max-width: 90%;">' +
                                 conv.latestMessageContent +
                            '</p>' +
                        (unreadCount > 0 ? unreadBadge : '') +
                        '</div>' +
                    '</div>' +
                '</div>' +
            '</a>';
        container.append(itemHtml);
    });
}

function loadChatWindow(otherUserId, otherUserName) {
    if (!stompClient || stompClient.ws.readyState !== WebSocket.OPEN) { 
        console.warn("STOMP 연결 대기 중...");
        setTimeout(() => loadChatWindow(otherUserId, otherUserName), 200);
        return; 
    }
    
    // 메세지 읽음 처리
    $.ajax({
        url: '/chat/markAsRead',
        type: 'POST',
        xhrFields: { withCredentials: true },
        data: { otherUserId: otherUserId },
        success: function(response) {
            if (response === "success") {
                loadConversationList($('#sessionEmpNo').val()); 
            }
        }
    });

    $('#chatWindowHeader').text(otherUserName + '님과의 대화');
    currentReceiverEmpNo = otherUserId;
    
    $('.list-group-item').removeClass('active'); 
    $(`.list-group-item[data-other-id="${otherUserId}"]`).addClass('active');
    
    const chatContainer = $('#messageArea');
    chatContainer.empty();
    chatContainer.html('<div class="p-5 text-center text-muted">메시지 로딩 중...</div>');

    // STOMP 구독 갱신
    if (stompClient && stompClient.connected && currentSubscription) {
        currentSubscription.unsubscribe();
        currentSubscription = null;
    } else if (currentSubscription) {
        currentSubscription = null;
    }
 
    const myEmpNo = $('#sessionEmpNo').val(); 
    const chatRoomId = getChatRoomId(myEmpNo, otherUserId);
    const roomTopic = '/topic/chat/room/' + chatRoomId;
 
    if (stompClient && stompClient.connected) { 
        currentSubscription = stompClient.subscribe(roomTopic, function(messageOutput) {
            const messageVO = JSON.parse(messageOutput.body);
            appendNewMessageToChat(messageVO, myEmpNo);
        });
    }
 
    $.ajax({
        url: '/api/message/chat/' + otherUserId, 
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            renderChatMessages(response.messages, otherUserId);
            chatContainer.scrollTop(chatContainer[0].scrollHeight);
        },
        error: function(xhr) {
            chatContainer.html('<div class="p-5 text-center text-danger">대화 내용을 불러오는데 실패했습니다.</div>');
        }
    });
}

function renderChatMessages(messages, currentOtherUserId) {
    const chatContainer = $('#messageArea');
    chatContainer.empty(); 
 
    const myUserId = '${login.empNo}';
    if (!messages || messages.length === 0) {
        chatContainer.html('<div class="p-5 text-center text-muted">아직 대화가 없습니다. 새로운 메시지를 보내보세요!</div>');
        return;
    }
    
    const defaultImageSrc = CONTEXT_PATH + '/img/profile_placeholder.png';
    const $otherUserListItem = $(".list-group-item[data-other-id='" + currentOtherUserId + "']");
    const otherUserImageFile = $otherUserListItem.find('img').attr('src');
    
    let otherUserImageSrc = otherUserImageFile ? otherUserImageFile : defaultImageSrc;
    
    let lastDate = null;
    let lastSenderId = null;

    messages.forEach(message => {
        const currentDateString = new Date(message.sendDate).toDateString();
        if (currentDateString !== lastDate) {
            chatContainer.append(createDateSeparatorHtml(message.sendDate));
            lastSenderId = null;
        }
        lastDate = currentDateString;
        
        const isMyMessage = (message.senderEmpNo === myUserId);
        const showImage = !isMyMessage && (message.senderEmpNo !== lastSenderId);
        
        const alignmentClass = isMyMessage ? 'justify-content-end' : 'justify-content-start';
        const bubbleClass = isMyMessage ? 'bg-primary text-white' : 'bg-light';
        const timeAlignmentClass = isMyMessage ? 'text-end' : 'text-start';
     
        let timeString = '';
        if (message.sendDate) {
            const date = new Date(message.sendDate);
            if (!isNaN(date.getTime())) {
                timeString = date.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
            }
        }
        
        const profileImageHtml = showImage 
            ? '<img src="' + otherUserImageSrc + '" class="rounded-circle" style="width: 35px; height: 35px; margin-right: 8px;" alt="프로필">'
            : '<div style="width: 35px; height: 35px; margin-right: 8px;"></div>';

        const messageHtml =
            '<div class="d-flex ' + alignmentClass + ' mb-3">' +
            (!isMyMessage ? profileImageHtml : '') +
                '<div class="message-bubble-container" style="display: inline-block; max-width: 70%;">' + 
                    '<div class="message-bubble p-2 rounded ' + bubbleClass + '">' +
                        message.msgContent + 
                    '</div>' +
                    '<div class="' + timeAlignmentClass + ' text-muted small mt-1">' + timeString +
                    '</div>' +
                '</div>' +
            '</div>';
        chatContainer.append(messageHtml);
        lastSenderId = message.senderEmpNo;
    });
}

function sendMessage(){
    const content = $('#messageInput').val().trim();
    const receiverEmpNo = currentReceiverEmpNo;
    const myEmpNo = $('#sessionEmpNo').val();

    if (!stompClient || stompClient.ws.readyState !== WebSocket.OPEN) { 
        alert("메시지 시스템이 아직 연결 중입니다. 잠시 후 다시 시도해 주세요.");
        return;
    }
     if (!content) { alert("메시지 내용을 입력해 주세요."); return; }
     if (!receiverEmpNo) { alert("대화 상대를 먼저 선택해 주세요."); return; }
        
     const messageData = { receiverEmpNo: receiverEmpNo, msgContent: content };
     stompClient.send("/app/chat/send", {}, JSON.stringify(messageData));
    $('#messageInput').val('');
    
    setTimeout(function() { loadConversationList(myEmpNo); }, 200);
}

function appendNewMessageToChat(messageVO, myEmpNo) {
    const chatContainer = $('#messageArea');
    const isMyMessage = messageVO.senderEmpNo === myEmpNo;
    const alignmentClass = isMyMessage ? 'justify-content-end' : 'justify-content-start';
    const bubbleClass = isMyMessage ? 'bg-primary text-white' : 'bg-light';
    const timeAlignmentClass = isMyMessage ? 'text-end' : 'text-start';
 
    let timeString = '';
    let dateObj = (messageVO.sendDate instanceof Date) ? messageVO.sendDate : new Date(messageVO.sendDate);
    
    if (!isNaN(dateObj.getTime())) {
        timeString = dateObj.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
    } else {
        timeString = isMyMessage ? new Date().toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' }) : '시간 정보 없음';
    }
    
    const $lastMessage = chatContainer.children('.d-flex').last();
    const isLastMessageFromOther = $lastMessage.length > 0 && $lastMessage.hasClass('justify-content-start');
    const showImage = !isMyMessage && !isLastMessageFromOther;
    
    const currentOtherUserId = currentReceiverEmpNo;
    const defaultImageSrc = CONTEXT_PATH + '/img/profile_placeholder.png';
    const $otherUserListItem = $(".list-group-item[data-other-id='" + currentOtherUserId + "']");
    const otherUserImageFile = $otherUserListItem.find('img').attr('src');
    let otherUserImageSrc = otherUserImageFile ? otherUserImageFile : defaultImageSrc;

    let profileImageHtml = '';
    if (!isMyMessage) {
        if (showImage) {
             profileImageHtml = '<img src="' + otherUserImageSrc + '" class="rounded-circle" style="width: 35px; height: 35px; margin-right: 8px;" alt="프로필">';
        } else {
             profileImageHtml = '<div style="width: 35px; height: 35px; margin-right: 8px;"></div>';
        }
    }
 
    const messageHtml =
        '<div class="d-flex ' + alignmentClass + ' mb-3">' +
        (!isMyMessage ? profileImageHtml : '') + 
        '<div class="message-bubble-container" style="display: inline-block; max-width: 70%;">' + 
             '<div class="message-bubble p-2 rounded ' + bubbleClass + '">' + 
                 messageVO.msgContent + 
             '</div>' +
             '<div class="' + timeAlignmentClass + ' text-muted small mt-1">' + timeString +
             '</div>' +
         '</div>' +
     '</div>';
     
    chatContainer.append(messageHtml);
    chatContainer.scrollTop(chatContainer[0].scrollHeight);

    if (!isMyMessage && currentReceiverEmpNo) {
        $.ajax({
            url: '/chat/markAsRead',
            type: 'POST',
            data: { otherUserId: currentReceiverEmpNo },
            success: function(response) {
                if (response === "success") { loadConversationList(myEmpNo); }
            }
        });
    }
}

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
        error: function(xhr) {
            resultsContainer.html('<div class="p-3 text-danger text-center">검색 중 오류가 발생했습니다.</div>');
        }
    });
}

function renderSearchResults(employees, container) {
    container.empty();
    if (!employees || employees.length === 0) {
        container.html('<div class="p-3 text-muted text-center">검색 결과가 없습니다.</div>');
        return;
    }
    
    const myEmpNo = $('#sessionEmpNo').val();
    const defaultImagePath = CONTEXT_PATH + '/img/profile_placeholder.png';
    
    employees.forEach(emp => {
        if (emp.empNo === myEmpNo) return; 
        
        const profileImagePath = (emp.empImage && emp.empImage !== 'null')
            ? CONTEXT_PATH + '/upload/emp/' + emp.empImage : defaultImagePath;

        const itemHtml = 
            '<a href="javascript:void(0);" ' + 
            'class="list-group-item list-group-item-action py-3 pe-3" ' + 
            'onclick="selectAndStartChat(\'' + emp.empNo + '\', \'' + emp.empName + '\')">' + 
                '<div class="d-flex align-items-center justify-content-between">' + 
                    '<div class="d-flex align-items-center me-2" style="width: 50%; min-width: 50%; flex-shrink: 0;">' + 
                        '<img src="' + profileImagePath + '" class="rounded-circle" style="width: 35px; height: 35px; margin-right: 10px;" alt="프로필">' +
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

function selectAndStartChat(empNo, empName) {
    loadChatWindow(empNo, empName);
    const newChatModal = bootstrap.Modal.getInstance(document.getElementById('newChatModal'));
    if (newChatModal) { newChatModal.hide(); } else { $('#newChatModal').modal('hide'); }
}


$(document).ready(function() {
    $('#newChatModal').on('shown.bs.modal', function () {
        searchAndRenderEmployees(''); 
        $('#employeeSearchInput').val('');
    });
    
    $('#searchEmployeeBtn').on('click', function() { searchAndRenderEmployees(); });
    $('#employeeSearchInput').on('input', function() { searchAndRenderEmployees($(this).val()); });
    $('#messageInput').on('keypress', function(e) {
        if (e.which === 13) { e.preventDefault(); sendMessage(); }
    });

    if (typeof loadNotificationList === 'function') {
        loadNotificationList();
    } else {
        console.error("loadNotificationList 함수가 정의되지 않았습니다.");
    }
});

// ==========================================================
// [수정] renderNotifications 함수: 링크 이동 대신 AJAX 호출 및 팝업 사용
// ==========================================================
function renderNotifications(notifications) {
    console.log("🎨 [RENDER] 알림 목록:", notifications);
    const container = $('#notificationListContainer');
    container.empty();
    
    if (!notifications || notifications.length === 0) {
        container.html('<div class="p-3 text-center text-muted">새로운 알림이 없습니다.</div>');
        return;
    }

    notifications.forEach(noti => {
        let targetLink = 'javascript:void(0);';
        let clickAction = '';
        const context = CONTEXT_PATH || '';

        // 클릭 시 동작 결정
        if (noti.linkId) {
            if (noti.linkType === 'APPROVAL') {
                const status = noti.alertStatus;
                
                if (status === 'REQUEST') {
                    // [결재 요청] -> 페이지 이동 막고 AJAX로 상세 내용 로드
                    clickAction = "loadDocumentDetailAjax(" + noti.linkId + ");";
                    
                } else if (status === 'FINAL_APPROVAL' || status === 'REJECT' || status === 'IN_PROGRESS') {
                    // [결과 알림] -> 팝업으로 띄우기 (페이지 깨짐 방지)
                    clickAction = "window.open('" + context + "/approve/documentDetailPopup?docNo=" + noti.linkId + "', 'detailPopup', 'width=800,height=900,scrollbars=yes');";
                    
                } else {
                     // 기본 -> AJAX 로드
                     clickAction = "loadDocumentDetailAjax(" + noti.linkId + ");";
                }
            } else if (noti.linkType === 'BOARD') {
                // 게시판은 일반 이동
                targetLink = context + '/board/detail?boardNo=' + noti.linkId;
            }
        }
        
        const alertIdValue = noti.alertId || noti.ALERT_ID || noti.id || '0';
        const isRead = noti.isRead === 'Y'; 
        const cardBorderClass = isRead ? 'border-left-secondary' : 'border-left-danger';
        const headerBgClass = isRead ? 'bg-light' : 'bg-primary';
        const headerTextColor = isRead ? 'text-muted' : 'text-white';
        const bodyTextColor = isRead ? 'text-muted' : 'text-dark';
        const headerText = isRead ? '확인됨' : '미확인 알림';
        const iconColor = isRead ? 'text-dark' : 'text-white';
        const iconClass = noti.linkType === 'APPROVAL' ? 'fas fa-exclamation-triangle' : 'fas fa-info-circle';

        const itemHtml = 
            '<div class="card shadow-sm mb-3 mx-2 ' + cardBorderClass + '" data-noti-id="' + alertIdValue + '">' +
                '<div class="card-header py-2 ' + headerBgClass + ' d-flex justify-content-between align-items-center">' +
                    '<h6 class="m-0 small fw-bold ' + headerTextColor + '">' +
                        '<i class="' + iconClass + ' me-1 ' + iconColor + '"></i>' + headerText +
                    '</h6>' +
                    '<div class="d-flex align-items-center">' +
                        '<small class="m-0 ' + headerTextColor + ' me-2">' + formatTime(noti.createdDate) + '</small>' +
                        '<button class="btn btn-sm p-0 ' + headerTextColor + '" onclick="deleteNotification(\'' + alertIdValue + '\', event)" title="알림 삭제">' +
                            '<i class="fas fa-times"></i>' +
                        '</button>' +
                    '</div>' +
                '</div>' +
                
                // [핵심] href는 무효화하고 onclick에 동작 연결
                '<a href="' + targetLink + '" ' + 
                'class="card-body p-3 text-decoration-none" ' + 
                'onclick="markOneNotificationAsRead(this, event); ' + clickAction + '">' +
                '<div>' + 
                    '<div class="small text-muted mb-1">' + noti.senderName + '</div>' + 
                    '<p class="mb-0 fw-bold small ' + bodyTextColor + '">' + (noti.content || '내용 없음') + '</p>' +
                '</div>' +
                '</a>' +
            '</div>';
        container.append(itemHtml);
    });
}

function formatTime(sendDate) {
    if (!sendDate) return '';
    try {
        const now = new Date();
        const sent = new Date(sendDate);
        const diffInSeconds = Math.floor((now - sent) / 1000);
        if (diffInSeconds < 60) return '방금 전';
        else if (diffInSeconds < 3600) return Math.floor(diffInSeconds / 60) + '분 전';
        else if (diffInSeconds < 86400) return Math.floor(diffInSeconds / 3600) + '시간 전';
        else if (diffInSeconds < 604800) return Math.floor(diffInSeconds / 86400) + '일 전';
        else return sent.toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' }).replace(/\./g, '.');
    } catch (e) { return sendDate; }
}

function markOneNotificationAsRead(element, event) {
    const $card = $(element).closest('.card');
    const notiId = $card.data('noti-id');
    if (notiId) {
        $.ajax({
            url: '/alert/markAsRead', 
            type: 'POST',
            data: { notificationId: notiId },
            success: function(response) {
                $card.removeClass('border-left-danger');
                $card.find('.card-header').removeClass('bg-primary').addClass('bg-light');
                $card.find('.card-header h6').removeClass('text-white').addClass('text-muted');
                $card.find('.card-header i').removeClass('text-white').addClass('text-dark');
                $card.find('.card-header small').removeClass('text-white').addClass('text-muted');
                $card.find('.card-body p').removeClass('text-dark').addClass('text-muted');
                $card.find('.card-header h6').html('<i class="fas fa-info-circle me-1 text-dark"></i> 확인됨');
                if (typeof updateHeaderAlertsBadge === 'function') { updateHeaderAlertsBadge(); }
            }
        });
    }
}

function deleteNotification(notiId, event) {
    if (event) { event.preventDefault(); event.stopPropagation(); }
    if (!notiId || notiId === 'undefined') return;
    if (!confirm("이 알림을 삭제하시겠습니까?")) return;
    
    const $card = $('div.card[data-noti-id="' + notiId + '"]');
    $.ajax({
        url: '/alert/delete', type: 'POST', data: { alertId : notiId },
        success: function(response) {
            if (response === "success") {
                $card.fadeOut(300, function() {
                    $(this).remove();
                    if (typeof loadNotificationList === 'function') { loadNotificationList(); }
                    if (typeof updateHeaderAlertsBadge === 'function') { updateHeaderAlertsBadge(); }
                });
            }
        },
        error: function() { alert("알림 삭제에 실패했습니다."); }
    });
}

function loadNotificationList() {
    const $listContainer = $('#notificationListContainer'); 
    $listContainer.html('<div class="p-3 text-center text-primary">알림 목록을 불러오는 중...</div>');
    $.ajax({
        url: '/alert/allLatestView', type: 'GET', dataType: 'json',
        success: function(notifications) {
            if (typeof renderNotifications === 'function') { renderNotifications(notifications); }
        },
        error: function() { $listContainer.html('<div class="p-3 text-center text-danger">알림 목록 로드 실패</div>'); }
    });
}

</script>
</html>