<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
            <c:if test="${not empty login}">
                <li>${login.empName} 님 (${login.empNo})</li>

                <!-- 공통 메뉴 -->
                <li><a href="${pageContext.request.contextPath}/mypage">마이페이지</a></li>
                <li><a href="${pageContext.request.contextPath}/sal/list?empNo=${login.empNo}">내 급여 명세</a></li>

                <!-- 🔥 관리자 전용 메뉴 (gradeNo == 1) -->
                <c:if test="${login.gradeNo == '1'}">
                    <li><a href="${pageContext.request.contextPath}/sal/admin/list">급여 관리(관리자)</a></li>
                    <li><a href="${pageContext.request.contextPath}/emp/admin/list">사원 관리</a></li>
                </c:if>

                <li><a href="${pageContext.request.contextPath}/logout">로그아웃</a></li>
            </c:if>
        </ul>
    </div>
</div>