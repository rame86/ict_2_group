<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>PeopleSync - Dashboard</title>
    
    <style>
        /* 대시보드 통계 카드 아이콘 */
        .dashboard-card-icon {
            font-size: 3rem;
            opacity: 0.3;
            position: absolute;
            right: 20px;
            top: 20px;
        }
        
        /* 웰컴 배너 */
        .welcome-banner {
            background: linear-gradient(45deg, #212529, #343a40);
            color: white;
            border-radius: 0.5rem;
        }

        /* 빠른 실행 (가로형) 스타일 */
        .quick-menu-container {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }
        .quick-menu-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 15px;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            background-color: #f8f9fa;
            text-decoration: none;
            color: #495057;
            transition: all 0.3s ease;
            height: 100%;
        }
        .quick-menu-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            background-color: #fff;
            border-color: #0d6efd;
            color: #0d6efd;
        }
        .quick-menu-item i {
            font-size: 2rem;
            margin-bottom: 10px;
        }

        /* 내 정보 미니 프로필 카드 스타일 */
        .profile-card {
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            text-align: center;
            padding: 30px 20px;
        }
        .profile-img-container {
            width: 140px;
            height: 140px;
            margin: 0 auto 20px;
            border-radius: 50%;
            padding: 5px;
            border: 3px solid #e3e6f0;
            overflow: hidden;
            position: relative;
        }
        .profile-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }
        .profile-name {
            font-size: 1.5rem;
            font-weight: 800;
            color: #2e384d;
            margin-bottom: 5px;
        }
        .profile-dept {
            color: #858796;
            font-size: 0.95rem;
            margin-bottom: 15px;
        }
        .profile-badge {
            display: inline-block;
            padding: 6px 15px;
            background-color: #4e73df;
            color: white;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .profile-info-row {
            margin-top: 25px;
            display: flex;
            justify-content: space-around;
            border-top: 1px solid #eaecf4;
            padding-top: 20px;
        }
        .profile-info-item h6 {
            color: #b7b9cc;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        .profile-info-item span {
            color: #5a5c69;
            font-weight: 700;
            font-size: 1.1rem;
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
                                                                    <td><a href="/board/getNoticeBoardList" class="text-dark text-decoration-none"><span class="badge bg-danger me-1">전체</span>${notice.noticeTitle}</a></td>
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
                                             <div class="text-center py-4">부서 공지 탭 내용</div>
                                        </div>
                                        <div class="tab-pane fade" id="dept-free">
                                             <div class="text-center py-4">부서 게시판 탭 내용</div>
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
                                        <a href="/member/list" class="quick-menu-item">
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
                                           ${sessionScope.login.gradeNo == 1 ? 'CEO' : 
                                             sessionScope.login.gradeNo == 2 ? '관리자' : '사원'}
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
                                            <h6 class="mb-0 fw-bold">시스템 공지</h6>
                                            <small class="text-muted">서버 점검 예정 (12/25)</small>
                                        </div>
                                        <i class="fas fa-info-circle text-info fs-4"></i>
                                    </div>
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

        $(document).ready(function() {
            /* 프로필 사진 로드 (기존 로직 유지) */
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
                        }
                    }
                });
            }
        });
    </script>
</body>
</html>