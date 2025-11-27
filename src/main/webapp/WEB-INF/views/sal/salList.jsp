<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
request.setAttribute("menu", "sallist");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    
    <!-- 헤더 -->
<jsp:include page="../common/header.jsp" flush="true" />

<div id="layoutSidenav">

	<!-- 헤더 끝 -->
	
	<!-- 사이드 -->
	<jsp:include page="../common/sidebar.jsp" flush="true" />

	<div id="layoutSidenav_content">
		<main>
			<div class="container-fluid px-4">
				<h3 class="mt-4">급여관리</h3>
				<br>

				<!-- 사이드 끝-->
				
				
    <title>급여 명세서 일람</title>

    <style>
        .content-wrapper {
            padding: 20px 30px;
        }
        .page-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .emp-info {
            margin-bottom: 10px;
            font-size: 14px;
        }
        .salary-box {
            background-color: #f7f7f7;
            border-radius: 8px;
            padding: 20px;
        }
        table.salary-table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
        }
        table.salary-table th,
        table.salary-table td {
            border: 1px solid #ddd;
            padding: 8px 10px;
            text-align: center;
            font-size: 13px;
        }
        table.salary-table th {
            background-color: #fafafa;
            font-weight: 600;
        }
        .text-right {
            text-align: right;
        }
    </style>
</head>
<body>

<!-- 상단 헤더/왼쪽 메뉴는 공통 include라고 가정 -->
<div class="content-wrapper">

    <!-- 1. 급여 대장 제목 -->
    <div class="page-title">급여 대장</div>

    <!-- 2. 사원 이름 / 번호 표시 -->
    <div class="emp-info">
        사원 이름 : <strong>${emp.empName}</strong>
        &nbsp;|&nbsp;
        사번 : <strong>${emp.empNo}</strong>
        <c:if test="${not empty emp.deptName}">
            &nbsp;|&nbsp; 부서 : <strong>${emp.deptName}</strong>
        </c:if>
    </div>

    <!-- 3. 급여 내역 테이블 -->
    <div class="salary-box">
        <table class="salary-table">
            <thead>
            <tr>
                <th>급여 날짜</th>
                <th>기본급</th>
                <th>추가 수당</th>
                <th>공제 금액</th>
                <th>총 합계</th>
            </tr>
            </thead>
            <tbody>
            <c:if test="${empty salList}">
                <tr>
                    <td colspan="6">등록된 급여 내역이 없습니다.</td>
                </tr>
            </c:if>

            <c:forEach var="sal" items="${salList}">
                <tr>
                    <td>${sal.salDate}</td>
                    <td>${sal.monthAttno}</td>
                    <td class="text-right">${sal.salBase}</td>
                    <td class="text-right">
                        <c:out value="${sal.salPlus + (sal.salBonus == null ? 0 : sal.salBonus)}" />
                    </td>
                    <td class="text-right">
                        <c:out value="${sal.insurance + sal.tax}" />
                    </td>
                    <td class="text-right">${sal.realPay}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <!-- 푸터 -->
		<jsp:include page="../common/footer.jsp" flush="true" />
   
</div>

</body>
</html>