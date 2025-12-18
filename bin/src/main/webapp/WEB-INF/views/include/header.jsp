<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div id="header">
	<div class="logo">
		<a href="${pageContext.request.contextPath}/">인사관리 시스템</a>
	</div>

	<div class="nav">
		<ul>
			<!-- 로그인 안 됨 -->
			<c:if test="${empty login}">
				<li><a href="${pageContext.request.contextPath}/member/login">로그인</a></li>
			</c:if>

			<!-- 로그인 됨 -->
			<c:if test="${login.gradeNo == '1'}">
				<!-- 관리자 메뉴 -->
				<li><a href="${pageContext.request.contextPath}/sal/admin/list">
						급여 관리 </a></li>
			</c:if>

			<c:if test="${login.gradeNo != '1'}">
				<!-- 사원 메뉴: 본인 급여 명세서 -->
				<li><a href="${pageContext.request.contextPath}/sal/list">
						급여 명세서 </a></li>
			</c:if>

			<li><a href="${pageContext.request.contextPath}/logout">로그아웃</a></li>
			</c:if>
		</ul>
	</div>
</div>