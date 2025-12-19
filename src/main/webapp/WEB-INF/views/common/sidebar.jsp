<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
String menu = (String) request.getAttribute("menu");
if (menu == null)
	menu = "";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>sidebar.jsp</title>
<style>
    /* 아이콘 공통 스타일: 입체감과 가독성을 위한 명암 효과 */
    .sb-nav-link-icon i {
        filter: drop-shadow(1px 1px 1px rgba(0, 0, 0, 0.15));
        font-size: 1.1rem;
    }

    /* 각 메뉴별 파스텔톤 색상 지정 */
    .icon-mypage { color: #FFB7C5; }    /* 연분홍 (기준점) */
    .icon-notice { color: #A7D8FF; }    /* 연하늘 (공지 게시판) */
    .icon-free { color: #B2EBF2; }      /* 민트하늘 (자유 게시판) */
    .icon-attend { color: #FFD180; }    /* 연주황 (근태 관리) */
    .icon-emp { color: #D1C4E9; }       /* 연보라 (사원 관리) */
    .icon-dept { color: #C8E6C9; }      /* 연초록 (부서 관리) */
    .icon-approval { color: #FFF59D; }  /* 연노랑 (전자 결재) */
    .icon-salary { color: #F8BBD0; }    /* 연피치 (급여 관리) */
</style>
</head>
<body>
	<div id="layoutSidenav_nav">
		<nav class="sb-sidenav accordion sb-sidenav-light"
			id="sidenavAccordion">
			<div class="sb-sidenav-menu">
				<div class="nav">
					<div class="sb-sidenav-menu-heading">관리자용</div>
					<a class="nav-link" href="/">
						<div class="sb-nav-link-icon">
							<i class="fas fa-tachometer-alt icon-mypage"></i>
						</div> 마이페이지
					</a>

					<div class="sb-sidenav-menu-heading">게시판</div>
					<a class="nav-link" href="/board/getNoticeBoardList">
						<div class="sb-nav-link-icon">
							<i class="fas fa-table icon-notice"></i>
						</div> 공지 게시판
					</a><a class="nav-link" href="/board/getFreeBoardList">
						<div class="sb-nav-link-icon">
							<i class="fas fa-table icon-free"></i>
						</div> 자유 게시판
					</a>


					<div class="sb-sidenav-menu-heading">메인 메뉴</div>
					<%--근태 관리 --%>
					<a class="nav-link" href="/attend/attend">
						<div class="sb-nav-link-icon">
							<i class="fas fa-columns icon-attend"></i>
						</div> 근태관리
					</a>

					<c:if
						test="${not empty sessionScope.login 
            and (sessionScope.login.gradeNo eq '1' or sessionScope.login.gradeNo eq '2')}">

						<%-- 사원 관리 --%>
						<a class="nav-link collapsed" href="#" data-bs-toggle="collapse"
							data-bs-target="#collapseEmp" aria-expanded="false"
							aria-controls="collapseEmp">
							<div class="sb-nav-link-icon">
								<i class="fas fa-book-open icon-emp"></i>
							</div> 사원관리
							<div class="sb-sidenav-collapse-arrow">
								<i class="fas fa-angle-down"></i>
							</div>
						</a>

						<div
							class="collapse <%=(menu.equals("emp") ||
menu.equals("empNew")) ? "show" : ""%>"
							id="collapseEmp" aria-labelledby="headingOne"
							data-bs-parent="#sidenavAccordion">

							<nav class="sb-sidenav-menu-nested nav">
								<a class="nav-link <%=menu.equals("emp") ? "active" : ""%>"
									href="${pageContext.request.contextPath}/emp/list"> 사원 목록 </a>

								<a class="nav-link <%=menu.equals("empNew") ?
"active" : ""%>"
									href="${pageContext.request.contextPath}/emp/new"> 사원 등록 </a>
							</nav>
						</div>

					</c:if>



					<%--부서 관리 --%>
					<a class="nav-link collapsed" href="/dept/dept">
						<div class="sb-nav-link-icon">
							<i class="fas fa-book-open icon-dept"></i>
						</div> 부서관리
					</a>

					<%--결재 관리 --%>
					<a class="nav-link collapsed" href="#" data-bs-toggle="collapse"
						data-bs-target="#collapseApproval" aria-expanded="false"
						aria-controls="collapseLayouts">
						<div class="sb-nav-link-icon">
							<i id="approvalIcon" class="fas fa-columns icon-approval"></i>
						</div> 전자결재
						<div class="sb-sidenav-collapse-arrow">
							<i class="fas fa-angle-down"></i>
						</div>
					</a>
					<div
						class="collapse <%=menu.equals("status") ||
menu.equals("receive") || menu.equals("send") || menu.equals("finish")
		|| menu.equals("create") ? "show" : ""%>"
						id="collapseApproval" aria-labelledby="headingOne"
						data-bs-parent="#sidenavAccordion">
						<nav class="sb-sidenav-menu-nested nav">
							<a class="nav-link  <%=menu.equals("status") ?
"active" : ""%>" href="/approve/statusList">결재 현황</a>
							<c:if test="${not empty sessionScope.login and (sessionScope.login.gradeNo eq '1' or sessionScope.login.gradeNo eq '2' or sessionScope.login.gradeNo eq '3')}">
								<a class="nav-link <%=menu.equals("receive") ?
"active" : ""%>" href="/approve/receiveList"> 결재 할 문서 
									<span id="badgeId" class="notification-badge" style="display: none;"></span>
								</a>
							</c:if>
							<a class="nav-link <%=menu.equals("send") ?
"active" : ""%>" href="/approve/sendList">결재 받을 문서</a>
							<a class="nav-link <%=menu.equals("finish") ? "active" : ""%>" href="/approve/finishList">결재 완료 문서</a>
							<a class="nav-link <%=menu.equals("create") ?
"active" : ""%>" href="/approve/createForm">문서 작성 하기</a>
						</nav>
					</div>

					<%--급여 관리 --%>
					<a class="nav-link <%=menu.equals("salemp") ?
"active" : ""%>"
						href="${pageContext.request.contextPath}/sal">
						<div class="sb-nav-link-icon">
							<i class="fas fa-columns icon-salary"></i>
						</div> 급여관리
					</a>

				</div>
			</div>
			<div class="sb-sidenav-footer">
				<div class="small">Logged in as:</div>
				Start Bootstrap
			</div>
		</nav>
	</div>

</body>
</html>