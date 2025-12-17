<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>PeopleSync - Dashboard</title>
    <style>
        .dashboard-card-icon {
            font-size: 3rem;
            opacity: 0.3;
            position: absolute;
            right: 20px;
            top: 20px;
        }
        .welcome-banner {
            background: linear-gradient(45deg, #212529, #343a40);
            color: white;
            border-radius: 0.5rem;
        }
        .quick-menu-item {
            transition: transform 0.2s;
            text-align: center;
            padding: 15px;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            background-color: #fff;
            margin-bottom: 15px;
            cursor: pointer;
            text-decoration: none;
            color: #495057;
            display: block;
        }
        .quick-menu-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 .5rem 1rem rgba(0,0,0,.15);
            background-color: #f8f9fa;
            color: #0d6efd;
        }
        .quick-menu-item i {
            font-size: 2rem;
            margin-bottom: 10px;
            display: block;
        }
    </style>
</head>

<body class="sb-nav-fixed">

    <jsp:include page="common/header.jsp" flush="true"/>
    
    <div id="layoutSidenav">
        
        <jsp:include page="common/sidebar.jsp" flush="true"/>

        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    
                    <div class="welcome-banner p-4 mt-4 mb-4 d-flex justify-content-between align-items-center shadow-sm">
                        <div>
                            <h1 class="display-6 fw-bold">Hello, PeopleSync!</h1>
                            <p class="lead mb-0">
                                안녕하세요, <strong>${sessionScope.login.deptName}</strong>팀 
                                <strong>${sessionScope.login.empName} ${sessionScope.login.gradeNo}</strong>님! 
                                오늘도 즐거운 하루 되세요.
                            </p>
                        </div>
                        <div class="d-none d-md-block text-end">
                            <span class="fs-5"><i class="far fa-calendar-alt me-2"></i>Today</span><br>
                            <span class="fw-bold fs-4" id="currentDate"></span>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card bg-warning text-white h-100 shadow-sm">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-white-50 small">결재 대기 문서</div>
                                            <div class="fs-1 fw-bold">${receiveWaitCount != null ? receiveWaitCount : 0}건</div>
                                        </div>
                                        <i class="fas fa-file-signature dashboard-card-icon"></i>
                                    </div>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <a class="small text-white stretched-link" href="/approve/receiveList">자세히 보기</a>
                                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card bg-primary text-white h-100 shadow-sm">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-white-50 small">진행 중인 결재</div>
                                            <div class="fs-1 fw-bold">${sendWaitCount != null ? sendWaitCount : 0}건</div>
                                        </div>
                                        <i class="fas fa-paper-plane dashboard-card-icon"></i>
                                    </div>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <a class="small text-white stretched-link" href="/approve/sendList">자세히 보기</a>
                                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card bg-success text-white h-100 shadow-sm">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-white-50 small">안 읽은 메시지</div>
                                            <div class="fs-1 fw-bold">${unreadMessageCount != null ? unreadMessageCount : 0}건</div>
                                        </div>
                                        <i class="fas fa-envelope dashboard-card-icon"></i>
                                    </div>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <a class="small text-white stretched-link" href="/message/messageList">메시지함 이동</a>
                                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <c:choose>
                                <c:when test="${myStatus eq '근무중' || myStatus eq '출근'}">
                                    <div class="card bg-success text-white h-100 shadow-sm">
                                </c:when>
                                <c:when test="${myStatus eq '퇴근' || myStatus eq '퇴근완료'}">
                                    <div class="card bg-secondary text-white h-100 shadow-sm">
                                </c:when>
                                <c:otherwise>
                                    <div class="card bg-danger text-white h-100 shadow-sm">
                                </c:otherwise>
                            </c:choose>
                            
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-white-50 small">오늘의 근태</div>
                                            <div class="fs-2 fw-bold">${myStatus}</div>
                                            <div class="mt-2 small">
                                                <i class="fas fa-clock me-1"></i> IN : ${myInTime} <br>
                                                <i class="fas fa-sign-out-alt me-1"></i> OUT : ${myOutTime}
                                            </div>
                                        </div>
                                        <i class="fas fa-user-clock dashboard-card-icon"></i>
                                    </div>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <a class="small text-white stretched-link" href="/attend/attend">근태 현황 보기</a>
                                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        
                        <div class="col-xl-8">
                            <div class="card mb-4 shadow-sm" style="min-height: 380px;">
                                <div class="card-header bg-white">
                                    <ul class="nav nav-tabs card-header-tabs" id="boardTabs" role="tablist">
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link active fw-bold" id="global-notice-tab" data-bs-toggle="tab" data-bs-target="#global-notice" type="button" role="tab" aria-selected="true">
                                                <i class="fas fa-bullhorn text-danger me-1"></i> 전체 공지
                                            </button>
                                        </li>
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link fw-bold" id="dept-notice-tab" data-bs-toggle="tab" data-bs-target="#dept-notice" type="button" role="tab" aria-selected="false">
                                                <i class="fas fa-building text-primary me-1"></i> 부서 공지
                                            </button>
                                        </li>
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link fw-bold" id="dept-free-tab" data-bs-toggle="tab" data-bs-target="#dept-free" type="button" role="tab" aria-selected="false">
                                                <i class="fas fa-comments text-success me-1"></i> 부서 게시판
                                            </button>
                                        </li>
                                    </ul>
                                </div>
                                
                                <div class="card-body">
                                    <div class="tab-content" id="boardTabsContent">
                                        
                                        <div class="tab-pane fade show active" id="global-notice" role="tabpanel" aria-labelledby="global-notice-tab">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class="small text-muted">전사 중요 공지사항입니다.</span>
                                                <a href="/board/getNoticeBoardList" class="small text-decoration-none">더보기 +</a>
                                            </div>
                                            <div class="table-responsive">
                                                <table class="table table-hover table-bordered mb-0 table-sm" style="font-size: 0.95rem;">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th style="width: 60%;">제목</th>
                                                            <th style="width: 20%;">작성자</th>
                                                            <th style="width: 20%;">작성일</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:choose>
                                                            <c:when test="${not empty noticeList}">
                                                                <c:forEach var="notice" items="${noticeList}">
                                                                    <tr>
                                                                        <td>
                                                                            <a href="/board/getNoticeBoardList" class="text-dark text-decoration-none">
                                                                                <c:if test="${notice.noticeTitle.contains('[필독]')}">
                                                                                    <span class="badge bg-danger me-1">필독</span>
                                                                                </c:if>
                                                                                ${notice.noticeTitle}
                                                                            </a>
                                                                        </td>
                                                                        <td>${notice.noticeWriter}</td>
                                                                        <td>${notice.noticeDate}</td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <tr>
                                                                    <td colspan="3" class="text-center py-4 text-muted">등록된 전체 공지가 없습니다.</td>
                                                                </tr>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>

                                        <div class="tab-pane fade" id="dept-notice" role="tabpanel" aria-labelledby="dept-notice-tab">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class="small text-muted"><strong>${sessionScope.login.deptName}</strong> 부서 공지사항입니다.</span>
                                                <a href="/board/getNoticeBoardList" class="small text-decoration-none">더보기 +</a>
                                            </div>
                                            <div class="table-responsive">
                                                <table class="table table-hover table-bordered mb-0 table-sm" style="font-size: 0.95rem;">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th style="width: 60%;">제목</th>
                                                            <th style="width: 20%;">작성자</th>
                                                            <th style="width: 20%;">작성일</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:choose>
                                                            <c:when test="${not empty deptNoticeList}">
                                                                <c:forEach var="dNotice" items="${deptNoticeList}">
                                                                    <tr>
                                                                        <td>
                                                                            <a href="/board/getNoticeBoardList" class="text-dark text-decoration-none">
                                                                                <span class="badge bg-secondary me-1">부서</span>
                                                                                ${dNotice.noticeTitle}
                                                                            </a>
                                                                        </td>
                                                                        <td>${dNotice.noticeWriter}</td>
                                                                        <td>${dNotice.noticeDate}</td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <tr>
                                                                    <td colspan="3" class="text-center py-4 text-muted">등록된 부서 공지가 없습니다.</td>
                                                                </tr>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>

                                        <div class="tab-pane fade" id="dept-free" role="tabpanel" aria-labelledby="dept-free-tab">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class="small text-muted"><strong>${sessionScope.login.deptName}</strong> 자유게시판입니다.</span>
                                                <a href="/board/getFreeBoardList" class="small text-decoration-none">더보기 +</a>
                                            </div>
                                            <div class="table-responsive">
                                                <table class="table table-hover table-bordered mb-0 table-sm" style="font-size: 0.95rem;">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th style="width: 60%;">제목</th>
                                                            <th style="width: 20%;">작성자</th>
                                                            <th style="width: 20%;">작성일</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:choose>
                                                            <c:when test="${not empty deptFreeList}">
                                                                <c:forEach var="free" items="${deptFreeList}">
                                                                    <tr>
                                                                        <td>
                                                                            <a href="/board/getFreeBoardList" class="text-dark text-decoration-none">
                                                                                ${free.boardTitle}
                                                                            </a>
                                                                        </td>
                                                                        <td>${free.boardWriter}</td>
                                                                        <td>${free.boardDate}</td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <tr>
                                                                    <td colspan="3" class="text-center py-4 text-muted">등록된 게시글이 없습니다.</td>
                                                                </tr>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>

                                    </div> </div>
                            </div>
                        </div>

                        <div class="col-xl-4">
                            <div class="card mb-4 shadow-sm" style="min-height: 380px;">
                                <div class="card-header bg-white">
                                    <i class="fas fa-rocket me-1 text-success"></i>
                                    <span class="fw-bold">빠른 실행</span>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-6">
                                            <a href="/approve/createForm" class="quick-menu-item">
                                                <i class="fas fa-pen-nib text-primary"></i>
                                                <span class="fw-bold small">기안문 작성</span>
                                            </a>
                                        </div>
                                        <div class="col-6">
                                            <a href="/attend/attend" class="quick-menu-item">
                                                <i class="fas fa-plane-departure text-warning"></i>
                                                <span class="fw-bold small">휴가 신청</span>
                                            </a>
                                        </div>
                                        <div class="col-6">
                                            <a href="/salary/myList" class="quick-menu-item">
                                                <i class="fas fa-money-check-alt text-success"></i>
                                                <span class="fw-bold small">급여 명세서</span>
                                            </a>
                                        </div>
                                        <div class="col-6">
                                            <a href="/member/list" class="quick-menu-item">
                                                <i class="fas fa-address-book text-info"></i>
                                                <span class="fw-bold small">주소록</span>
                                            </a>
                                        </div>
                                    </div>
                                    
                                    <div class="d-grid mt-3">
                                        <button class="btn btn-dark btn-sm" data-bs-toggle="modal" data-bs-target="#developerInfoModal">
                                            <i class="fas fa-code me-1"></i> Developers Info
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div> </div>
            </main>
            
            <jsp:include page="common/footer.jsp" flush="true"/>
            
            <jsp:include page="common/developer_info.jsp" flush="true"/>

        </div>
    </div>

    <script>
        const dateElement = document.getElementById('currentDate');
        const options = { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' };
        dateElement.innerText = new Date().toLocaleDateString('ko-KR', options);
    </script>
</body>
</html>