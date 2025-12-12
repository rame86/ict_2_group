<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

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
</head>
<body>
	<div id="layoutSidenav_nav">
		<nav class="sb-sidenav accordion sb-sidenav-light"
			id="sidenavAccordion">
			<div class="sb-sidenav-menu">
				<div class="nav">
					<div class="sb-sidenav-menu-heading">관리자용</div>
					<a class="nav-link" href="index.html">
						<div class="sb-nav-link-icon">
							<i class="fas fa-tachometer-alt"></i>
						</div> 마이페이지
					</a>

					<div class="sb-sidenav-menu-heading">게시판</div>
					<a class="nav-link" href="/board/getNoticeBoardList">
						<div class="sb-nav-link-icon">
							<i class="fas fa-table"></i>
						</div> 공지 게시판
					</a><a class="nav-link" href="/board/getFreeBoardList">
						<div class="sb-nav-link-icon">
							<i class="fas fa-table"></i>
						</div> 자유 게시판
					</a>


					<div class="sb-sidenav-menu-heading">메인 메뉴</div>
					<%--근태 관리 --%>
					<a class="nav-link" href="/attend/attend">
						<div class="sb-nav-link-icon">
							<i class="fas fa-columns"></i>
						</div> 근태관리
					</a>

					<%-- 사원 관리 --%>
					<a class="nav-link collapsed" href="#" data-bs-toggle="collapse"
						data-bs-target="#collapseEmp" aria-expanded="false"
						aria-controls="collapseEmp">
						<div class="sb-nav-link-icon">
							<i class="fas fa-book-open"></i>
						</div> 사원관리
						<div class="sb-sidenav-collapse-arrow">
							<i class="fas fa-angle-down"></i>
						</div>
					</a>

					<div
						class="collapse <%=(menu.equals("emp") || menu.equals("empNew")) ? "show" : ""%>"
						id="collapseEmp" aria-labelledby="headingOne"
						data-bs-parent="#sidenavAccordion">

						<nav class="sb-sidenav-menu-nested nav">

							<a class="nav-link <%=menu.equals("emp") ? "active" : ""%>"
								href="${pageContext.request.contextPath}/emp/list"> 사원 목록 </a> <a
								class="nav-link <%=menu.equals("empNew") ? "active" : ""%>"
								href="${pageContext.request.contextPath}/emp/new"> 사원 등록 </a>

						</nav>
					</div>


					<%--부서 관리 --%>
					<a class="nav-link collapsed" href="/dept/dept">
						<div class="sb-nav-link-icon">
							<i class="fas fa-book-open"></i>
						</div> 부서관리						
					</a>

					<%--결재 관리 --%>
					<a class="nav-link collapsed" href="#" data-bs-toggle="collapse"
						data-bs-target="#collapseApproval" aria-expanded="false"
						aria-controls="collapseLayouts">
						<div class="sb-nav-link-icon">
							<i id="approvalIcon" class="fas fa-columns"></i>
						</div> 전자결재
						<div class="sb-sidenav-collapse-arrow">
							<i class="fas fa-angle-down"></i>
						</div>
					</a>
					<div
						class="collapse <%=menu.equals("status") || menu.equals("receive") || menu.equals("send") || menu.equals("finish")
		|| menu.equals("create") ? "show" : ""%>"
						id="collapseApproval" aria-labelledby="headingOne"
						data-bs-parent="#sidenavAccordion">
						<nav class="sb-sidenav-menu-nested nav">
							<a class="nav-link  <%=menu.equals("status") ? "active" : ""%>"
								href="/approve/statusList">결재 현황</a> <a
								class="nav-link <%=menu.equals("receive") ? "active" : ""%>"
								href="/approve/receiveList"> 결재 할 문서 <span id="badgeId"
								class="notification-badge" style="display: none;"></span></a> <a
								class="nav-link <%=menu.equals("send") ? "active" : ""%>"
								href="/approve/sendList">결재 받을 문서</a> <a
								class="nav-link <%=menu.equals("finish") ? "active" : ""%>"
								href="/approve/finishList">결재 완료 문서</a> <a
								class="nav-link <%=menu.equals("create") ? "active" : ""%>"
								href="/approve/createForm">문서 작성 하기</a>
						</nav>
					</div>

					<%--급여 관리 --%>
					<a class="nav-link <%=menu.equals("salemp") ? "active" : ""%>"
						href="${pageContext.request.contextPath}/sal/list">
						<div class="sb-nav-link-icon">
							<i class="fas fa-columns"></i>
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