<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ACCESS DENIED | 권한 제한</title>
<style>
    /* 기존 스타일 유지 */
    .error-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 70vh;
        text-align: center;
        background-color: #fff;
        color: #333;
        font-family: 'Pretendard', sans-serif;
    }

    .warning-icon {
        font-size: 80px;
        color: #e74c3c;
        margin-bottom: 20px;
        animation: pulse 1.5s infinite;
    }

    @keyframes pulse {
        0% { transform: scale(1); opacity: 1; }
        50% { transform: scale(1.1); opacity: 0.7; }
        100% { transform: scale(1); opacity: 1; }
    }

    .error-title {
        font-size: 2.5rem;
        font-weight: 800;
        color: #1a1a1a;
        margin-bottom: 10px;
        letter-spacing: -1px;
    }

    .error-msg {
        font-size: 1.1rem;
        color: #666;
        line-height: 1.6;
        margin-bottom: 30px;
    }

    .error-msg b {
        color: #e74c3c;
    }

    .btn-group {
        display: flex;
        gap: 15px;
    }

    .btn-home {
        padding: 12px 25px;
        background-color: #1a1a1a;
        color: white;
        text-decoration: none;
        border-radius: 8px;
        font-weight: 600;
        transition: all 0.3s;
    }

    .btn-home:hover { background-color: #444; transform: translateY(-2px); }

    .btn-back {
        padding: 12px 25px;
        background-color: #f2f2f2;
        color: #333;
        text-decoration: none;
        border-radius: 8px;
        font-weight: 600;
        transition: all 0.3s;
    }

    .btn-back:hover { background-color: #ddd; }
    
    /* 관리자 정보 강조 스타일 */
    .admin-info {
        margin-top: 40px;
        color: #858796;
        font-size: 0.95rem;
        padding: 15px 25px;
        background: #f8f9fc;
        border-radius: 50px;
        border: 1px solid #e3e6f0;
    }
</style>
</head>

<body class="sb-nav-fixed">

    <jsp:include page="../common/header.jsp" flush="true" />

    <div id="layoutSidenav">
        <jsp:include page="../common/sidebar.jsp" flush="true" />

        <div id="layoutSidenav_content">
            <main>
                <div class="error-container">
                    <div class="warning-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" fill="currentColor" viewBox="0 0 16 16">
                          <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                        </svg>
                    </div>

                    <h2 class="error-title">ACCESS DENIED</h2>
                    <p class="error-msg">
                        죄송합니다. 현재 페이지에 접근할 수 있는 <b>권한이 없습니다.</b><br>
                        인가되지 않은 접근이 감지되었거나, 시스템 등급이 부족합니다.
                    </p>

                    <div class="btn-group">
                        <a href="javascript:history.back();" class="btn-back">이전 페이지로</a>
                        <a href="${pageContext.request.contextPath}/" class="btn-home">메인으로 이동</a>
                    </div>
                    
                    <%-- 부서장 정보를 찾기 위한 로직  --%>
                    <c:set var="myManager" value="시스템 관리자" />
                    <c:forEach var="dept" items="${deptList}">
                        <c:if test="${dept.deptNo == sessionScope.login.deptNo}">
                            <c:set var="myManager" value="${dept.managerName}" />
                        </c:if>
                    </c:forEach>

                    <div class="admin-info">
                        <i class="fas fa-user-shield"></i> 권한 문의: 
                        <strong>
                            <c:out value="${myManager}" default="관리자" />
                        </strong> 
                        <span style="margin-left:5px; opacity: 0.7;">(소속 부서장)</span>
                    </div>
                </div>
            </main>

            <jsp:include page="../common/footer.jsp" flush="true" />
            <jsp:include page="../common/developer_info.jsp" flush="true" />
        </div>
    </div>
</body>
</html>