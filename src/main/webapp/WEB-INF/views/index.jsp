<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>PeopleSync - Dashboard</title>
    
    <style>
        /* [기존 대시보드 스타일 유지] */
        .dashboard-card-icon { font-size: 3rem; opacity: 0.3; position: absolute; right: 20px; top: 20px; }
        .welcome-banner { background: linear-gradient(45deg, #212529, #343a40); color: white; border-radius: 0.5rem; }
        .quick-menu-container { background-color: #fff; border-radius: 8px; padding: 20px; box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); }
        .quick-menu-item { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 15px; border: 1px solid #e9ecef; border-radius: 12px; background-color: #f8f9fa; text-decoration: none; color: #495057; transition: all 0.3s ease; height: 100%; }
        .quick-menu-item:hover { transform: translateY(-5px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); background-color: #fff; border-color: #0d6efd; color: #0d6efd; }
        .quick-menu-item i { font-size: 2rem; margin-bottom: 10px; }
        
        /* 프로필 카드 스타일 */
        .profile-card { background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15); text-align: center; padding: 30px 20px; }
        .profile-img-container { width: 140px; height: 140px; margin: 0 auto 20px; border-radius: 50%; padding: 5px; border: 3px solid #e3e6f0; overflow: hidden; position: relative; }
        .profile-img { width: 100%; height: 100%; object-fit: cover; border-radius: 50%; }
        .profile-name { font-size: 1.5rem; font-weight: 800; color: #2e384d; margin-bottom: 5px; }
        .profile-dept { color: #858796; font-size: 0.95rem; margin-bottom: 15px; }
        .profile-badge { display: inline-block; padding: 6px 15px; background-color: #4e73df; color: white; border-radius: 20px; font-size: 0.85rem; font-weight: 600; }
        .profile-info-row { margin-top: 25px; display: flex; justify-content: space-around; border-top: 1px solid #eaecf4; padding-top: 20px; }
        .profile-info-item h6 { color: #b7b9cc; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; margin-bottom: 5px; }
        .profile-info-item span { color: #5a5c69; font-weight: 700; font-size: 1.1rem; }

        /* ---------------------------------------------------------------------------------- */
        /* [중요] 게시판 모달 및 프로필 이미지 스타일 추가 */
        /* ---------------------------------------------------------------------------------- */
        #boardModal .modal-content {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        #boardModal .modal-header {
            border-bottom: none; 
            padding-bottom: 0;   
        }

        #boardModal .modal-body {
            padding: 20px 30px; 
        }

        /* 제목 영역 */
        .view-title {
            font-size: 1.5rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
            border-left: 5px solid #0d6efd; 
            padding-left: 15px;
        }

        /* 작성자 및 날짜 정보 박스 */
        .view-info-box {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 10px 15px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid #e9ecef;
        }

        .info-item {
            font-size: 0.9rem;
            color: #666;
            display: flex;
            align-items: center;
        }

        .info-item i {
            margin-right: 5px;
            color: #adb5bd;
        }

        /* [NEW] 작성자/댓글 프로필 이미지 스타일 */
        .writer-profile-img {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 8px;
            border: 1px solid #dee2e6;
        }

        .comment-profile-img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 15px;
            border: 1px solid #dee2e6;
        }

        /* 본문 영역 */
        .view-content-box {
            min-height: 200px;
            background-color: white;
            padding: 20px;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05);
            white-space: pre-wrap;
            line-height: 1.6;
            color: #444;
            margin-bottom: 20px;
        }

        /* 댓글 영역 스타일 */
        .comment-section {
            margin-top: 20px;
            border-top: 1px solid #eee;
            padding-top: 20px;
        }

        .comment-card {
            background-color: #fcfcfc;
            border: 1px solid #f1f1f1;
            border-radius: 8px;
            padding: 10px;
            margin-bottom: 10px;
            text-align: left; 
        }
        
        /* 대시보드 프로필 사진 클릭 가능 표시 */
		#dashboardProfileImg {
		    cursor: pointer;
		    transition: transform 0.2s;
		}
		#dashboardProfileImg:hover {
		    transform: scale(1.05);
		    opacity: 0.9;
		}
		
		/* 모달 내 프로필 이미지 컨테이너 */
		.modal-profile-container {
		    position: relative;
		    display: inline-block;
		    width: 100%;
		    text-align: center;
		    background-color: #f8f9fa;
		    border-radius: 10px;
		    padding: 20px;
		}
		
		/* 모달 내 이미지 */
		.modal-profile-img-preview {
		    max-width: 100%;
		    max-height: 400px;
		    object-fit: contain;
		    border-radius: 8px;
		    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
		}
		
		/* 이미지 수정 버튼 (반투명 오버레이) */
		.btn-edit-photo-overlay {
		    position: absolute;
		    bottom: 30px;
		    left: 50%;
		    transform: translateX(-50%);
		    background-color: rgba(0, 0, 0, 0.6); /* 반투명 검정 */
		    color: white;
		    border: 1px solid rgba(255, 255, 255, 0.5);
		    padding: 8px 20px;
		    border-radius: 30px;
		    font-size: 0.9rem;
		    transition: all 0.3s;
		    backdrop-filter: blur(2px);
		}
		
		.btn-edit-photo-overlay:hover {
		    background-color: rgba(0, 0, 0, 0.85);
		    color: #fff;
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
                                <strong>${sessionScope.login.empName}</strong>님!
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
                                            <div class="fs-2 fw-bold">${receiveWaitCount != null ? receiveWaitCount : 0}건</div>
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
                                            <div class="fs-2 fw-bold">${sendWaitCount != null ? sendWaitCount : 0}건</div>
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
                                            <div class="fs-2 fw-bold">${unreadMessageCount != null ? unreadMessageCount : 0}건</div>
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
                                        <li class="nav-item">
                                            <button class="nav-link active fw-bold" id="global-notice-tab" data-bs-toggle="tab" data-bs-target="#global-notice" type="button">
                                                <i class="fas fa-bullhorn text-danger me-1"></i> 전체 공지
                                            </button>
                                        </li>
                                        <li class="nav-item">
                                            <button class="nav-link fw-bold" id="dept-notice-tab" data-bs-toggle="tab" data-bs-target="#dept-notice" type="button">
                                                <i class="fas fa-building text-primary me-1"></i> 부서 공지
                                            </button>
                                        </li>
                                        <li class="nav-item">
                                            <button class="nav-link fw-bold" id="dept-free-tab" data-bs-toggle="tab" data-bs-target="#dept-free" type="button">
                                                <i class="fas fa-comments text-success me-1"></i> 부서 게시판
                                            </button>
                                        </li>
                                    </ul>
                                </div>
                                
                                <div class="card-body">
                                    <div class="tab-content" id="boardTabsContent">
                                        <div class="tab-pane fade show active" id="global-notice">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class="small text-muted">전사 중요 공지사항입니다.</span>
                                                <a href="/board/getNoticeBoardList" class="small text-decoration-none">더보기 +</a>
                                            </div>
                                            <table class="table table-hover table-bordered mb-0 table-sm" style="font-size: 0.95rem;">
                                                <thead class="table-light"><tr><th style="width: 60%;">제목</th><th style="width: 20%;">작성자</th><th style="width: 20%;">작성일</th></tr></thead>
                                                <tbody>
                                                    <c:choose>
                                                        <c:when test="${not empty noticeList}">
                                                            <c:forEach var="notice" items="${noticeList}">
                                                                <tr>
                                                                    <td>
                                                                        <a href="#" class="text-dark text-decoration-none"
                                                                           data-bs-toggle="modal" data-bs-target="#boardModal" 
                                                                           data-no="${notice.noticeNo}" 
                                                                           data-title="<c:out value='${notice.noticeTitle}'/>" 
                                                                           data-writer="${notice.noticeWriter}"
                                                                           data-date="${notice.noticeDate}"
                                                                           data-type="global-notice">
                                                                             <span class="badge bg-danger me-1">전체</span>${notice.noticeTitle}
                                                                        </a>
                                                                    </td>
                                                                    <td>${notice.noticeWriter}</td>
                                                                    <td>${notice.noticeDate}</td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise><tr><td colspan="3" class="text-center py-4 text-muted">등록된 공지가 없습니다.</td></tr></c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                            </table>
                                        </div>
                                       
                                        <div class="tab-pane fade" id="dept-notice">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class="small text-muted">우리 부서 중요 공지입니다.</span>
                                                <a href="/board/getNoticeBoardList" class="small text-decoration-none">더보기 +</a>
                                            </div>
                                            <table class="table table-hover table-bordered mb-0 table-sm" style="font-size: 0.95rem;">
                                                <thead class="table-light"><tr><th style="width: 60%;">제목</th><th style="width: 20%;">작성자</th><th style="width: 20%;">작성일</th></tr></thead>
                                                <tbody>
                                                    <c:choose>
                                                        <c:when test="${not empty deptNoticeList}">
                                                            <c:forEach var="dNotice" items="${deptNoticeList}">
                                                                <tr>
                                                                    <td>
                                                                        <a href="#" class="text-dark text-decoration-none"
                                                                           data-bs-toggle="modal" data-bs-target="#boardModal" 
                                                                           data-no="${dNotice.noticeNo}" 
                                                                           data-title="<c:out value='${dNotice.noticeTitle}'/>" 
                                                                           data-writer="${dNotice.noticeWriter}"
                                                                           data-date="${dNotice.noticeDate}"
                                                                           data-type="dept-notice">
                                                                             <span class="badge bg-primary me-1">부서</span>${dNotice.noticeTitle}
                                                                        </a>
                                                                    </td>
                                                                    <td>${dNotice.noticeWriter}</td>
                                                                    <td>${dNotice.noticeDate}</td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise><tr><td colspan="3" class="text-center py-4 text-muted">등록된 부서 공지가 없습니다.</td></tr></c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                            </table>
                                        </div>

                                        <div class="tab-pane fade" id="dept-free">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class="small text-muted">자유롭게 소통하는 공간입니다.</span>
                                                <a href="/board/getFreeBoardList" class="small text-decoration-none">더보기 +</a>
                                            </div>
                                            <table class="table table-hover table-bordered mb-0 table-sm" style="font-size: 0.95rem;">
                                                <thead class="table-light"><tr><th style="width: 60%;">제목</th><th style="width: 20%;">작성자</th><th style="width: 20%;">작성일</th></tr></thead>
                                                <tbody>
                                                    <c:choose>
                                                        <c:when test="${not empty deptFreeList}">
                                                            <c:forEach var="free" items="${deptFreeList}">
                                                                <tr>
                                                                    <td>
                                                                        <a href="#" class="text-dark text-decoration-none"
                                                                           data-bs-toggle="modal" data-bs-target="#boardModal" 
                                                                           data-no="${free.boardNo}" 
                                                                           data-title="<c:out value='${free.boardTitle}'/>" 
                                                                           data-writer="${free.boardWriter}"
                                                                           data-date="${free.boardDate}"
                                                                           data-type="dept-free">
                                                                             <span class="badge bg-success me-1">자유</span>${free.boardTitle}
                                                                        </a>
                                                                    </td>
                                                                    <td>${free.boardWriter}</td>
                                                                    <td>${free.boardDate}</td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise><tr><td colspan="3" class="text-center py-4 text-muted">등록된 게시글이 없습니다.</td></tr></c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div> 
                                </div>
                            </div>

                            <div class="quick-menu-container mb-4">
                                <h6 class="fw-bold mb-3 text-secondary"><i class="fas fa-rocket me-2"></i>Quick Access</h6>
                                <div class="row g-3">
                                    <div class="col-md-3 col-6">
                                        <a href="/approve/createForm" class="quick-menu-item">
                                            <i class="fas fa-pen-nib text-primary"></i>
                                            <span class="fw-bold small">기안문 작성</span>
                                        </a>
                                    </div>
                                    <div class="col-md-3 col-6">
                                        <a href="/attend/attend" class="quick-menu-item">
                                            <i class="fas fa-plane-departure text-warning"></i>
                                            <span class="fw-bold small">휴가 신청</span>
                                        </a>
                                    </div>
                                    <div class="col-md-3 col-6">
                                        <a href="${pageContext.request.contextPath}/sal/list" class="quick-menu-item">
                                            <i class="fas fa-money-check-alt text-success"></i>
                                            <span class="fw-bold small">급여 명세서</span>
                                        </a>
                                    </div>
                                    <div class="col-md-3 col-6">
                                        <a href="#" class="quick-menu-item" data-bs-toggle="modal" data-bs-target="#deptAddressModal">
                                            <i class="fas fa-address-book text-info"></i>
                                            <span class="fw-bold small">주소록</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-4">
                            <div class="profile-card mb-4">
							    <div class="profile-img-container">
							        <img id="dashboardProfileImg" 
							            src="${pageContext.request.contextPath}/images/default_profile.png" 
							             class="profile-img" alt="프로필 사진">
							    </div>
							    
							    <h3 class="profile-name">${sessionScope.login.empName}</h3>
							    <p class="profile-dept">
							        ${sessionScope.login.deptName} / ${sessionScope.login.empNo}
							    </p>
							
							    <div class="mb-3">
							        <span class="profile-badge">
							            <i class="fas fa-crown me-1"></i>
							            권한 등급 : ${sessionScope.login.gradeNo} 등급
							        </span>
							    </div>
							    
							    <div class="profile-info-row">
							        <div class="profile-info-item">
							            <h6>Status</h6>
							            <span>
							                <c:choose>
							                    <c:when test="${sessionScope.login.statusNo == 1}">재직</c:when>
							                    <c:when test="${sessionScope.login.statusNo == 7}">파견</c:when>
							                    <c:when test="${sessionScope.login.statusNo == 2}">휴직(자발적)</c:when>
							                    <c:when test="${sessionScope.login.statusNo == 3}">휴직(복지)</c:when>
							                    <c:when test="${sessionScope.login.statusNo == 4}">대기</c:when>
							                    <c:when test="${sessionScope.login.statusNo == 5}">징계</c:when>
							                    <c:when test="${sessionScope.login.statusNo == 6}">인턴/수습</c:when>
							                    <c:when test="${sessionScope.login.statusNo == 0}">퇴직</c:when>
							                    <c:otherwise>기타</c:otherwise>
							                </c:choose>
							            </span>
							        </div>
							
							        <div class="profile-info-item">
							            <h6>Position</h6>
							            <span>
							                <%-- 수정됨: gradeNo 삼항연산자 대신 jobTitle 사용 --%>
							                ${sessionScope.login.jobTitle}
							            </span>
							        </div>
							    </div>
							
							    <div class="d-grid mt-4">
							        <button class="btn btn-outline-primary btn-sm" onclick="location.href='/attend/attend'">
							            <i class="fas fa-cog me-1"></i> 근태/설정 관리
							        </button>
							    </div>
							</div>

                            <div class="card mb-4 shadow-sm">
                                <div class="card-body py-3">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div>
                                            <h6 class="mb-0 fw-bold">추가기능 공사중</h6>
                                            <small class="text-muted">서버 점검 예정 (12/25)</small>
                                        </div>
                                        <i class="fas fa-info-circle text-info fs-4"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div> 
                </div>
                
                <div class="modal fade" id="deptAddressModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                        <div class="modal-content border-0 shadow-lg">
                            <div class="modal-header bg-info text-white">
                                <h5 class="modal-title fw-bold"><i class="fas fa-building me-2"></i>사내 부서 주소록</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body p-4">
                                <div class="input-group mb-3">
                                    <span class="input-group-text bg-light border-end-0"><i class="fas fa-search text-muted"></i></span>
                                    <input type="text" id="deptSearchInput" class="form-control border-start-0" placeholder="부서명 또는 번호를 검색하세요...">
                                </div>
                                <div class="table-responsive" style="max-height: 500px; overflow-y: auto;">
                                    <table class="table table-hover align-middle" id="deptAddressTable">
                                        <thead class="table-light sticky-top">
                                            <tr>
                                                <th style="width: 25%;">부서명 (번호)</th>
                                                <th style="width: 45%;">주소</th>
                                                <th style="width: 30%;">연락처</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${not empty deptList}">
                                                    <c:forEach var="dept" items="${deptList}">
                                                        <tr>
                                                            <td>
                                                                <div class="fw-bold text-dark">${dept.deptName}</div>
                                                                <span class="badge bg-secondary rounded-pill" style="font-size: 0.75rem;">Code: ${dept.deptNo}</span>
                                                            </td>
                                                            <td>
                                                                <div class="text-secondary small">
                                                                    <i class="fas fa-map-marker-alt me-1 text-danger opacity-50"></i>
                                                                    ${empty dept.deptAddr ? '<span class="text-muted">-</span>' : dept.deptAddr}
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="d-flex align-items-center">
                                                                    <div class="icon-circle bg-success bg-opacity-10 text-success me-2" style="width:30px; height:30px; border-radius:50%; display:flex; align-items:center; justify-content:center;">
                                                                        <i class="fas fa-phone-alt" style="font-size:0.8rem;"></i>
                                                                    </div>
                                                                    <span class="fw-bold text-dark">${empty dept.deptPhone ? '<span class="text-muted small">미등록</span>' : dept.deptPhone}</span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise><tr><td colspan="3" class="text-center py-5 text-muted"><i class="fas fa-exclamation-circle fa-2x mb-3"></i><br>등록된 부서 정보가 없습니다.</td></tr></c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="modal-footer bg-light">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="boardModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-scrollable">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">

                                <div class="view-title" id="modalTitleText">제목 로딩중...</div>

                                <div class="view-info-box">
                                    <span class="info-item"> 
                                        <img id="modalWriterImg" src="${pageContext.request.contextPath}/images/default_profile.png" class="writer-profile-img" alt="작성자">
                                        <span id="modalWriterText">작성자</span>
                                    </span> 
                                    <span class="info-item"> 
                                        <i class="far fa-clock"></i> <span id="modalDateText">0000-00-00</span>
                                    </span>
                                </div>

                                <div id="modalContentText" class="view-content-box">내용 로딩중...</div>

                                <div class="d-flex justify-content-between align-items-center mt-4">
                                    <button class="btn btn-outline-secondary" type="button" id="btnToggleComment" data-bs-toggle="collapse" data-bs-target="#collapseComments" aria-expanded="false" aria-controls="collapseComments">
                                        <i class="far fa-comment-dots me-1"></i> 댓글
                                    </button>
                                    <div>
                                        <input type="hidden" id="currentNoticeNo">
                                        <input type="hidden" id="currentBoardNo">
                                        <input type="hidden" id="currentBoardType">
                                        
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                                    </div>
                                </div>

                                <div class="collapse comment-section" id="collapseComments">
                                    <div class="d-flex mb-3">
                                        <div class="flex-shrink-0 me-2">
                                            <img id="myCommentProfileImg" src="${pageContext.request.contextPath}/images/default_profile.png" class="comment-profile-img" alt="나">
                                        </div>
                                        <div class="flex-grow-1">
                                            <input type="text" id="replyInput" class="form-control" placeholder="댓글을 입력하세요...">
                                        </div>
                                        <button type="button" id="btnReplySubmit" class="btn btn-primary ms-2">등록</button>
                                    </div>

                                    <div class="comment-list-container">
                                        </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal fade" id="profileImageModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header border-0 pb-0">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="modal-profile-container">
                    <img id="modalProfilePreview" src="" class="modal-profile-img-preview" alt="프로필 확대">
                    
                    <button type="button" class="btn-edit-photo-overlay" id="btnTriggerFile">
                        <i class="fas fa-camera me-2"></i>사진 변경
                    </button>
                </div>
                <input type="file" id="profileFileInput" accept="image/*" style="display: none;">
                
                <div class="text-center mt-3 d-none" id="saveBtnContainer">
                     <p class="text-info small mb-2"><i class="fas fa-info-circle"></i> '저장'을 눌러야 반영됩니다.</p>
                     <button type="button" class="btn btn-primary px-4" id="btnSaveProfileImage">저장하기</button>
                </div>
            </div>
        </div>
    </div>
</div>
                </main>
            
            <jsp:include page="common/footer.jsp" flush="true"/>
            <jsp:include page="common/developer_info.jsp" flush="true"/>

        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
        const dateElement = document.getElementById('currentDate');
        const options = { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' };
        dateElement.innerText = new Date().toLocaleDateString('ko-KR', options);
        
        var LOGIN_EMP_NO = "${sessionScope.login.empNo}";
        var DEFAULT_IMG = "${pageContext.request.contextPath}/images/default_profile.png"; // 기본 이미지 경로

        $(document).ready(function() {
            /* 1. 프로필 사진 로드 (왼쪽 사이드바 & 대시보드 내 정보 & 댓글창 내 프사) */
            var myEmpNo = '${sessionScope.login.empNo}';
            if(myEmpNo) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/emp/myInfo', 
                    type: 'GET',
                    success: function(htmlData) {
                        var $temp = $('<div>').html(htmlData);
                        var imgSrc = $temp.find('.emp-photo-placeholder img').attr('src');
                        if(imgSrc) {
                            $('#dashboardProfileImg').attr('src', imgSrc);
                            $('#myCommentProfileImg').attr('src', imgSrc); // 댓글 입력창 옆 내 사진도 업데이트
                        }
                    }
                });
            }

            // 부서 주소록 검색 필터링
            var searchInput = document.getElementById('deptSearchInput');
            if(searchInput){
                searchInput.addEventListener('keyup', function() {
                    var value = this.value.toLowerCase();
                    var rows = document.querySelectorAll('#deptAddressTable tbody tr');
                    rows.forEach(function(row) {
                        var text = row.textContent.toLowerCase();
                        row.style.display = text.indexOf(value) > -1 ? '' : 'none';
                    });
                });
            }

            // --------------------------------------------------------------------
            // [중요] 게시판 상세 모달 JS 로직 (이미지 처리 추가)
            // --------------------------------------------------------------------
            var $boardModal = $('#boardModal');
            $boardModal.on('show.bs.modal', function(event) {
                var button = $(event.relatedTarget);
                var no = button.data('no');
                var title = button.data('title');
                var writer = button.data('writer');
                var date = button.data('date');
                var type = button.data('type'); 

                // 초기 UI 텍스트 세팅
                $boardModal.find('#modalTitleText').text(title);
                $boardModal.find('#modalWriterText').text(writer || '작성자 정보 없음');
                $boardModal.find('#modalDateText').text(date || '-');
                $boardModal.find('#modalContentText').text('내용 로딩중...');
                
                // [NEW] 작성자 이미지 초기화 (일단 기본 이미지로) -> AJAX 성공 시 교체
                $boardModal.find('#modalWriterImg').attr('src', DEFAULT_IMG);

                $('#collapseComments').collapse('hide');
                $('#btnToggleComment').html('<i class="far fa-comment-dots me-1"></i> 댓글');

                var url = '';
                var dataObj = {};

                // 대시보드 로직: 공지사항 vs 자유게시판 구분
                if (type === 'global-notice' || type === 'dept-notice') {
                    url = '/board/getContentNoticeBoard';
                    dataObj = { noticeNo: no };
                    $('#currentNoticeNo').val(no);
                    $('#currentBoardNo').val('');
                } else {
                    url = '/board/getContentFreeBoard';
                    dataObj = { boardNo: no };
                    $('#currentBoardNo').val(no);
                    $('#currentNoticeNo').val('');
                }
                $('#currentBoardType').val(type);

                // 내용 로드 AJAX
                $.ajax({
                    url : url,
                    type : 'POST',
                    data : dataObj,
                    dataType : 'json',
                    success : function(response) {
                        var content = response.noticeContent || response.boardContent;
                        
                        // [NEW] 작성자 이미지 처리
                        var writerImg = response.empImage; 
                        if(writerImg) {
                            $boardModal.find('#modalWriterImg').attr('src', '${pageContext.request.contextPath}/upload/emp/' + writerImg);
                        } else {
                            $boardModal.find('#modalWriterImg').attr('src', DEFAULT_IMG);
                        }

                        if (content) {
                            $boardModal.find('#modalContentText').text(content);
                        } else {
                            $boardModal.find('#modalContentText').text('내용을 불러올 수 없습니다.');
                        }
                    },
                    error : function() {
                        $boardModal.find('#modalContentText').text('오류가 발생했습니다.');
                    }
                });
            });

            // 모달이 열린 후 댓글 로드
            $boardModal.on('shown.bs.modal', function() {
                loadReplies();
            });

            // 댓글 등록 이벤트
            $('#btnReplySubmit').on('click', function() {
                let content = $('#replyInput').val();
                let noticeNo = $('#currentNoticeNo').val();
                let boardNo = $('#currentBoardNo').val();

                if(!content.trim()) {
                    alert("댓글 내용을 입력하세요.");
                    return;
                }

                let sendData = {
                    replyContent: content,
                    noticeNo: noticeNo || null,
                    boardNo: boardNo || null
                };

                $.ajax({
                    url: '/replies/insert',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(sendData),
                    success: function(res) {
                        if(res === "success") {
                            $('#replyInput').val('');
                            loadReplies();
                        } else {
                            alert("댓글 등록에 실패했습니다.");
                        }
                    },
                    error: function(err) { console.log("에러 발생", err); }
                });
            });
         // 1. 대시보드 프로필 사진 클릭 -> 모달 열기
            $('#dashboardProfileImg').on('click', function() {
                var currentSrc = $(this).attr('src');
                $('#modalProfilePreview').attr('src', currentSrc);
                $('#saveBtnContainer').addClass('d-none'); // 저장 버튼 숨김 초기화
                $('#profileImageModal').modal('show');
            });

            // 2. '사진 변경' 버튼 클릭 -> 숨겨진 file input 클릭
            $('#btnTriggerFile').on('click', function() {
                $('#profileFileInput').click();
            });

            // 3. 파일 선택 시 -> 미리보기 변경 및 저장 버튼 표시
            $('#profileFileInput').on('change', function(e) {
                var file = e.target.files[0];
                if(file) {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        $('#modalProfilePreview').attr('src', e.target.result); // 미리보기 갱신
                        $('#saveBtnContainer').removeClass('d-none'); // 저장 버튼 표시
                    }
                    reader.readAsDataURL(file);
                }
            });

            // 4. '저장하기' 버튼 클릭 -> AJAX 전송
            $('#btnSaveProfileImage').on('click', function() {
                var file = $('#profileFileInput')[0].files[0];
                if(!file) {
                    alert("선택된 파일이 없습니다.");
                    return;
                }

                // FormData 생성
                var formData = new FormData();
                formData.append("empNo", "${sessionScope.login.empNo}"); // 세션의 사번
                formData.append("empImageFile", file);

                $.ajax({
                    url: '${pageContext.request.contextPath}/emp/updateProfileImage', // 새로 만든 컨트롤러 메소드
                    type: 'POST',
                    data: formData,
                    processData: false, // 파일 전송 시 필수
                    contentType: false, // 파일 전송 시 필수
                    success: function(response) {
                        if(response === "FAIL" || response === "DENY" || response === "ERROR") {
                            alert("사진 변경에 실패했습니다. (코드: " + response + ")");
                        } else if (response === "FILE_SIZE" || response === "FILE_TYPE") {
                            alert("파일 형식이 맞지 않거나 용량이 너무 큽니다.");
                        } else {
                            // 성공 시 (response는 새로운 파일명)
                            alert("프로필 사진이 변경되었습니다.");
                            
                            // 화면의 모든 프로필 이미지 소스 갱신 (새로고침 없이 반영)
                            var newSrc = '${pageContext.request.contextPath}/upload/emp/' + response;
                            $('#dashboardProfileImg').attr('src', newSrc);
                            $('#modalProfilePreview').attr('src', newSrc);
                            $('#myCommentProfileImg').attr('src', newSrc); // 댓글창 내 사진도 있다면 갱신
                            
                            // 모달 닫기
                            $('#profileImageModal').modal('hide');
                        }
                    },
                    error: function() {
                        alert("서버 통신 오류가 발생했습니다.");
                    }
                });
            });
        });

        // 댓글 목록 로드 함수
        function loadReplies() {
            let noticeNo = $('#currentNoticeNo').val();
            let boardNo = $('#currentBoardNo').val();
            let dataObj = noticeNo ? { noticeNo: noticeNo } : { boardNo: boardNo };

            $.ajax({
                url: '/replies/list',
                type: 'GET',
                data: dataObj,
                dataType: 'json', 
                success: function(list) {
                    let totalCount = list ? list.length : 0;
                    $('#btnToggleComment').html('<i class="far fa-comment-dots me-1"></i> 댓글 (' + totalCount + ')');
                    
                    let html = '';
                    if(!list || list.length === 0){
                        html = '<p class="text-center text-muted my-3">작성된 댓글이 없습니다.</p>';
                    } else {
                        list.forEach(reply => {
                            let date = new Date(reply.replyCreatedAt);
                            let dateStr = date.toISOString().split('T')[0] + " " + date.toTimeString().split(' ')[0].substring(0,5);
                            let writerDisplay = (reply.replyWriterName || reply.replyWriterEmpNo) + (reply.replyWriterJob ? ' (' + reply.replyWriterJob + ')' : '');
                            
                            // [NEW] 댓글 작성자 이미지 경로 설정
                            let replyImgSrc = DEFAULT_IMG;
                            if(reply.replyWriterImage) {
                                replyImgSrc = '${pageContext.request.contextPath}/upload/emp/' + reply.replyWriterImage;
                            }

                            html += '<div class="comment-card" id="reply-' + reply.replyNo + '">';
                            
                            // [NEW] 댓글 레이아웃 수정: flex 사용 (왼쪽 사진, 오른쪽 내용)
                            html += '  <div class="d-flex">';
                            // 1. 프로필 이미지
                            html += '    <div class="flex-shrink-0">';
                            html += '      <img src="' + replyImgSrc + '" class="comment-profile-img" alt="프로필">';
                            html += '    </div>';
                            
                            // 2. 내용 영역
                            html += '    <div class="flex-grow-1">';
                            html += '      <div class="d-flex justify-content-between align-items-center">';
                            html += '        <strong class="text-dark">' + writerDisplay + '</strong>';
                            html += '        <small class="text-muted">' + dateStr + '</small>';
                            html += '      </div>';
                            html += '      <p class="mb-0 mt-1 text-secondary small">' + reply.replyContent + '</p>';
                            
                            if (LOGIN_EMP_NO == reply.replyWriterEmpNo) {
                                html += '      <div class="mt-1 text-end">';
                                html += '        <button class="btn btn-sm btn-link text-danger p-0 text-decoration-none" onclick="deleteReply(' + reply.replyNo + ')">삭제</button>';
                                html += '      </div>';
                            }
                            html += '    </div>'; // end flex-grow-1
                            html += '  </div>'; // end d-flex
                            html += '</div>'; // end comment-card
                        });
                    }
                    $('.comment-list-container').html(html);
                },
                error: function(err){ console.log("댓글 로드 실패", err); }
            });
        }

        // 댓글 삭제 함수
        window.deleteReply = function(replyNo) {
            if(!confirm("정말 삭제하시겠습니까?")) return;
            $.ajax({
                url: '/replies/delete',
                type: 'POST',
                data: { replyNo: replyNo },
                success: function(res) {
                    if(res === "success") {
                        loadReplies();
                    } else {
                        alert("삭제 실패");
                    }
                }
            });
        };
    </script>
</body>
</html>